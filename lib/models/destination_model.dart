part of adaptive_sidebar;

class ASDestinationModel {
  String label;
  Widget Function(BuildContext, Color) iconBuilder;
  void Function()? onTap;

  ASDestinationModel({
    required this.label,
    required this.iconBuilder,
    this.onTap,
  });
}