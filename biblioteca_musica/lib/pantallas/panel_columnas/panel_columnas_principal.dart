import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/bloc_columna_seleccionada.dart';
import 'package:biblioteca_musica/bloc/columna_seleccionada/estado_columna_seleccionada.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas/panel_columnas_central.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas/panel_columnas_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PanelColumnasPrincipal extends StatefulWidget {
  const PanelColumnasPrincipal({super.key});

  @override
  State<StatefulWidget> createState() => EstadoPanelColumnasPrincipal();
}

class EstadoPanelColumnasPrincipal extends State<PanelColumnasPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const PanelColumnasLateral(),
      BlocSelector<BlocColumnaSeleccionada, EstadoColumnaSeleccionada,
              ColumnaData?>(
          selector: (state) => state.columnaSeleccionada,
          builder: (_, columnaSel) => Expanded(
              child: columnaSel != null
                  ? const PanelColumnasCentral()
                  : const SizedBox()))
    ]);
  }
}
