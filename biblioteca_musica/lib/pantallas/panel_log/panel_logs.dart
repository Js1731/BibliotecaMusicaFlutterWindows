import 'package:biblioteca_musica/bloc/logs/Log.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/logs/estado_log.dart';
import 'package:biblioteca_musica/pantallas/panel_log/btn_sincronizar.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/plantilla_hover.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PanelLog extends StatefulWidget {
  const PanelLog({super.key});

  @override
  State<PanelLog> createState() => _PanelLogState();
}

class _PanelLogState extends State<PanelLog> {
  bool mostrarLogCompleto = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocLog, EstadoLog>(builder: (context, state) {
      final Log? ultimoLog = state.ultimo();
      return LayoutBuilder(builder: (context, constraints) {
        return AnimatedContainer(
          curve: Curves.bounceOut,
          duration: const Duration(milliseconds: 500),
          height: mostrarLogCompleto ? 240 : 40,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: state.backlog.length,
                      itemBuilder: (context, index) {
                        final log = state.backlog[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          height: 20,
                          child: LayoutBuilder(builder: (context, constSup) {
                            return Row(
                              children: [
                                if (log.icono != null) log.icono!,
                                const SizedBox(width: 5),
                                TextoPer(
                                    texto: log.titulo,
                                    tam: 16,
                                    weight: FontWeight.bold),
                                const Icon(Icons.navigate_next_rounded),
                                Expanded(
                                    child: TextoPer(texto: log.desc, tam: 16))
                              ],
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),
              ),
              LimitedBox(
                maxHeight: 40,
                child: Stack(
                  children: [
                    if (constraints.maxWidth > 700)
                      PlantillaHover(
                          enabled: true,
                          constructorContenido: (context, hover) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  mostrarLogCompleto = !mostrarLogCompleto;
                                });
                              },
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      color: hover
                                          ? DecoColores.gris0
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 410),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextoPer(
                                          texto: ultimoLog?.desc ?? "",
                                          color: Colors.black87,
                                          tam: 16,
                                        ),
                                      ))),
                            );
                          }),
                    PlantillaHover(
                        enabled: true,
                        constructorContenido: (context, hover) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                mostrarLogCompleto = !mostrarLogCompleto;
                              });
                            },
                            child: Container(
                              height: 40,
                              width: constraints.maxWidth > 700
                                  ? 400
                                  : double.infinity,
                              decoration: BoxDecoration(
                                  color: DecoColores.rosaClaro,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 180),
                                child: Row(
                                  children: [
                                    if (ultimoLog != null)
                                      if (ultimoLog.icono != null)
                                        ultimoLog.icono!,
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: TextoPer(
                                          texto: ultimoLog?.titulo ?? "",
                                          color: Colors.white,
                                          tam: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    const BtnSincronizar()
                  ],
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
