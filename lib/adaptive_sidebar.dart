library adaptive_sidebar;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

part 'enums/sidebar_style.dart';
part 'models/sidebar_destination.dart';
part 'widgets/as_destination.dart';

/// AdaptiveSidebar
/// 
/// Sleak sidebar for responsive Flutter apps with automatic size change.
class AdaptiveSidebar extends StatefulWidget {
  /// Where to place your PageView widget.
  final Widget body;

  /// Sidebar destinations
  final List<SidebarDestination> destinations;

  /// This will be shown on top of the destination list
  final SidebarDestination? pinnedDestination;

  /// These destinations will be pinned at the footer
  final List<SidebarDestination> footerDestinations;

  /// Called when a new destination has been selected
  final void Function(int index) onPageChange;

  /// Icon shown before the title
  final Widget? icon;

  /// Title of the app [optional]
  final String? title;

  /// Style of the title of the app [optional]
  final TextStyle? titleStyle;

  /// Max size of the sidebar
  ///
  /// Default: 192
  final double maxLargeSidebarSize;

  final double iconTitleSpacing;

  /// Add 30px padding to the top on macOS
  final bool macOSTopPadding;

  /// Auto enable medium layout if passing medium breakpoint
  final bool mediumAuto;

  /// The breakpoint size of the child space for the medium icon only layout
  final double mediumBreakpoint;

  /// Manually enable and disable the medium layout
  final bool mediumManualButton;

  /// Show a bottomNavigationBar on smaller devices useing the bottomNavigationBarBreakpoint. [optional]
  final Widget? bottomNavigationBar;

  /// Breakpoint of when the sidebar is enabled and the bottom navigation bar is no longer used (bottomNavigationBar is optional).
  final double bottomNavigationBarBreakpoint;

  /// Display a widget in the background behind the page and the sidebar. [optional]
  final Widget? backgroundWidget;

  /// Style of the sidebar
  ///
  /// Default: flat
  final ASStyle style;
  const AdaptiveSidebar({
    super.key,
    required this.body,
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
    this.bottomNavigationBar,
    this.bottomNavigationBarBreakpoint = 700.0,
    this.mediumManualButton = false,
    this.style = ASStyle.flat,
    this.backgroundWidget,
  });

  @override
  State<AdaptiveSidebar> createState() => _AdaptiveSidebarState();
}

class _AdaptiveSidebarState extends State<AdaptiveSidebar> {
  ValueNotifier<bool> iconsOnly = ValueNotifier(false);
  int _index = 0;

  void mediumCheck(double maxWidth) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      //Check if medium layout should be disabled
      if (maxWidth >=
              (widget.mediumBreakpoint + (widget.maxLargeSidebarSize - 58)) &&
          iconsOnly.value) {
        iconsOnly.value = false;
        return;
      }

      //Check if medium layout should be enabled
      if (maxWidth < widget.mediumBreakpoint && !iconsOnly.value) {
        iconsOnly.value = true;
        return;
      }
    });
  }

  double topPadding() {
    // Top macOS top padding
    if (Platform.isMacOS && !kIsWeb && widget.macOSTopPadding) {
      return 35;
    }
    // Mobile OS padding
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
    // Mobile OS padding
    if (Platform.isIOS && !kIsWeb || Platform.isAndroid && !kIsWeb) {
      return 20;
    }
    return 10;
  }

  double sidebarWidth(bool val) {
    // Icons only size
    if (val) {
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

  Color floatingSidebarBackground() {
    //Remove color around sidebar
    if (widget.backgroundWidget != null) {
      return Colors.transparent;
    }
    return Theme.of(context).scaffoldBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, fullWindowConstraints) {
        return Stack(
          children: [
            //Background
            if (widget.backgroundWidget != null) widget.backgroundWidget!,
            //Page
            Row(
              children: [
                //Sidebar
                if (fullWindowConstraints.maxWidth >=
                        widget.bottomNavigationBarBreakpoint ||
                    widget.bottomNavigationBar == null)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    color: widget.style == ASStyle.floating
                        ? floatingSidebarBackground()
                        : Theme.of(context).bottomAppBarTheme.color,
                    child: ValueListenableBuilder(
                      valueListenable: iconsOnly,
                      builder: (BuildContext context, bool iconsOnlyValue,
                          Widget? child) {
                        return SafeArea(
                          child: Container(
                            padding: widget.style == ASStyle.flat
                                ? EdgeInsets.only(
                                    top: topPadding(),
                                  )
                                : null,
                            margin: widget.style == ASStyle.floating
                                ? EdgeInsets.only(
                                    top: floatingTopPadding(),
                                    left: 10,
                                    bottom: 10)
                                : null,
                            width: sidebarWidth(iconsOnlyValue),
                            decoration: decoration(),
                            child: Column(
                              children: [
                                // Manual medium button
                                if (widget.mediumManualButton)
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0),
                                        child: CupertinoButton(
                                          child: Icon(
                                            CupertinoIcons.sidebar_left,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          onPressed: () {
                                            iconsOnly.value = !iconsOnly.value;
                                            if (mounted) setState(() {});
                                          },
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                //Title / Icon Section
                                if (widget.icon != null || widget.title != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, bottom: 5, top: 12),
                                    child: Row(
                                      children: [
                                        //Icon
                                        if (widget.icon != null)
                                          Padding(
                                            padding: iconsOnlyValue
                                                ? EdgeInsets.zero
                                                : EdgeInsets.only(
                                                    right: widget
                                                        .iconTitleSpacing),
                                            child: widget.icon!,
                                          ),
                                        //Title
                                        if (widget.title != null &&
                                            !iconsOnlyValue)
                                          Text(
                                            widget.title!,
                                            style: widget.titleStyle ??
                                                Theme.of(context)
                                                    .textTheme
                                                    .displayLarge!
                                                    .copyWith(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                    iconsOnly: iconsOnlyValue,
                                  ),
                                if (widget.pinnedDestination != null)
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 17, right: 17, bottom: 7),
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
                                          destination:
                                              widget.destinations[index],
                                          onTap: () {
                                            widget.onPageChange(index);

                                            //Check if destination is a page
                                            if (!widget
                                                .destinations[index].popup) {
                                              _index = index;
                                              setState(() {});
                                            }
                                          },
                                          selected: _index == index,
                                          iconsOnly: iconsOnlyValue,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                //Footer destination options
                                if (widget.footerDestinations.isNotEmpty)
                                  ...List.generate(
                                    widget.footerDestinations.length,
                                    (int index) {
                                      return ASDestination(
                                        destination:
                                            widget.footerDestinations[index],
                                        onTap: () {
                                          widget.onPageChange(
                                              widget.destinations.length +
                                                  index);

                                          //Check if destination is a page
                                          if (!widget.footerDestinations[index]
                                              .popup) {
                                            _index =
                                                widget.destinations.length +
                                                    index;
                                            setState(() {});
                                          }
                                        },
                                        selected: _index ==
                                            (widget.destinations.length +
                                                index),
                                        iconsOnly: iconsOnlyValue,
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                //Content
                Expanded(
                  child: Column(
                    children: [
                      //Body
                      Expanded(
                        child: MediaQuery.removePadding(
                          removeBottom: widget.bottomNavigationBar !=
                              null, //Remove bottom padding if there is a navigation bar.
                          context: context,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              //Check breakpoint size
                              if (widget.mediumAuto &&
                                  !widget.mediumManualButton) {
                                if (context.mounted) {
                                  mediumCheck(constraints.maxWidth);
                                }
                              }

                              return widget.body;
                            },
                          ),
                        ),
                      ),
                      //Bottom appbar
                      if (widget.bottomNavigationBar != null &&
                          fullWindowConstraints.maxWidth <
                              widget.bottomNavigationBarBreakpoint)
                        widget.bottomNavigationBar!
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
