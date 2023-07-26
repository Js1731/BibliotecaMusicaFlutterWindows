import 'package:biblioteca_musica/controles/control_panel_central_columnas.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/pantallas/item_valor_columna.dart';
import 'package:biblioteca_musica/providers/provider_panel_propiedad.dart';
import 'package:biblioteca_musica/widgets/cinta_opciones.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PanelColumnasCentral extends StatefulWidget {
  const PanelColumnasCentral({super.key});

  @override
  State<StatefulWidget> createState() => EstadoPanelPropiedadesCentral();
}

class EstadoPanelPropiedadesCentral extends State<PanelColumnasCentral> {
  ControlPanelCentralPropiedades controlador = ControlPanelCentralPropiedades();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selector<ProviderPanelColumnas, Stream<ColumnaData>>(
              selector: (_, provPanelCol) => provPanelCol.streamColumnaSel,
              builder: (_, streamColSel, __) {
                return StreamBuilder(
                    stream: streamColSel,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }
                      ColumnaData columnaSel = snapshot.data!;

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
                                      onPressed: (_) async {
                                        await agregarValorColumna(columnaSel);
                                      })
                                ],
                              ),

                              const Spacer(),

                              SeccionCintaOpciones(lstItems: [
                                //RENOMBRAR COLUMNA
                                BotonCintaOpciones(
                                    icono: Icons.edit,
                                    texto: "Renombrar",
                                    onPressed: (_) async {
                                      await controlador
                                          .renombrarColumna(columnaSel.id);
                                    }),
                                //ELIMINAR COLUMNA
                                BotonCintaOpciones(
                                    icono: Icons.delete,
                                    texto: "Eliminar",
                                    onPressed: (_) async {
                                      bool? confirmar = await mostrarDialogoConfirmar(
                                          context,
                                          "Quieres eliminar la propiedad ${columnaSel.nombre}",
                                          "La propiedad ${columnaSel.nombre} junto todos sus valores y referencias, seran eliminados. Estas Seguro?");

                                      if (confirmar == null) return;

                                      await controlador
                                          .eliminarColumna(columnaSel.id);
                                    }),
                              ])
                            ],
                          ),
                        ],
                      );
                    });
              }),

          const SizedBox(height: 10),

          //LISTA DE VALORES COLUMNA
          Selector<ProviderPanelColumnas, Stream<List<ValorColumnaData>>>(
              selector: (_, provPanelCol) => provPanelCol.streamValoresColumna,
              builder: (_, streamValCol, __) {
                return StreamBuilder(
                    stream: streamValCol,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();

                      List<ValorColumnaData> lstValoresColumna = snapshot.data!;

                      return Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Wrap(
                                runSpacing: 30,
                                spacing: 20,
                                children: [
                                  for (ValorColumnaData valorColumna
                                      in lstValoresColumna)
                                    ItemValorColumna(
                                        valorColumna: valorColumna,
                                        controlador: controlador)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              })
        ],
      ),
    );
  }
}
