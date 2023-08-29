import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DraggableColumna extends StatefulWidget {
  final bool esPrincipal;
  final int index;
  final ScrollController outerController;
  final String nombre;
  final VoidCallback onQuitar;
  final VoidCallback onSelPrincipal;
  DraggableColumna(
      {required this.onQuitar,
      required this.onSelPrincipal,
      required this.index,
      required this.nombre,
      required this.esPrincipal,
      required this.outerController})
      : super(key: ValueKey(index));

  @override
  State<StatefulWidget> createState() => EstadoDraggableColumna();
}

class EstadoDraggableColumna extends State<DraggableColumna> {
  final ScrollController innerController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          final offset = event.scrollDelta.dy;
          widget.outerController
              .jumpTo(widget.outerController.offset - offset / 5);
        }
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: innerController,
        child: ReorderableDragStartListener(
          index: widget.index,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                //SELECCIONAR COMO FAVORITO

                IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    onPressed: widget.onSelPrincipal,
                    splashRadius: 20,
                    color: widget.esPrincipal ? Deco.cRosa0 : Deco.cGray1,
                    icon: Icon(widget.esPrincipal
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded)),

                //NOMBRE
                TextoPer(texto: widget.nombre, tam: 14),

                //ELIMINAR COLUMNA DE LA LISTA
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: widget.onQuitar,
                    iconSize: 20,
                    splashRadius: 20,
                    icon: const Icon(
                        color: Colors.black45, Icons.highlight_remove))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
