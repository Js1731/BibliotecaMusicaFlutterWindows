import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/datos/lista_reproduccion.dart';
import 'package:biblioteca_musica/bloc/cubit_gestor_columnas.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/estado_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_icono.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import '../../bloc/reproductor/evento_reproductor.dart';
import '../../widgets/decoracion_.dart';
import 'auxiliar_lista_reproduccion.dart';
import 'gestor_columnas.dart';
import 'item_columna_lista_reproduccion.dart';

class EncabezadoColumnas extends StatefulWidget {
  const EncabezadoColumnas({super.key});

  @override
  State<EncabezadoColumnas> createState() => _EncabezadoColumnasState();
}

class _EncabezadoColumnasState extends State<EncabezadoColumnas> {
  @override
  Widget build(BuildContext context) {
    return BlocSelector<
            BlocListaReproduccionSeleccionada,
            EstadoListaReproduccionSelecconada,
            Tuple2<ListaReproduccionData, List<ColumnaData>>>(
        selector: (state) =>
            Tuple2(state.listaReproduccionSeleccionada, state.lstColumnas),
        builder: (context, estado) {
          final listaSel = estado.item1;
          final lstColumnas = estado.item2;
          final idColumnaPrincipal = listaSel.idColumnaPrincipal;
          final idColumnaOrden = listaSel.idColumnaOrden;
          final esAscendente = listaSel.ordenAscendente;

          return BlocBuilder<CubitGestorColumnas, bool>(
              builder: (context, modoActColumnas) {
            return SizedBox(
              height: 25,
              child: !modoActColumnas
                  ? Row(
                      children: [
                        //NOMBRE
                        Expanded(
                            child: ItemColumnaListaReproduccion(
                          idColumna: -1,
                          nombre: "Nombre",
                          align: TextAlign.left,
                          esColumnaOrden: idColumnaOrden == -1,
                          esAscendente: esAscendente,
                        )),

                        //COLUMNAS
                        for (ColumnaData col in lstColumnas)
                          Expanded(
                              child: ItemColumnaListaReproduccion(
                            nombre: col.nombre,
                            idColumna: col.id,
                            esPrincipal: col.id == idColumnaPrincipal,
                            esColumnaOrden: col.id == idColumnaOrden,
                            esAscendente: esAscendente,
                          )),

                        //DURACION
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ItemColumnaListaReproduccion(
                                idColumna: -2,
                                nombre: "Duración",
                                align: TextAlign.right,
                                esColumnaOrden: idColumnaOrden == -2,
                                esAscendente: esAscendente,
                              ),
                            ),
                            if (listaSel.id != listaRepBiblioteca.id)
                              BtnFlotanteIcono(
                                icono: Icons.mode_edit,
                                onPressed: () {
                                  context
                                      .read<CubitGestorColumnas>()
                                      .mostrarGestorColumnas();
                                },
                                tam: 20,
                                tamIcono: 15,
                                color: Colors.grey,
                              )
                          ],
                        )),
                      ],
                    )
                  : GestorColumnas(),
            );
          });
        });
  }
}
