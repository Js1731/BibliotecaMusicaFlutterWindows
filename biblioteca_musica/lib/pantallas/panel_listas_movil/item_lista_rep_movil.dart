import 'package:biblioteca_musica/bloc/cubit_panel_seleccionado.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/pantallas/panel_lateral/icono_animado.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/plantilla_hover.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemListaRepMovil extends StatelessWidget {
  final ListaReproduccionData listaRep;
  final bool esListaReproducida;

  const ItemListaRepMovil(
      {required this.listaRep, required this.esListaReproducida, super.key});

  @override
  Widget build(BuildContext context) {
    return PlantillaHover(
      enabled: true,
      constructorContenido: (context, hover) => GestureDetector(
        onTap: () {
          context.read<CubitPanelSeleccionado>().cambiarPanel(Panel.listasRep);
          context
              .read<BlocListaReproduccionSeleccionada>()
              .add(EvSeleccionarLista(listaRep));
        },
        child: Container(
          height: 70,
          color: hover ? Colors.black12 : Colors.transparent,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(children: [
                    Expanded(
                      child: TextoPer(texto: listaRep.nombre, tam: 16),
                    ),
                    if (esListaReproducida)
                      const IconoAnimado(color: DecoColores.rosaClaro1)
                  ]),
                ),
              ),
              const Divider(color: Colors.black26, height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
