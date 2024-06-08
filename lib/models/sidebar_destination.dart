part of adaptive_sidebar;

class SidebarDestination {
  ///Name of destination
  String label;
  ///Destination icon
  IconData icon;
  ///If the destination is a popup not a page to navigate to
  bool popup;

  SidebarDestination({
    required this.label,
    required this.icon,
    this.popup = false,
  });
}