library adaptive_sidebar;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

part 'enums/sidebar_style.dart';
part 'models/sidebar_destination.dart';
part 'widgets/as_destination.dart';
part 'utils.dart';

class AdaptiveSidebar extends StatefulWidget {
  final Widget child;
  final List<SidebarDestination> destinations;

  /// This will be shown on top of the destination list
  final SidebarDestination? pinnedDestination;

  /// These destinations will be pinned at the footer
  final List<SidebarDestination> footerDestinations;

  /// Called when a new destination has been selected
  final void Function(int index) onPageChange;

  /// Icon shown before the title
  final Widget? icon;
  final String? title;
  final TextStyle? titleStyle;
  final double maxLargeSidebarSize;
  final double iconTitleSpacing;

  /// Add 30px padding to the top on macOS
  final bool macOSTopPadding;

  /// Auto enable medium layout if passing medium breakpoint
  final bool mediumAuto;

  /// The breakpoint size of the child space for the medium icon only layout
  final double mediumBreakpoint;

  /// Style of the sidebar
  ///
  /// Default: flat
  final ASStyle style;
  const AdaptiveSidebar({
    super.key,
    required this.child,
    required this.destinations,
    required this.onPageChange,
    this.title,
    this.titleStyle,
    this.icon,
    this.pinnedDestination,
    this.footerDestinations = const [],
    this.maxLargeSidebarSize = 192,
    this.iconTitleSpacing = 10,
    this.macOSTopPadding = true,
    this.mediumAuto = true,
    this.mediumBreakpoint = 850.0,
    this.style = ASStyle.flat,
  });

  @override
  State<AdaptiveSidebar> createState() => _AdaptiveSidebarState();
}

class _AdaptiveSidebarState extends State<AdaptiveSidebar> {
  bool iconsOnly = false;
  int _index = 0;

  void mediumCheck(double maxWidth) {
    //Check if medium layout should be disabled
    if (maxWidth >= (widget.mediumBreakpoint + (widget.maxLargeSidebarSize - 58)) && iconsOnly) {
      iconsOnly = false;
    }

     //Check if medium layout should be enabled
    if (maxWidth < widget.mediumBreakpoint && !iconsOnly) {
      iconsOnly = true;
    }
  }

  double topPadding() {
    //Top macOS padding
    if (Platform.isMacOS && !kIsWeb && widget.macOSTopPadding) {
      return 35;
    }
    if (Platform.isIOS && !kIsWeb || Platform.isAndroid && !kIsWeb) {
      return 20;
    }
    return 0;
  }

  double floatingTopPadding() {
    //Top macOS padding
    if (Platform.isMacOS && !kIsWeb && widget.macOSTopPadding) {
      return 47;
    }
    if (Platform.isIOS && !kIsWeb || Platform.isAndroid && !kIsWeb) {
      return 20;
    }
    return 10;
  }

  double sidebarWidth() {
    if (iconsOnly) {
      return 58;
    }
    return widget.maxLargeSidebarSize;
  }

  Decoration decoration() {
    //Floating sidebar style
    if (widget.style == ASStyle.floating) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 15,
          ),
        ],
        color: Theme.of(context).cardColor,
      );
    }

    return BoxDecoration(
      color: Theme.of(context).bottomAppBarTheme.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Sidebar
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: widget.style == ASStyle.floating
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).bottomAppBarTheme.color,
          child: SafeArea(
            child: Container(
              padding: widget.style == ASStyle.flat
                  ? EdgeInsets.only(
                      top: topPadding(),
                    )
                  : null,
              margin: widget.style == ASStyle.floating
                  ? EdgeInsets.only(
                      top: floatingTopPadding(), left: 10, bottom: 10)
                  : null,
              width: sidebarWidth(),
              decoration: decoration(),
              child: Column(
                children: [
                  //Title / Icon Section
                  if (widget.icon != null || widget.title != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, bottom: 5, top: 12),
                      child: Row(
                        children: [
                          //Icon
                          if (widget.icon != null)
                            Padding(
                              padding: iconsOnly
                                  ? EdgeInsets.zero
                                  : EdgeInsets.only(
                                      right: widget.iconTitleSpacing),
                              child: widget.icon!,
                            ),
                          //Title
                          if (widget.title != null && !iconsOnly)
                            Text(
                              widget.title!,
                              style: widget.titleStyle ??
                                  Theme.of(context)
                                      .textTheme
                                      .displayLarge!
                                      .copyWith(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                      ),
                              maxLines: 1,
                              softWrap: false,
                            ),
                        ],
                      ),
                    ),
                  if (widget.icon != null || widget.title != null)
                    const Divider(),
                  //Pinned Destination
                  if (widget.pinnedDestination != null)
                    ASDestination(
                      destination: widget.pinnedDestination!,
                      onTap: () {
                        widget.onPageChange(-1);

                        //Check if destination is a page
                        if (!widget.pinnedDestination!.popup) {
                          _index = -1;
                          setState(() {});
                        }
                      },
                      selected: _index == -1,
                      iconsOnly: iconsOnly,
                    ),
                  if (widget.pinnedDestination != null)
                    const Padding(
                      padding: EdgeInsets.only(left: 17, right: 17, bottom: 7),
                      child: Divider(
                        height: 1,
                      ),
                    ),
                  //Destinations
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeTop: true,
                      child: ListView.builder(
                        primary: false,
                        itemCount: widget.destinations.length,
                        itemBuilder: (context, index) {
                          return ASDestination(
                            destination: widget.destinations[index],
                            onTap: () {
                              widget.onPageChange(index);

                              //Check if destination is a page
                              if (!widget.destinations[index].popup) {
                                _index = index;
                                setState(() {});
                              }
                            },
                            selected: _index == index,
                            iconsOnly: iconsOnly,
                          );
                        },
                      ),
                    ),
                  ),
                  //Footer destination options
                  if (widget.footerDestinations.isNotEmpty)
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: widget.footerDestinations.length,
                      itemBuilder: (context, index) {
                        return ASDestination(
                          destination: widget.footerDestinations[index],
                          onTap: () {
                            widget.onPageChange(
                                widget.destinations.length + index);

                            //Check if destination is a page
                            if (!widget.footerDestinations[index].popup) {
                              _index = widget.destinations.length + index;
                              setState(() {});
                            }
                          },
                          selected:
                              _index == (widget.destinations.length + index),
                          iconsOnly: iconsOnly,
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
        //Content
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              //Check breakpoint size
              if (widget.mediumAuto) {
                mediumCheck(constraints.maxWidth);
              }

              return widget.child;
            },
          ),
        ),
      ],
    );
  }
}
