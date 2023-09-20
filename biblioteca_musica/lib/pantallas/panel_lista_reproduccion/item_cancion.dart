import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/bloc/sincronizador/sincronizacion.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/bloc_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/panel_lista_reproduccion/eventos_lista_reproduccion_seleccionada.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:biblioteca_musica/pantallas/panel_lista_reproduccion/auxiliar_lista_reproduccion.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemCancion extends BtnGenerico {
  final CancionColumnas cancion;
  final int idLst;
  final bool reproduciendo;
  final bool seleccionado;
  final bool modoSeleccion;
  final int? idColumnaPrincipal;
  final ModoResponsive modoResponsive;

  ItemCancion(
      {required this.cancion,
      required this.idLst,
      required this.seleccionado,
      required this.modoSeleccion,
      required this.reproduciendo,
      required this.idColumnaPrincipal,
      required this.modoResponsive,
      super.key})
      : super(builder: (hover, context) {
          return SizedBox(
            height: modoResponsive == ModoResponsive.muyReducido ? 40 : 30,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: double.infinity,
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
                        if (modoResponsive != ModoResponsive.muyReducido)
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

                        if (modoResponsive == ModoResponsive.muyReducido)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Builder(builder: (context) {
                              int? id = int.tryParse(
                                  cancion.mapaColumnas[idColumnaPrincipal]
                                          ?["valor_columna_id"] ??
                                      "a");
                              String? url = id == null ? null : rutaImagen(id);

                              return ImagenRectRounded(
                                  radio: 5, url: url, tam: 40, sombra: false);
                            }),
                          ),

                        Expanded(
                          flex: modoResponsive == ModoResponsive.muyReducido
                              ? 3
                              : 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right:
                                    modoResponsive == ModoResponsive.muyReducido
                                        ? 10.0
                                        : 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _TextoItemCancion(
                                  texto: cancion.nombre,
                                  hover: hover,
                                  reproduciendo: reproduciendo,
                                  local: cancion.estado == estadoSync ||
                                      cancion.estado == estadoLocal ||
                                      cancion.estado == estadoLocal,
                                  align: TextAlign.left,
                                ),
                                if (modoResponsive ==
                                    ModoResponsive.muyReducido)
                                  _SubTextoItemCancion(
                                    texto:
                                        cancion.mapaColumnas[idColumnaPrincipal]
                                                ?["valor_columna_nombre"] ??
                                            "---",
                                    hover: hover,
                                    reproduciendo: reproduciendo,
                                    local: cancion.estado == estadoSync ||
                                        cancion.estado == estadoLocal ||
                                        cancion.estado == estadoLocal,
                                    align: TextAlign.left,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //VALORES COLUMNA DE LA CANCION
                  for (Map<String, dynamic>? valorColumna
                      in cancion.mapaColumnas.values)
                    if ((modoResponsive == ModoResponsive.reducido &&
                            idColumnaPrincipal ==
                                int.tryParse(
                                    valorColumna?["valor_columna_id"] ??
                                        "a")) ||
                        modoResponsive == ModoResponsive.normal)
                      Expanded(
                          child: _TextoItemCancion(
                              texto:
                                  valorColumna?["valor_columna_nombre"] ?? "--",
                              hover: hover,
                              local: cancion.estado == estadoSync ||
                                  cancion.estado == estadoLocal ||
                                  cancion.estado == estadoLocal,
                              reproduciendo: reproduciendo)),

                  //DURACION DE LA CANCION
                  Expanded(
                    flex: modoResponsive == ModoResponsive.muyReducido ? 0 : 1,
                    child: _TextoItemCancion(
                      texto:
                          duracionString(Duration(seconds: cancion.duracion)),
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

          if (modoResponsive != ModoResponsive.muyReducido) {
            lstOpciones.insert(
              1,
              const PopupMenuItem(
                  value: 1,
                  child: Row(children: [
                    Icon(Icons.view_column, color: Deco.cGray1),
                    SizedBox(width: 15),
                    Text("Columnas"),
                  ])),
            );
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

class _SubTextoItemCancion extends TextoPer {
  _SubTextoItemCancion(
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
                    ? Colors.white38
                    : Colors.black45
                : Deco.cGray);
}
