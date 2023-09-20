import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/columnas_sistema/bloc_columnas_sistema.dart';
import 'package:biblioteca_musica/bloc/columnas_sistema/estado_columnas_sistema.dart';
import 'package:biblioteca_musica/bloc/cubit_gestor_columnas.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_icono.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/plantilla_flotante.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'draggable_columna.dart';
import '../../widgets/texto_per.dart';

class GestorColumnas extends StatefulWidget {
  final int? idColumnaPrincipal;

  const GestorColumnas({super.key, this.idColumnaPrincipal});

  @override
  State<StatefulWidget> createState() => _EstadoGestorColumnas();
}

class _EstadoGestorColumnas extends State<GestorColumnas> {
  final ScrollController outerController = ScrollController();
  int? idColumnaPrincipal;
  List<ColumnaData> columnasSeleccionadas = [];

  @override
  void initState() {
    super.initState();

    idColumnaPrincipal = widget.idColumnaPrincipal;

    columnasSeleccionadas = List.from(
        context.read<BlocListaReproduccionSeleccionada>().state.lstColumnas);
  }

  List<ColumnaData> obtColumasSinSeleccionar(
      List<ColumnaData> columnasSistema) {
    final copiaColumnasSistema = List<ColumnaData>.from(columnasSistema);
    for (var columnaSel in columnasSeleccionadas) {
      copiaColumnasSistema.remove(columnaSel);
    }

    copiaColumnasSistema.sort((a, b) => a.nombre.compareTo(b.nombre));

    return copiaColumnasSistema;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlocColumnasSistema, EstadoColumnasSistema,
            List<ColumnaData>>(
        selector: (state) => state.columnas,
        builder: (context, columnasSistema) {
          return SizedBox(
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
                      if (newIndex > columnasSeleccionadas.length) {
                        newIndex = columnasSeleccionadas.length;
                      }
                      if (oldIndex < newIndex) {
                        newIndex--;
                      }

                      setState(() {
                        final item = columnasSeleccionadas.removeAt(oldIndex);
                        columnasSeleccionadas.insert(newIndex, item);
                      });
                    },
                    children: [
                      for (int i = 0; i < columnasSeleccionadas.length; i++)
                        DraggableColumna(
                          onQuitar: () {
                            setState(() {
                              final columna = columnasSeleccionadas[i];
                              columnasSeleccionadas.remove(columna);
                            });
                          },
                          onSelPrincipal: () {
                            setState(() {
                              idColumnaPrincipal = columnasSeleccionadas[i].id;
                            });
                          },
                          index: i,
                          esPrincipal:
                              columnasSeleccionadas[i].id == idColumnaPrincipal,
                          nombre: columnasSeleccionadas[i].nombre,
                          outerController: outerController,
                        )
                    ],
                  ),
                )),

                //ESCOGER COLUMNAS NO SELECCIONADAS
                PopupMenuButton(
                  tooltip: "",
                  itemBuilder: (context) {
                    final columnasSinSeleccionar =
                        obtColumasSinSeleccionar(columnasSistema);
                    final popupitems = [
                      //AGREGAR UNA NUEVA COLUMNA
                      const PopupMenuItem(
                          value: 0, child: Text("Nueva Columna")),
                    ];
                    //COLUMNAS
                    for (var i = 0; i < columnasSinSeleccionar.length; i++) {
                      popupitems.add(PopupMenuItem<int>(
                          value: i + 1,
                          child: Text(columnasSinSeleccionar[i].nombre)));
                    }

                    return popupitems;
                  },
                  onSelected: (indexColumna) async {
                    //AGREGAR NUEVA COLUMNA
                    if (indexColumna == 0) {
                      ColumnaData? nuevaColumna = await context
                          .read<AuxiliarListaReproduccion>()
                          .agregarColumna(context);

                      if (nuevaColumna == null) return;

                      columnasSeleccionadas.add(nuevaColumna);

                      idColumnaPrincipal ??= nuevaColumna.id;
                    } else {
                      final columna = obtColumasSinSeleccionar(
                          columnasSistema)[indexColumna - 1];
                      columnasSeleccionadas.add(columna);

                      idColumnaPrincipal ??= columna.id;
                      setState(() {});
                    }
                  },
                  child: PlantillaFlotante(
                    altura: 20,
                    ancho: 20,
                    constructorContenido: (hover) => Container(
                      decoration:
                          BtnDecoration(hover, true, Colors.grey.shade600),
                      child: const Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                //DURACION
                TextoPer(
                  texto: "Duración",
                  tam: 14,
                ),

                const SizedBox(width: 10),
                BtnFlotanteIcono(
                  color: DecoColores.rosaClaro1,
                  onPressed: () async {
                    await context
                        .read<AuxiliarListaReproduccion>()
                        .actColumnasListaRep(
                            context,
                            columnasSeleccionadas,
                            columnasSeleccionadas.isEmpty
                                ? null
                                : idColumnaPrincipal);

                    if (context.mounted) {
                      context
                          .read<CubitGestorColumnas>()
                          .esconderGestorColumnas();
                    }
                  },
                  icono: Icons.check,
                  tam: 20,
                  tamIcono: 15,
                ),

                const SizedBox(width: 10),
                BtnFlotanteIcono(
                  onPressed: () {
                    context
                        .read<CubitGestorColumnas>()
                        .esconderGestorColumnas();
                  },
                  icono: Icons.close,
                  tam: 20,
                  tamIcono: 15,
                )
              ],
            ),
          );
        });
  }
}
