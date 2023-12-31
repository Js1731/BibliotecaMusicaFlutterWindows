import 'package:biblioteca_musica/datos/cancion_columnas.dart';
import 'package:biblioteca_musica/bloc/dialogo_gestor_columnas_cancion.dart/bloc_dialogo_gestor_columnas_cancion.dart';
import 'package:biblioteca_musica/bloc/dialogo_gestor_columnas_cancion.dart/estado_dialogo_gestor_columnas_cancion.dart';
import 'package:biblioteca_musica/bloc/dialogo_gestor_columnas_cancion.dart/evento_dialogo_gestor_columnas_cancion.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/bloc_dialogo_seleccionar_columnas.dart';
import 'package:biblioteca_musica/bloc/dialogo_sel_valor_columna.dart/eventos_dialogo_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/bloc/dimensiones_panel.dart/bloc_dimesiones_panel.dart';
import 'package:biblioteca_musica/bloc/dimensiones_panel.dart/estado_dimensiones_panel.dart';
import 'package:biblioteca_musica/bloc/dimensiones_panel.dart/evento_dimensiones_panel.dart';
import 'package:biblioteca_musica/dialogos/contenido_agregar_columna.dart';
import 'package:biblioteca_musica/dialogos/contenido_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/dialogos/dialogo_generico.dart';
import 'package:biblioteca_musica/painters/custom_painter_dialogo_sel_valor_columna.dart';
import 'package:biblioteca_musica/repositorios/repositorio_canciones.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_simple.dart';
import 'package:biblioteca_musica/dialogos/item_valor_columna_editable_dialogo.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/btn_flotante_icono.dart';

///Abre un dialogo para gestionar las columnas de las canciones
///
///No retorna nada, los cambios realizados en el dialgo se aplican instantaneamente.
Future<void> abrirDialogoGestionarColumnasCancion(
    BuildContext context, List<CancionColumnas> canciones) async {
  return showDialog(
      context: context,
      builder: (context) => Dialog(
            alignment: Alignment.center,
            backgroundColor: Colors.transparent,
            child: BlocProvider(
                create: (context) => BlocDialogoGestorColumnasCancion(
                    context.read<RepositorioColumnas>(),
                    context.read<RepositorioCanciones>())
                  ..add(EvEscucharColumnasCancion(canciones.first.id)),
                child: DialogoGestionarColumnasCancion(canciones: canciones)),
          ));
}

class DialogoGestionarColumnasCancion extends DialogoGenerico {
  final List<CancionColumnas> canciones;

  DialogoGestionarColumnasCancion({required this.canciones, super.key})
      : super(
            ancho: 270,
            altura: 400,
            espacioAltura: 30,
            customPainter: CustomPainterDialogoSelValorColumna());

  @override
  State<StatefulWidget> createState() =>
      _EstadoDialogoGestionarColumnasCancion();
}

class _EstadoDialogoGestionarColumnasCancion
    extends EstadoDialogoGenerico<DialogoGestionarColumnasCancion> {
  @override
  Widget constructorContenido(BuildContext context) {
    return BlocBuilder<BlocDialogoGestorColumnasCancion,
        EstadoDialogoGestorColumnasCancion>(builder: (context, state) {
      return LayoutBuilder(builder: (context, constraint) {
        return Row(
          children: [
            ///CONTENIDO GESTIONAR COLUMNAS
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///TITULO
                  TextoPer(
                    texto: widget.canciones.length == 1
                        ? widget.canciones.first.nombre
                        : "Columnas",
                    tam: 20,
                    weight: FontWeight.bold,
                  ),

                  //DESCRIPCION
                  SizedBox(
                    height: 50,
                    child: TextoPer(
                      texto:
                          "Escoge los valores de las columnas de esta cancion.",
                      filasTexto: 2,
                      tam: 14,
                    ),
                  ),

                  //BOTON AGREGAR COLUMNA
                  BtnFlotanteSimple(
                      enabled: !state.mostrarAgregarColumna &&
                          !state.mostrarSelectorValorColumna,
                      ancho: 260,
                      onPressed: () {
                        context
                            .read<BlocDimensionesPanel>()
                            .add(EvExpandirAncho(300));
                        context
                            .read<BlocDialogoGestorColumnasCancion>()
                            .add(EvToggleMostrarAgregarColumna(true));
                      },
                      texto: "Agregar Columna"),
                  const SizedBox(height: 15),

                  //COLUMNAS
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.mapaColumnas.keys.toList().length,
                        itemBuilder: (context, index) {
                          final columna =
                              state.mapaColumnas.keys.toList()[index];
                          final valorColumna = state.mapaColumnas[columna];
                          return SizedBox(
                            child: ItemValorColumnaEditableDialogo(
                                enabled: !state.mostrarSelectorValorColumna &&
                                    !state.mostrarAgregarColumna,
                                onPressed: () {
                                  context
                                      .read<BlocDialogoGestorColumnasCancion>()
                                      .add(
                                          EvToggleMostrarSelectorColumna(true));
                                  context
                                      .read<BlocDialogoGestorColumnasCancion>()
                                      .add(EvSeleccionarColumna(columna));

                                  context
                                      .read<BlocDimensionesPanel>()
                                      .add(EvExpandirAncho(300));
                                },
                                columna: columna,
                                valorColumna: valorColumna),
                          );
                        }),
                  ),

                  //BOTON CERRAR
                  BtnFlotanteSimple(
                      ancho: 260,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      texto: "Cerrar"),
                  const SizedBox(height: 10)
                ],
              ),
            )),

            //CONTENIDO SELECCIONAR COLUMNAS
            if (state.mostrarSelectorValorColumna)
              BlocSelector<BlocDimensionesPanel, EstadoDimensionesPanel,
                      double>(
                  selector: (state) => state.ancho,
                  builder: (context, ancho) {
                    return Expanded(
                        flex: ancho > 600 ? 2 : 1,
                        child: BlocProvider(
                            create: (context) =>
                                BlocDialogoSeleccionarValorColumna(
                                    context.read<RepositorioColumnas>(),
                                    state.columnaSel!)
                                  ..add(EvBuscarSugerencias("")),
                            child: ContenidoSeleccionarValorColumna(
                                onSeleccionarValorColumna: (valorColumna) {
                                  context
                                      .read<BlocDialogoGestorColumnasCancion>()
                                      .add(EvAsignarValorColumna(
                                          valorColumna.id,
                                          state.columnaSel!.id,
                                          widget.canciones
                                              .map((e) => e.id)
                                              .toList()));
                                  context
                                      .read<BlocDimensionesPanel>()
                                      .add(EvContraerAncho(300));
                                  context
                                      .read<BlocDialogoGestorColumnasCancion>()
                                      .add(EvToggleMostrarSelectorColumna(
                                          false));
                                },
                                btnVolver: BtnFlotanteIcono(
                                    onPressed: () {
                                      context
                                          .read<BlocDimensionesPanel>()
                                          .add(EvContraerAncho(300));
                                      context
                                          .read<
                                              BlocDialogoGestorColumnasCancion>()
                                          .add(EvToggleMostrarSelectorColumna(
                                              false));
                                    },
                                    icono: Icons.arrow_back_rounded,
                                    tam: 20,
                                    tamIcono: 15),
                                onAgregarValorColumna: () {},
                                columna: state.columnaSel!)));
                  }),

            //CONTENIDO AGREGAR COLUMNA
            if (state.mostrarAgregarColumna)
              Expanded(
                  child: ContenidoAgregarColumna(
                      onAgregarColumna: () {
                        context
                            .read<BlocDimensionesPanel>()
                            .add(EvContraerAncho(300));
                        context
                            .read<BlocDialogoGestorColumnasCancion>()
                            .add(EvToggleMostrarAgregarColumna(false));
                      },
                      btnVolver: BtnFlotanteIcono(
                          onPressed: () {
                            context
                                .read<BlocDimensionesPanel>()
                                .add(EvContraerAncho(300));
                            context
                                .read<BlocDialogoGestorColumnasCancion>()
                                .add(EvToggleMostrarAgregarColumna(false));
                          },
                          icono: Icons.arrow_back_rounded,
                          tam: 20,
                          tamIcono: 15)))
          ],
        );
      });
    });
  }
}
