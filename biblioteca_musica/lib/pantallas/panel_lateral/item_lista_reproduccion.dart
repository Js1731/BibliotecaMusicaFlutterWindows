import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemListaReproduccion extends BtnGenerico {
  final ListaReproduccionData lst;
  final bool seleccionado;
  final bool reproduciendo;

  ItemListaReproduccion(
      {required this.lst,
      required this.seleccionado,
      required this.reproduciendo,
      super.key})
      : super(builder: (hover, context) {
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Center(
                key: ValueKey(seleccionado),
                child: seleccionado
                    ? _ItemSeleccionado(hover: hover, nombre: lst.nombre)
                    : _ItemNormal(hover: hover, nombre: lst.nombre),
              ));
        }, onPressed: (context) {
          context.read<CubitPanelSeleccionado>().cambiarPanel(Panel.listasRep);

          context
              .read<BlocListaReproduccionSeleccionada>()
              .add(EvSeleccionarLista(lst));
        });
}

class _ItemNormal extends StatelessWidget {
  final bool hover;
  final String nombre;

  const _ItemNormal({required this.hover, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          top: 2,
          bottom: 2,
          right: 10,
        ),
        width: double.infinity,
        height: 25,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

            //DECORACION
            decoration: BoxDecoration(
              color: hover ? Colors.white10 : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                //NOMBRE DE LA LISTA
                child: TextoPer(
                  texto: nombre,
                  tam: 16,
                  color: Colors.white,
                ))));
  }
}

class _ItemSeleccionado extends StatelessWidget {
  final bool hover;
  final String nombre;

  const _ItemSeleccionado({required this.hover, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          top: 2,
          bottom: 2,
        ),
        width: double.infinity,
        height: 25,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

            //DECORACION
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.zero,
                  topRight: Radius.zero),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),

                //NOMBRE DE LA LISTA
                child: TextoPer(
                  texto: nombre,
                  tam: 16,
                  color: DecoColores.rosa,
                ))));
  }
}
