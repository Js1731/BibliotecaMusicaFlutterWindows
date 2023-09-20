import 'package:biblioteca_musica/bloc/cubit_modo_responsive.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/bloc_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/estado_columna_seleccionada.dart';
import 'package:biblioteca_musica/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auxiliar_panel_columnas.dart';
import 'item_valor_columna.dart';

class PanelColumnasCentral extends StatefulWidget {
  const PanelColumnasCentral({super.key});

  @override
  State<StatefulWidget> createState() => EstadoPanelPropiedadesCentral();
}

class EstadoPanelPropiedadesCentral extends State<PanelColumnasCentral> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitModoResponsive, ModoResponsive>(
        builder: (context, modoResponsive) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 10, bottom: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocSelector<BlocColumnaSeleccionada, EstadoColumnaSeleccionada,
                    ColumnaData>(
                selector: (state) => state.columnaSeleccionada!,
                builder: (_, columnaSel) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //NOMBRE DE LA COLUMNA

                      TextoPer(
                        texto: columnaSel.nombre,
                        weight: FontWeight.bold,
                        tam: 30,
                      ),

                      const SizedBox(height: 10),

                      CintaOpciones(
                        lstOpciones: [
                          //AGREGAR VALOR A LA COLUMNA
                          SeccionCintaOpciones(
                            lstItems: [
                              BotonCintaOpciones(
                                  icono: Icons.add,
                                  texto: "Agregar ${columnaSel.nombre}",
                                  modoResponsive: modoResponsive,
                                  onPressed: (_) async {
                                    await context
                                        .read<AuxiliarPanelColumnas>()
                                        .agregarValorColumna(context);
                                  })
                            ],
                          ),

                          const Spacer(),

                          SeccionCintaOpciones(lstItems: [
                            //RENOMBRAR COLUMNA
                            BotonCintaOpciones(
                                icono: Icons.edit,
                                texto: "Renombrar",
                                modoResponsive: modoResponsive,
                                onPressed: (_) async {
                                  // await controlador
                                  //     .renombrarColumna(columnaSel.id);
                                }),
                            //ELIMINAR COLUMNA
                            BotonCintaOpciones(
                                icono: Icons.delete,
                                texto: "Eliminar",
                                modoResponsive: modoResponsive,
                                onPressed: (_) async {
                                  bool? confirmar = await abrirDialogoConfirmar(
                                      context,
                                      "Quieres eliminar la propiedad ${columnaSel.nombre}",
                                      "La propiedad ${columnaSel.nombre} junto todos sus valores y referencias, seran eliminados. Estas Seguro?");

                                  if (confirmar == null) return;

                                  // await controlador
                                  //     .eliminarColumna(columnaSel.id);
                                }),
                          ])
                        ],
                      ),
                    ],
                  );
                }),

            const SizedBox(height: 10),

            //LISTA DE VALORES COLUMNA
            BlocSelector<BlocColumnaSeleccionada, EstadoColumnaSeleccionada,
                    List<ValorColumnaData>>(
                selector: (state) => state.listaValoresColumna,
                builder: (_, lstValoresColumna) {
                  return Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            children: [
                              for (ValorColumnaData valorColumna
                                  in lstValoresColumna)
                                ItemValorColumna(
                                  valorColumna: valorColumna,
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      );
    });
  }
}
