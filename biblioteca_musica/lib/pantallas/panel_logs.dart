import 'package:biblioteca_musica/bloc/logs/Log.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/logs/estado_log.dart';
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
      return AnimatedContainer(
        curve: Curves.bounceOut,
        duration: const Duration(milliseconds: 500),
        height: mostrarLogCompleto ? 230 : 30,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: state.backlog.length,
                    itemBuilder: (context, index) {
                      final log = state.backlog[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        height: 20,
                        child: Row(
                          children: [
                            if (log.icono != null) log.icono!,
                            const SizedBox(width: 5),
                            TextoPer(
                                texto: log.titulo,
                                tam: 16,
                                weight: FontWeight.bold),
                            const Icon(Icons.navigate_next_rounded),
                            TextoPer(texto: log.desc, tam: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            LimitedBox(
              maxHeight: 30,
              child: Stack(
                children: [
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
                              duration: const Duration(microseconds: 100),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color:
                                      hover ? DecoColores.gris : Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
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
                  Container(
                    height: 30,
                    width: 400,
                    decoration: BoxDecoration(
                        color: DecoColores.rosaClaro,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 180),
                      child: Row(
                        children: [
                          if (ultimoLog != null)
                            if (ultimoLog.icono != null) ultimoLog.icono!,
                          const SizedBox(width: 10),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
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
                  Container(
                    width: 170,
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                        color: DecoColores.rosaOscuro,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: DecoColores.rosaClaro1),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextoPer(
                              texto: "Sincronizado",
                              color: Colors.white,
                              tam: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
