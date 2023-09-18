import 'package:biblioteca_musica/bloc/cubit_configuracion.dart';
import 'package:biblioteca_musica/bloc/logs/Log.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/logs/evento_bloc_log.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_simple.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/form/txt_field.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PanelAjustes extends StatefulWidget {
  const PanelAjustes({super.key});

  @override
  State<PanelAjustes> createState() => _PanelAjustesState();
}

class _PanelAjustesState extends State<PanelAjustes> {
  bool iniciado = false;

  final TextEditingController txtContIpServidor = TextEditingController();
  bool buscarIPAutomaticamente = true;
  bool mostrarLog = true;

  Future<void> cargarAjustes(BuildContext context) async {
    if (iniciado) return;

    final config = context.read<CubitConf>().state;

    await context.read<CubitConf>().cargarConfig();

    txtContIpServidor.text = config.ipServidor;
    buscarIPAutomaticamente = config.ipAuto;
    mostrarLog = config.mostrarLog;
    iniciado = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cargarAjustes(context),
      builder: (context, snap) => Padding(
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
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: DecoColores.gris,
                        borderRadius: BorderRadius.circular(5)),
                    width: 100,
                    child: Column(children: [
                      TextoPer(
                        texto: "Servidor",
                      ),
                      TextoPer(texto: txtContIpServidor.text)
                    ]),
                  )
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
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
                          maxWidth: 150,
                          child: TextFormField(
                            controller: txtContIpServidor,
                            enabled: !buscarIPAutomaticamente,
                            decoration: CustomTxtFieldDecoration(),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: TextoPer(texto: "Mostrar Log", tam: 16)),
                      Switch(
                          value: mostrarLog,
                          onChanged: (nuevoValor) {
                            setState(() {
                              mostrarLog = nuevoValor;
                            });
                          })
                    ],
                  )
                ],
              ),
            )),
            BtnFlotanteSimple(
                onPressed: () async {
                  final config = context.read<CubitConf>().state;
                  await context.read<CubitConf>().actualizarConfig(
                      config.copiarCon(
                          ipServidor_: txtContIpServidor.text,
                          ipAuto_: buscarIPAutomaticamente,
                          mostrarLog_: mostrarLog));

                  if (context.mounted) {
                    context.read<BlocLog>().add(EvAgregarLog(Log(
                        const Icon(Icons.settings, color: DecoColores.gris),
                        "Configuracion",
                        "Configuracion Actualizada")));
                  }
                },
                texto: "Aplicar")
          ],
        ),
      ),
    );
  }
}
