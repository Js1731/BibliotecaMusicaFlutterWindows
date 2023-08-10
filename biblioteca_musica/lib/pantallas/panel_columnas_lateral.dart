import 'package:biblioteca_musica/backend/controles/control_panel_columna_lateral.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/CustomPainterAgregarLista.dart';
import 'package:biblioteca_musica/backend/providers/provider_panel_propiedad.dart';
import 'package:biblioteca_musica/pantallas/item_columna.dart';
import 'package:biblioteca_musica/widgets/btn_agregar.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
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
                  await agregarColumna();
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
