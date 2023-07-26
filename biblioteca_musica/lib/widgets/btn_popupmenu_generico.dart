import 'package:flutter/material.dart';

class BtnPopupMenuGenerico<T> extends StatefulWidget {
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final Widget Function(bool, BuildContext) botonBuilder;
  final Function(dynamic) onSelected;
  final bool enabled;

  const BtnPopupMenuGenerico(
      {required this.onSelected,
      required this.botonBuilder,
      required this.itemBuilder,
      this.enabled = true,
      super.key});

  @override
  State<StatefulWidget> createState() => EstadoBtnPopupMenuGenerico();
}

class EstadoBtnPopupMenuGenerico extends State<BtnPopupMenuGenerico> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        tooltip: "",
        enabled: widget.enabled,
        onSelected: widget.onSelected,
        itemBuilder: widget.itemBuilder,
        child: MouseRegion(
            onEnter: (evento) {
              setState(() {
                hover = true;
              });
            },
            onExit: (event) {
              setState(() {
                hover = false;
              });
            },
            child: Center(child: widget.botonBuilder(hover, context))));
  }
}
