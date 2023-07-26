import 'package:flutter/cupertino.dart';

class BtnGenerico extends StatefulWidget {
  final bool enabled;
  final Widget Function(bool hover, BuildContext context) builder;
  final void Function(BuildContext context)? onPressed;
  final void Function(BuildContext context, Offset clickPos)? onRightPressed;

  const BtnGenerico(
      {this.enabled = true,
      required this.builder,
      this.onPressed,
      this.onRightPressed,
      super.key});

  @override
  State<StatefulWidget> createState() => EstadoBtnGenerico();
}

class EstadoBtnGenerico extends State<BtnGenerico> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: widget.enabled
          ? (evento) {
              setState(() {
                hover = true;
              });
            }
          : null,
      onExit: widget.enabled
          ? (event) {
              setState(() {
                hover = false;
              });
            }
          : null,
      child: GestureDetector(
          onSecondaryTapDown: widget.enabled
              ? (details) {
                  if (widget.onRightPressed != null) {
                    widget.onRightPressed!(context, details.globalPosition);
                  }
                }
              : null,
          onTap: widget.enabled
              ? () {
                  if (widget.onPressed != null) widget.onPressed!(context);
                }
              : null,
          child: widget.builder(hover, context)),
    );
  }
}
