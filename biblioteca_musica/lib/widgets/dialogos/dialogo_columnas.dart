import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/pantallas/pant_principal.dart';
import 'package:biblioteca_musica/widgets/btn_color.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/dialogos/abrir_dialogo.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_texto.dart';
import 'package:biblioteca_musica/widgets/draggable_columna.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

Future<ColumnaData?> _agregarColumna() async {
  String? nombrePropiedad = await mostrarDialogoTexto(
      keyPantPrincipal.currentContext!, "Agregar nueva Columna");

  if (nombrePropiedad == null) return null;

  var id = await appDb
      .into(appDb.columna)
      .insert(ColumnaCompanion.insert(nombre: nombrePropiedad));

  return ColumnaData(id: id, nombre: nombrePropiedad);
}

///Abre un dialogo para seleccionar que columnas estan asociadas a una Lista y la
///Columna principal de la lista.
///
///Retorna un mapa con las columnas de la lista y la columna principal.
///{"columnas" : List(ColumnaData), "colPrincipal" : ColumnaData}
Future<Map<String, dynamic>?> abrirDialogoColumnas(
    ListaReproduccionData listaRep) async {
  final outerController = ScrollController();

  final consultaColumnasListaRep = appDb.selectOnly(appDb.listaColumnas).join([
    drift.leftOuterJoin(appDb.columna,
        appDb.columna.id.equalsExp(appDb.listaColumnas.idColumna))
  ])
    ..where(appDb.listaColumnas.idListaRep.equals(listaRep.id))
    ..addColumns([
      appDb.listaColumnas.idColumna,
      appDb.columna.nombre,
      appDb.listaColumnas.posicion
    ]);

  final resultado = await consultaColumnasListaRep.get();
  resultado.sort((a, b) => a.rawData.data["lista_columnas.posicion"]
      .compareTo(b.rawData.data["lista_columnas.posicion"]));

  List<ColumnaData> columnaLstRep = resultado
      .map((fila) => ColumnaData(
          id: fila.rawData.data["lista_columnas.idColumna"],
          nombre: fila.rawData.data["columna.nombre"]))
      .toList();

  List<ColumnaData> columnasTodas = await appDb.select(appDb.columna).get();
  List<ColumnaData> columnasResto =
      columnasTodas.toSet().difference(columnaLstRep.toSet()).toList();
  columnasResto.sort((a, b) => a.nombre.compareTo(b.nombre));

  ColumnaData? colPrincipal;

  if (listaRep.idColumnaPrincipal != null) {
    colPrincipal = await (appDb.select(appDb.columna)
          ..where((tbl) => tbl.id.equals(listaRep.idColumnaPrincipal!)))
        .getSingle();
  }

  return mostrarDialogoAlerta(
    //TITULO
    title: TextoPer(
      texto: "Columnas de ${listaRep.nombre}",
      tam: 20,
      weight: FontWeight.bold,
    ),

    content: SizedBox(
      width: 700,
      height: 70,
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          children: [
            const Divider(color: Deco.cGray, height: 3),
            SizedBox(
              height: 30,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //NOMBRE
                  TextoPer(
                    texto: "Nombre",
                    tam: 14,
                  ),

                  //GESTOR DE COLUMNAS
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(55)),
                    child: ReorderableListView(
                      scrollController: outerController,
                      buildDefaultDragHandles: false,
                      key: const Key("si"),
                      scrollDirection: Axis.horizontal,
                      onReorder: (int oldIndex, int newIndex) {
                        if (newIndex > columnaLstRep.length) {
                          newIndex = columnaLstRep.length;
                        }
                        if (oldIndex < newIndex) {
                          newIndex--;
                        }

                        setState(() {
                          final item = columnaLstRep.removeAt(oldIndex);
                          columnaLstRep.insert(newIndex, item);
                        });
                      },
                      children: [
                        for (int i = 0; i < columnaLstRep.length; i++)
                          DraggableColumna(
                            onQuitar: () {
                              setState(() {
                                final propiedad = columnaLstRep[i];
                                columnaLstRep.remove(propiedad);
                                columnasResto.add(propiedad);
                                columnasResto.sort(
                                    (a, b) => a.nombre.compareTo(b.nombre));
                              });
                            },
                            onSelPrincipal: () {
                              setState(() {
                                colPrincipal = columnaLstRep[i];
                              });
                            },
                            index: i,
                            esPrincipal:
                                columnaLstRep[i].id == colPrincipal?.id,
                            nombre: columnaLstRep[i].nombre,
                            outerController: outerController,
                          )
                      ],
                    ),
                  )),

                  //GESTIONAR COLUMNAS
                  PopupMenuButton(
                    tooltip: "",
                    itemBuilder: (context) => [
                      //AGREGAR UNA NUEVA COLUMNA
                      const PopupMenuItem(
                          value: 0, child: Text("Nueva Columna")),

                      //COLUMNAS
                      for (var i = 0; i < columnasResto.length; i++)
                        PopupMenuItem<int>(
                            value: i + 1, child: Text(columnasResto[i].nombre)),
                    ],
                    onSelected: (value) async {
                      //AGREGAR NUEVA COLUMNA
                      if (value == 0) {
                        final nuevaPropiedad = await _agregarColumna();
                        if (nuevaPropiedad != null) {
                          columnaLstRep.add(nuevaPropiedad);
                          await actualizarDatosLocales();
                          setState(() {});
                        }
                      } else {
                        final propiedad = columnasResto[value - 1];
                        columnaLstRep.add(propiedad);
                        columnasResto.remove(propiedad);
                        columnasResto
                            .sort((a, b) => a.nombre.compareTo(b.nombre));
                        setState(() {});
                      }
                    },
                    child: const Icon(
                      Icons.add_circle_rounded,
                      color: Deco.cGray1,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),

                  //DURACION
                  TextoPer(
                    texto: "Duración",
                    tam: 14,
                  )
                ],
              ),
            ),
            const Divider(color: Deco.cGray, height: 3),
          ],
        );
      }),
    ),

    actions: (context) => [
      BtnColor(
          w: 100,
          setcolor: SetColores.morado0,
          texto: "Aplicar",
          onPressed: (_) {
            Navigator.pop(keyPantPrincipal.currentContext!,
                {"columnas": columnaLstRep, "colPrincipal": colPrincipal});
          }),
      BtnColor(
          w: 100,
          setcolor: SetColores.morado1,
          texto: "Cancelar",
          onPressed: (_) {
            Navigator.pop(keyPantPrincipal.currentContext!);
          })
    ],
  );
}
