import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/sincronizador/sincronizacion.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCancion extends BtnGenerico {
  final CancionColumnas cancion;
  final int idLst;
  final bool reproduciendo;
  final bool seleccionado;
  final bool modoSeleccion;

  ItemCancion(
      {required this.cancion,
      required this.idLst,
      required this.seleccionado,
      required this.modoSeleccion,
      required this.reproduciendo,
      super.key})
      : super(builder: (hover, context) {
          List<String?> valoresColumna = cancion.mapaColumnas.values
              .map((mapa) => mapa?["valor_columna_nombre"])
              .toList();

          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: double.infinity,
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: reproduciendo
                ? BoxDecoration(
                    color: DecoColores.rosaClaro1,
                    borderRadius: BorderRadius.circular(30))
                : seleccionado
                    ? BoxDecoration(
                        color: Deco.cGray0,
                        borderRadius: BorderRadius.circular(30))
                    : hover
                        ? BoxDecoration(
                            color: Deco.cGray0,
                            borderRadius: BorderRadius.circular(30))
                        : const BoxDecoration(),
            child: Row(
              children: [
                //NOMBRE DE LA CANCION
                Expanded(
                  child: Row(
                    children: [
                      //CHECKBOX
                      Checkbox(
                          shape: const CircleBorder(),
                          splashRadius: 15,
                          activeColor: reproduciendo
                              ? Colors.white
                              : DecoColores.rosaClaro1,
                          checkColor: reproduciendo
                              ? DecoColores.rosaClaro1
                              : Colors.white,
                          side: BorderSide(
                              color: reproduciendo
                                  ? hover
                                      ? Colors.white
                                      : DecoColores.rosaClaro1
                                  : hover
                                      ? Deco.cGray
                                      : Colors.white),
                          value: seleccionado,
                          onChanged: (nuevoValor) {
                            context
                                .read<BlocListaReproduccionSeleccionada>()
                                .add(EvToggleSelCancion(cancion.id));
                          }),

                      if (cancion.estado == estadoLocal)
                        const Icon(
                          Icons.file_upload_rounded,
                          color: Deco.cGray,
                        ),

                      if (cancion.estado == estadoServidor)
                        const Icon(
                          Icons.file_download_rounded,
                          color: Deco.cGray,
                        ),

                      if (cancion.estado == estadoSubiendo)
                        const Icon(
                          Icons.file_upload_rounded,
                          color: Deco.cRosa0,
                        ),

                      if (cancion.estado == estadoDescargando)
                        const Icon(
                          Icons.file_download_rounded,
                          color: Deco.cRosa0,
                        ),

                      if (cancion.estado != estadoSync)
                        const SizedBox(width: 10),

                      Expanded(
                        child: _TextoItemCancion(
                          texto: cancion.nombre,
                          hover: hover,
                          reproduciendo: reproduciendo,
                          local: cancion.estado == estadoSync ||
                              cancion.estado == estadoLocal ||
                              cancion.estado == estadoLocal,
                          align: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),

                //VALORES COLUMNA DE LA CANCION
                for (String? nombreValorPropiedad in valoresColumna)
                  Expanded(
                      child: _TextoItemCancion(
                          texto: nombreValorPropiedad ?? "--",
                          hover: hover,
                          local: cancion.estado == estadoSync ||
                              cancion.estado == estadoLocal ||
                              cancion.estado == estadoLocal,
                          reproduciendo: reproduciendo)),

                //DURACION DE LA CANCION
                Expanded(
                  child: _TextoItemCancion(
                    texto: duracionString(Duration(seconds: cancion.duracion)),
                    hover: hover,
                    reproduciendo: reproduciendo,
                    align: TextAlign.right,
                    local: cancion.estado == estadoSync ||
                        cancion.estado == estadoLocal ||
                        cancion.estado == estadoLocal,
                  ),
                )
              ],
            ),
          );
        }, onPressed: (context) async {
          if (cancion.estado == estadoSync ||
              cancion.estado == estadoLocal ||
              cancion.estado == estadoLocal) {
            await context.read<AuxiliarListaReproduccion>().reproducirCancion(
                  context,
                  CancionData(
                      id: cancion.id,
                      nombre: cancion.nombre,
                      duracion: cancion.duracion,
                      estado: cancion.estado),
                );
          }
        }, onRightPressed: (context, position) async {
          List<PopupMenuEntry<int>> lstOpciones = [
            const PopupMenuItem(
                value: 1,
                child: Row(children: [
                  Icon(Icons.view_column, color: Deco.cGray1),
                  SizedBox(width: 15),
                  Text("Columnas"),
                ])),
            const PopupMenuDivider(
              height: 10,
            ),
            const PopupMenuItem(
                value: 3,
                child: Row(children: [
                  Icon(Icons.delete_forever, color: Deco.cGray1),
                  SizedBox(width: 15),
                  Text("Eliminar Totalmente")
                ]))
          ];

          if (!modoSeleccion) {
            lstOpciones.insert(
                0,
                const PopupMenuItem(
                    value: 0,
                    child: Row(children: [
                      Icon(Icons.drive_file_rename_outline_rounded,
                          color: Deco.cGray1),
                      SizedBox(width: 15),
                      Text("Renombrar")
                    ])));
          } else {
            lstOpciones.insert(
                0,
                const PopupMenuItem(
                    value: 4,
                    child: Row(children: [
                      Icon(Icons.cut, color: Deco.cGray1),
                      SizedBox(width: 15),
                      Text("Recortar")
                    ])));
          }
          if (context
                  .read<BlocListaReproduccionSeleccionada>()
                  .state
                  .listaReproduccionSeleccionada !=
              listaRepBiblioteca) {
            lstOpciones.insert(
                lstOpciones.length - 1,
                const PopupMenuItem(
                    value: 2,
                    child: Row(children: [
                      Icon(Icons.delete, color: Deco.cGray1),
                      SizedBox(width: 15),
                      Text("Eliminar de esta lista")
                    ])));
          }

          await mostrarMenuContextual<int>(context, position, lstOpciones)
              .then((value) async {
            switch (value) {
              case 0:
                context
                    .read<AuxiliarListaReproduccion>()
                    .renombrarCancion(context, cancion);

                break;

              case 1:
                await context
                    .read<AuxiliarListaReproduccion>()
                    .asignarValoresColumnasDetallado(context, cancion);
                break;

              case 2:
                context
                    .read<AuxiliarListaReproduccion>()
                    .eliminarCancionesLista(
                        context,
                        modoSeleccion
                            ? context
                                .read<BlocListaReproduccionSeleccionada>()
                                .state
                                .obtCancionesSeleccionadas()
                            : [cancion.id]);

                break;

              case 3:
                context
                    .read<AuxiliarListaReproduccion>()
                    .eliminarCancionesTotalmente(
                        context,
                        modoSeleccion
                            ? context
                                .read<BlocListaReproduccionSeleccionada>()
                                .state
                                .obtCancionesSeleccionadas()
                            : [cancion.id]);
                break;

              case 4:
                await context.read<AuxiliarListaReproduccion>().recortarNombres(
                    context,
                    modoSeleccion
                        ? context
                            .read<BlocListaReproduccionSeleccionada>()
                            .state
                            .obtCancionesSeleccionadas()
                        : [cancion.id]);
                break;
            }
          });
        });
}

class _TextoItemCancion extends TextoPer {
  _TextoItemCancion(
      {align = TextAlign.center,
      required texto,
      required reproduciendo,
      required local,
      required hover})
      : super(
            texto: texto,
            tam: 14,
            align: align,
            weight: reproduciendo ? FontWeight.bold : FontWeight.normal,
            color: local
                ? reproduciendo
                    ? Colors.white
                    : Colors.black
                : Deco.cGray);
}
