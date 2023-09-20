import 'package:biblioteca_musica/bloc/cubit_configuracion.dart';
import 'package:biblioteca_musica/bloc/logs/log.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/logs/evento_bloc_log.dart';
import 'package:biblioteca_musica/bloc/sincronizador/cubit_sincronizacion.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_simple.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/custom_textfield_decoration.dart';

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
  bool sincAuto = true;

  Future<void> cargarAjustes(BuildContext context) async {
    if (iniciado) return;

    final config = context.read<CubitConf>().state;

    await context.read<CubitConf>().cargarConfig();

    txtContIpServidor.text = config.ipServidor;
    buscarIPAutomaticamente = config.ipAuto;
    mostrarLog = config.mostrarLog;
    sincAuto = config.sincAuto;
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
                            decoration: const CustomTxtFieldDecoration(),
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
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextoPer(
                              texto: "Sincronizar Automaticamente", tam: 16)),
                      Switch(
                          value: sincAuto,
                          onChanged: (nuevoValor) async {
                            if (nuevoValor == true) {
                              context.read<CubitConf>().activarSincAuto(
                                  context.read<BlocLog>(),
                                  context.read<CubitSincronizacion>());
                            } else {
                              context.read<CubitConf>().detenerSincAuto();
                            }
                            setState(() {
                              sincAuto = nuevoValor;
                            });
                          })
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextoPer(
                              texto: "Forzar Sincronizacion", tam: 16)),
                      BtnFlotanteSimple(
                          onPressed: () {
                            context.read<CubitSincronizacion>().sincronizar(
                                context.read<BlocLog>(),
                                context.read<CubitConf>());
                          },
                          texto: "Sincronizar")
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child:
                              TextoPer(texto: "Borrar datos locales", tam: 16)),
                      BtnFlotanteSimple(
                          onPressed: () async {
                            final confirmar = await abrirDialogoConfirmar(
                                context,
                                "Borrar Datos Locales",
                                "Quires borrar todos los datos locales?");

                            if (confirmar == null) return;

                            await appDb
                                .delete(appDb.cancionListaReproduccion)
                                .go();
                            await appDb.delete(appDb.cancionValorColumna).go();
                            await appDb.delete(appDb.cancion).go();
                            await appDb.delete(appDb.valorColumna).go();
                            await appDb.delete(appDb.listaColumnas).go();
                            await appDb.delete(appDb.listaReproduccion).go();
                            await appDb.delete(appDb.columna).go();

                            await actUltimaListaRep(0);

                            await borrarTodo();
                          },
                          texto: "Borrar Todo")
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
                          mostrarLog_: mostrarLog,
                          sincAuto_: sincAuto));

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
