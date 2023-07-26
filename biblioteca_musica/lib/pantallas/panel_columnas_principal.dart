import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/providers/provider_panel_propiedad.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas_central.dart';
import 'package:biblioteca_musica/pantallas/panel_columnas_lateral.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      Selector<ProviderPanelColumnas, ColumnaData?>(
          selector: (_, provPanelProp) => provPanelProp.tipoPropiedadSel,
          builder: (_, columnaSel, __) => Expanded(
              child: columnaSel != null
                  ? const PanelColumnasCentral()
                  : const SizedBox()))
    ]);
  }
}
