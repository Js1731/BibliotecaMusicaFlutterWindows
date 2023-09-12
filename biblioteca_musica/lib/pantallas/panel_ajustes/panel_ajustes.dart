import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

class PanelAjustes extends StatefulWidget {
  const PanelAjustes({super.key});

  @override
  State<PanelAjustes> createState() => _PanelAjustesState();
}

class _PanelAjustesState extends State<PanelAjustes> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                TextoPer(
                    texto: "Ajustes",
                    tam: 30,
                    weight: FontWeight.bold,
                    align: TextAlign.start),
                const Spacer(),
                FutureBuilder(
                    future: obtIpServidor(),
                    builder: (context, snapshot) {
                      final ipServ =
                          snapshot.connectionState == ConnectionState.done
                              ? snapshot.data
                              : null;
                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: DecoColores.gris,
                            borderRadius: BorderRadius.circular(5)),
                        width: 100,
                        child: Column(children: [
                          TextoPer(
                            texto: "Servidor",
                          ),
                          TextoPer(
                              texto: snapshot.connectionState ==
                                      ConnectionState.done
                                  ? (ipServ ?? "Ninguno")
                                  : "...")
                        ]),
                      );
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
