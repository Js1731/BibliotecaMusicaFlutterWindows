import 'package:flutter/material.dart';

class BtnPopupMenuGenerico<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> Function(BuildContext) itemBuilder;
  final Widget Function(bool, BuildContext) botonBuilder;
  final void Function(T) onSelected;
  final bool enabled;

  const BtnPopupMenuGenerico(
      {required this.onSelected,
      required this.botonBuilder,
      required this.itemBuilder,
      this.enabled = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    bool hover = false;
    return StatefulBuilder(builder: (context, setState) {
      return PopupMenuButton(
          tooltip: "",
          enabled: enabled,
          onSelected: onSelected,
          itemBuilder: itemBuilder,
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
              child: Center(child: botonBuilder(hover, context))));
    });
  }
}
