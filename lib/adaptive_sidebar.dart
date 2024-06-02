library adaptive_sidebar;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:universal_io/io.dart';

part 'models/sidebar_destination.dart';
part 'widgets/as_destination.dart';
part 'utils.dart';

class AdaptiveSidebar extends StatefulWidget {
  final Widget child;
  final List<SidebarDestination> destinations;
  final SidebarDestination? pinnedDestination;
  final List<SidebarDestination> footerDestinations;
  final void Function(int index) onPageChange;
  final Widget? logo;
  final String? title;
  final double maxLargeSidebarSize;
  final double iconTitleSpacing;
  final bool macOSTopPadding;
  const AdaptiveSidebar({
    super.key,
    required this.child,
    required this.destinations,
    required this.onPageChange,
    this.title,
    this.logo,
    this.pinnedDestination,
    this.footerDestinations = const [],
    this.maxLargeSidebarSize = 192,
    this.iconTitleSpacing = 10,
    this.macOSTopPadding = true,
  });

  @override
  State<AdaptiveSidebar> createState() => _AdaptiveSidebarState();
}

class _AdaptiveSidebarState extends State<AdaptiveSidebar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Sidebar
        Container(
          width: widget.maxLargeSidebarSize,
          decoration: BoxDecoration(
            color: Theme.of(context).bottomAppBarTheme.color,
          ),
          child: Column(
            children: [
              //Top macOS padding
              if (Platform.isMacOS && !kIsWeb && widget.macOSTopPadding)
                const Gap(35),
              if (Platform.isIOS && !kIsWeb || Platform.isAndroid && !kIsWeb)
                const Gap(20),
              //Title / Logo Section
              if (widget.logo != null || widget.title != null)
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 5, top: 12),
                  child: Row(
                    children: [
                      //Logo
                      if (widget.logo != null)
                        Padding(
                          padding: EdgeInsets.only(right: widget.iconTitleSpacing),
                          child: widget.logo!,
                        ),
                      //Title
                      if (widget.title != null)
                        Text(
                          widget.title!,
                          style: Theme.of(context)
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
              if (widget.logo != null || widget.title != null) const Divider(),
              //Pinned Destination
              if (widget.pinnedDestination != null)
                ASDestination(
                  destination: widget.pinnedDestination!,
                  onTap: () {
                    _index = -1;
                    widget.onPageChange(-1);
                    setState(() {});
                  },
                  selected: _index == -1,
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
                          _index = index;
                          widget.onPageChange(index);
                          setState(() {});
                        },
                        selected: _index == index,
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
                        _index = widget.destinations.length + index;
                        widget.onPageChange(widget.destinations.length + index);
                        setState(() {});
                      },
                      selected: _index == (widget.destinations.length + index),
                    );
                  },
                ),
            ],
          ),
        ),
        //Content
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }
}
