import 'package:biblioteca_musica/backend/controles/control_panel_columna_lateral.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/providers/provider_panel_propiedad.dart';
import 'package:biblioteca_musica/pantallas/item_columna.dart';
import 'package:biblioteca_musica/widgets/btn_agregar.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PanelColumnasLateral extends StatefulWidget {
  const PanelColumnasLateral({super.key});

  @override
  State<StatefulWidget> createState() => EstadoPanelColumnasLateral();
}

class EstadoPanelColumnasLateral extends State<PanelColumnasLateral> {
  ContPanelColumnaLateral controlador = ContPanelColumnaLateral();
  late Stream<List<ColumnaData>> streamColumnas;

  @override
  void initState() {
    super.initState();

    streamColumnas = controlador.crearStreamPropiedades();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Deco.cMorado),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //TITULO
              Expanded(
                //TITULO
                child: TextoPer(
                  texto: "Columnas",
                  tam: 30,
                  color: Colors.white,
                  weight: FontWeight.bold,
                ),
              ),

              //AGREGAR COLUMNA
              BtnAgregar(onPressed: (_) async {
                await agregarColumna();
              })
            ],
          ),

          const Divider(
            color: Deco.cGray,
            height: 3,
          ),

          //LISTA DE COLUMNAS
          Expanded(
              child: StreamBuilder<List<ColumnaData>>(
            stream: streamColumnas,
            builder: (context, snapshot) => snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final columna = snapshot.data![index];
                      return ItemColumna(
                        columna: columna,
                        onPressed: (_) {
                          Provider.of<ProviderPanelColumnas>(context,
                                  listen: false)
                              .seleccionarColumna(columna);
                        },
                      );
                    },
                  )
                : const SizedBox(),
          ))
        ],
      ),
    );
  }
}
