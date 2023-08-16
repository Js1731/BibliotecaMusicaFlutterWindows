import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
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
          return Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(
                    top: 2,
                    bottom: 2,
                    right: 10,
                  ),
                  width: double.infinity,
                  height: 25,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),

                      //DECORACION
                      decoration: BoxDecoration(
                        color: seleccionado ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),

                          //NOMBRE DE LA LISTA
                          child: TextoPer(
                            texto: lst.nombre,
                            tam: 16,
                            color: seleccionado
                                ? DecoColores.rosaOscuro
                                : Colors.white,
                          )))),
            ],
          );
        }, onPressed: (context) {
          if (lst.id == listaRepBiblioteca.id) {
            context
                .read<CubitPanelSeleccionado>()
                .cambiarPanel(Panel.listaRepBiblioteca);
          } else {
            context
                .read<CubitPanelSeleccionado>()
                .cambiarPanel(Panel.listasRep);
          }
          context
              .read<BlocListaReproduccionSeleccionada>()
              .add(EvSeleccionarLista(lst));
        });
}
