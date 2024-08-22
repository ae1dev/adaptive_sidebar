part of adaptive_sidebar;

class ASDestination extends StatefulWidget {
  final SidebarDestination destination;
  final void Function()? onTap;
  final bool selected, iconsOnly;
  const ASDestination({
    super.key,
    required this.destination,
    this.selected = false,
    this.iconsOnly = false,
    this.onTap,
  });

  @override
  State<ASDestination> createState() => _ASDestinationState();
}

class _ASDestinationState extends State<ASDestination> {
  bool hovering = false;

  //Display a hover color for drawer item text
  Color getTextColor(BuildContext context) {
    if (hovering == true && widget.selected != true) {
      return Theme.of(context).textTheme.displayLarge!.color!;
    }
    if (widget.selected == true) {
      return Theme.of(context).primaryColor;
    }
    return Theme.of(context).textTheme.displayLarge!.color!.withOpacity(0.7);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          right: widget.iconsOnly ? 12 : 15, left: 12, top: 5, bottom: 7),
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (PointerEnterEvent details) =>
              setState(() => hovering = true),
          onExit: (PointerExitEvent details) => setState(() {
            hovering = false;
          }),
          cursor: SystemMouseCursors.click,
          child: Tooltip(
            message: widget.iconsOnly ? widget.destination.label : null,
            child: Container(
              padding: EdgeInsets.only(
                  right: widget.iconsOnly ? 5 : 8, left: 5, bottom: 4, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //IconData Icon
                  if (widget.destination.icon != null)
                    Container(
                      margin: EdgeInsets.only(
                          right: widget.iconsOnly ? 0 : 8, bottom: 2),
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
                      margin: EdgeInsets.only(
                          right: widget.iconsOnly ? 0 : 8, bottom: 2),
                      child: widget.destination.iconBuilder!(
                        context,
                        getTextColor(context),
                      ),
                    ),
                  if (!widget.iconsOnly)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: AutoSizeText(
                          widget.destination.label,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: getTextColor(context),
                              ),
                          minFontSize: 16,
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
      ),
    );
  }
}
