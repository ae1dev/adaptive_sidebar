part of '../adaptive_sidebar.dart';

class SidebarDestination {
  ///Name of destination
  String label;

  ///Destination icon
  IconData? icon;

  ///Destination iconBuilder (if used, it will override icon)
  Widget Function(BuildContext, Color)? iconBuilder;

  ///If the destination is a popup not a page to navigate to
  bool popup;

  ///Trailing icon button
  DestinationTrailingIconButton? trailingIconButton;

  SidebarDestination({
    required this.label,
    this.icon,
    this.iconBuilder,
    this.popup = false,
    this.trailingIconButton,
  });
}
