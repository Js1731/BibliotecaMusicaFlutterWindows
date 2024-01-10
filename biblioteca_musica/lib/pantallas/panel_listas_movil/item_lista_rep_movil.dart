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
  final bool estaSeleccionada;

  const ItemListaRepMovil(
      {required this.listaRep,
      required this.esListaReproducida,
      required this.estaSeleccionada,
      super.key});

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
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: hover ? Colors.black12 : Colors.transparent,
              borderRadius: BorderRadius.circular(15)),
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: DecoColores.rosaClaro2,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Icon(Icons.music_note, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextoPer(
                    texto: listaRep.nombre,
                    tam: 20,
                    color: Colors.grey.shade700),
              ),
            ),
            if (esListaReproducida) IconoAnimado(color: DecoColores.rosaClaro1)
          ]),
        ),
      ),
    );
  }
}
