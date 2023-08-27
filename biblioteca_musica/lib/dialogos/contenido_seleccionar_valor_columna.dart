import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/dimensiones_panel.dart/bloc_dimesiones_panel.dart';
import 'package:biblioteca_musica/bloc/dimensiones_panel.dart/evento_dimensiones_panel.dart';
import 'package:biblioteca_musica/dialogos/contenido_agregar_valor_columna.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_icono.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/dialogo_sel_valor_columna.dart/bloc_dialogo_seleccionar_columnas.dart';
import '../bloc/dialogo_sel_valor_columna.dart/estado_dialogo_seleccionar_valor_columna.dart';
import '../bloc/dialogo_sel_valor_columna.dart/eventos_dialogo_seleccionar_valor_columna.dart';
import '../widgets/btn_flotante_simple.dart';
import '../widgets/form/txt_field.dart';
import '../widgets/texto_per.dart';
import 'item_sugerencia_valor_columna.dart';

class ContenidoSeleccionarValorColumna extends StatefulWidget {
  final ColumnaData columna;
  final VoidCallback onAgregarValorColumna;
  final void Function(ValorColumnaData valorColumna) onSeleccionarValorColumna;

  final Widget? btnVolver;

  const ContenidoSeleccionarValorColumna({
    super.key,
    required this.columna,
    required this.onAgregarValorColumna,
    required this.onSeleccionarValorColumna,
    this.btnVolver,
  });

  @override
  State<StatefulWidget> createState() =>
      _EstadoContenidoSeleccionarValorColumna();
}

class _EstadoContenidoSeleccionarValorColumna
    extends State<ContenidoSeleccionarValorColumna> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocDialogoSeleccionarValorColumna,
        EstadoBlocDialogoSeleccionarValorColumna>(builder: (context, state) {
      return Container(
        color: Colors.black12,
        padding: const EdgeInsets.only(left: 10, bottom: 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: widget.btnVolver,
                        ),
                        Center(
                          child: TextoPer(
                            texto: "Seleccionar ${widget.columna.nombre}",
                            tam: 15,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                    child: TextField(
                      onChanged: (criterio) {
                        context
                            .read<BlocDialogoSeleccionarValorColumna>()
                            .add(EvBuscarSugerencias(criterio));
                      },
                      decoration: CustomTxtFieldDecoration(
                          hint: "Buscar ${widget.columna.nombre}..."),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: BtnFlotanteSimple(
                        ancho: 260,
                        enabled: !state.mostrarPanelAgregarColumna,
                        onPressed: () {
                          context
                              .read<BlocDialogoSeleccionarValorColumna>()
                              .add(EvTogglePanelAgregarColumna(true));
                          context
                              .read<BlocDimensionesPanel>()
                              .add(EvExpandirAncho(300));
                        },
                        texto: "Agregar ${widget.columna.nombre}"),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ListView.builder(
                        itemCount: state.sugerenciasValorColumna.length,
                        itemBuilder: (context, index) {
                          final valorCol = state.sugerenciasValorColumna[index];

                          return ItemSugerenciaValorColumna(
                              valorColumna: valorCol,
                              seleccionado: valorCol.id ==
                                  state.valorColumnaSeleccionado?.id);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: BtnFlotanteSimple(
                        enabled: state.valorColumnaSeleccionado != null &&
                            !state.mostrarPanelAgregarColumna,
                        ancho: 260,
                        onPressed: () {
                          if (state.valorColumnaSeleccionado != null) {
                            widget.onSeleccionarValorColumna(
                                state.valorColumnaSeleccionado!);
                          }
                        },
                        texto: state.valorColumnaSeleccionado != null
                            ? "Seleccionar ${state.valorColumnaSeleccionado!.nombre}"
                            : "Seleccionar ${widget.columna.nombre}"),
                  ),
                ],
              ),
            ),
            if (state.mostrarPanelAgregarColumna)
              Expanded(
                  child: ContenidoAgregarValorColumna(
                columna: widget.columna,
                onAgregarValorColumna: (nuevoValorColuma) {
                  context
                      .read<BlocDialogoSeleccionarValorColumna>()
                      .add(EvSeleccionarValorColumna(nuevoValorColuma));
                  context
                      .read<BlocDimensionesPanel>()
                      .add(EvContraerAncho(300));
                  context
                      .read<BlocDialogoSeleccionarValorColumna>()
                      .add(EvTogglePanelAgregarColumna(false));
                },
                btnVolver: BtnFlotanteIcono(
                    icono: Icons.arrow_back_outlined,
                    onPressed: () {
                      context
                          .read<BlocDimensionesPanel>()
                          .add(EvContraerAncho(300));
                      context
                          .read<BlocDialogoSeleccionarValorColumna>()
                          .add(EvTogglePanelAgregarColumna(false));
                    },
                    tam: 20,
                    tamIcono: 15),
              ))
          ],
        ),
      );
    });
  }
}
