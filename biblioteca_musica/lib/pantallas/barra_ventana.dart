import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

import '../widgets/decoracion_.dart';

class BarraVentana extends StatelessWidget {
  const BarraVentana({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WindowTitleBarBox(child: MoveWindow()),
        Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.topRight,
          child: WindowTitleBarBox(
              child: Row(
            children: [
              const Spacer(),
              MinimizeWindowButton(),
              MaximizeWindowButton(),
              CloseWindowButton(
                colors: WindowButtonColors(mouseOver: DecoColores.rosaClaro1),
              ),
            ],
          )),
        )
      ],
    );
  }
}
