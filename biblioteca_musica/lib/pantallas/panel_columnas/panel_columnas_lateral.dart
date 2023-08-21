import 'package:biblioteca_musica/backend/controles/control_panel_columna_lateral.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/bloc_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/estado_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/eventos_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columnas_sistema/bloc_columnas_sistema.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas/auxiliar_columnas_lateral.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../bloc/columnas_sistema/estado_columnas_sistema.dart';
import '../../painters/custom_painter_agregar_lista.dart';
import 'item_columna.dart';

class PanelColumnasLateral extends StatefulWidget {
  const PanelColumnasLateral({super.key});

  @override
  State<StatefulWidget> createState() => EstadoPanelColumnasLateral();
}

class EstadoPanelColumnasLateral extends State<PanelColumnasLateral> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
          color: DecoColores.rosa,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25),
            height: 25,
            color: DecoColores.rosaClaro1,
            child: Stack(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 8.0),
                child:
                    TextoPer(texto: "Columnas", tam: 16, color: Colors.white),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: BtnGenerico(onPressed: (_) async {
                  await context
                      .read<AuxiliarColumnasLateral>()
                      .agregarColumna(context);
                }, builder: (hover, context) {
                  return CustomPaint(
                    painter: CustomPainterAgregarLista(hover),
                    child: Container(
                      width: 80,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      height: double.maxFinite,
                      child: TextoPer(
                          texto: "Nuevo +", tam: 16, color: Colors.white),
                    ),
                  );
                }),
              )
            ]),
          ),

          //LISTA DE COLUMNAS
          Expanded(
              child: BlocSelector<BlocColumnaSeleccionada,
                      EstadoColumnaSeleccionada, ColumnaData?>(
                  selector: (state) => state.columnaSeleccionada,
                  builder: (context, columnaSeleccionada) {
                    return BlocSelector<BlocColumnasSistema,
                            EstadoColumnasSistema, List<ColumnaData>>(
                        selector: (state) => state.columnas,
                        builder: (context, columnas) {
                          return ListView.builder(
                            itemCount: columnas.length,
                            itemBuilder: (context, index) {
                              final columna = columnas[index];
                              return ItemColumna(
                                seleccionada:
                                    columnaSeleccionada?.id == columna.id,
                                columna: columna,
                                onPressed: (_) {
                                  context
                                      .read<BlocColumnaSeleccionada>()
                                      .add(EvSeleccionarColumna(columna));
                                },
                              );
                            },
                          );
                        });
                  }))
        ],
      ),
    );
  }
}
