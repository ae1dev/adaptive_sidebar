part of adaptive_sidebar;

class _Destination extends StatefulWidget {
  final SidebarDestination destination;
  final void Function()? onTap;
  final bool selected, iconsOnly;
  final TextStyle destinationsTextStyle;
  final Color? selectedColor;
  const _Destination({
    super.key,
    required this.destination,
    this.selected = false,
    this.iconsOnly = false,
    this.onTap,
    required this.destinationsTextStyle,
    this.selectedColor,
  });

  @override
  State<_Destination> createState() => __DestinationState();
}

class __DestinationState extends State<_Destination> {
  bool hovering = false;

  //Display a hover color for drawer item text
  Color getTextColor(BuildContext context) {
    // Hovering color
    if (hovering == true && widget.selected != true) {
      return widget.destinationsTextStyle.color!;
    }
    // Selected color
    if (widget.selected == true) {
      return widget.selectedColor ?? Theme.of(context).primaryColor;
    }
    // Unselected color
    return widget.destinationsTextStyle.color!.withOpacity(0.7);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (PointerEnterEvent details) => setState(() => hovering = true),
        onExit: (PointerExitEvent details) => setState(() {
          hovering = false;
        }),
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          width: double.maxFinite,
          child: ClipRect(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //IconData Icon
                if (widget.destination.icon != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    child: Icon(
                      widget.destination.icon,
                      fill: widget.selected ? 1 : 0,
                      color: getTextColor(context),
                    ),
                  ),
                //Widget Icon
                if (widget.destination.icon == null &&
                    widget.destination.iconBuilder != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    child: widget.destination.iconBuilder!(
                      context,
                      getTextColor(context),
                    ),
                  ),
                //Label
                if (!widget.iconsOnly)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        widget.destination.label,
                        style: widget.destinationsTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: getTextColor(context),
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    //Wrap tooltip
    if (widget.iconsOnly) {
      return Container(
        margin: const EdgeInsets.only(
          right: 12,
          left: 12,
          top: 5,
          bottom: 7,
        ),
        child: Tooltip(
          message: widget.destination.label,
          child: child,
        ),
      );
    }

    return ClipRect(
      child: Container(
        margin: const EdgeInsets.only(
          right: 12,
          left: 12,
          top: 5,
          bottom: 7,
        ),
        child: child,
      ),
    );
  }
}
