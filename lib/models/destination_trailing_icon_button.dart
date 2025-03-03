part of '../adaptive_sidebar.dart';

class DestinationTrailingIconButton {
  /// Icon that will be displayed on the button.
  final Widget icon;

  /// Callback that will be called when the button is pressed.
  final VoidCallback onPressed;

  /// Text that describes the action that will occur when the button is pressed.
  String? tooltip;

  DestinationTrailingIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });
}
