import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/form/txt_field.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

class PanelAjustes extends StatefulWidget {
  const PanelAjustes({super.key});

  @override
  State<PanelAjustes> createState() => _PanelAjustesState();
}

class _PanelAjustesState extends State<PanelAjustes> {
  bool buscarIPAutomaticamente = false;
  String? ipServidor;

  Future<void> cargarAjustes() async {
    ipServidor = await obtIpServidor() ?? "100";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: cargarAjustes(),
        builder: (context, snap) {
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
                ),
                Row(children: [
                  Expanded(
                      child: TextoPer(
                          texto: "Buscar servidor automaticamente", tam: 16)),
                  Switch(
                      value: buscarIPAutomaticamente,
                      onChanged: (valor) {
                        setState(() {
                          buscarIPAutomaticamente = !buscarIPAutomaticamente;
                        });
                      })
                ]),
                Row(
                  children: [
                    Expanded(
                        child: TextoPer(texto: "IP del servidor", tam: 16)),
                    LimitedBox(
                        maxWidth: 100,
                        child: TextFormField(
                          initialValue: ipServidor ?? "--",
                          enabled: !buscarIPAutomaticamente,
                          decoration: CustomTxtFieldDecoration(),
                        ))
                  ],
                )
              ],
            ),
          );
        });
  }
}
