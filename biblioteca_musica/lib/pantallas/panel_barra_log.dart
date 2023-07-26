import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/misc/sincronizacion.dart';
import 'package:biblioteca_musica/providers/provider_log.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PanelBarraLog extends StatefulWidget {
  const PanelBarraLog({super.key});

  @override
  State<StatefulWidget> createState() => EstadoPanelBarraLog();
}

class EstadoPanelBarraLog extends State<PanelBarraLog> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderLog>(
      create: (_) => provBarraLog,
      child: Consumer<ProviderLog>(builder: (context, provLog, child) {
        return SizedBox(
          child: Column(
            children: [
              const Divider(
                color: Deco.cMorado0,
                height: 1,
              ),
              if (provLog.logExtendido)
                Container(
                  height: 130,
                  padding: const EdgeInsets.all(5),
                  color: Deco.cMorado0,
                  child: ListView.builder(
                    itemCount: provLog.lstLog.length - 1,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final log = provLog.obtLog(index);
                      return TextoPer(
                        texto: "${log!.titulo}: ${log.desc}",
                        tam: 12,
                        color: Deco.cGray,
                      );
                    },
                  ),
                ),
              SizedBox(
                height: 25,
                child: Row(
                  children: [
                    BtnGenerico(
                      builder: (hover, context) => Container(
                          padding: const EdgeInsets.only(left: 10),
                          color: hover ? Deco.cMorado : Deco.cMorado0,
                          width: 200,
                          height: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      color: provLog.sincronizado
                                          ? Deco.cRosa0
                                          : Deco.cGray0,
                                      borderRadius: BorderRadius.circular(10))),
                              const SizedBox(
                                width: 5,
                              ),
                              TextoPer(
                                texto: provLog.sincronizado
                                    ? "Sincronizado"
                                    : "Desincronizado",
                                tam: 12,
                                color: Deco.cGray0,
                              ),
                            ],
                          )),
                      onPressed: (_) async {
                        await sincronizar();
                      },
                    ),
                    BtnGenerico(
                      builder: (hover, context) => Container(
                          padding: const EdgeInsets.only(left: 10),
                          color: hover ? Deco.cMorado4 : Deco.cMorado,
                          width: 200,
                          alignment: Alignment.centerLeft,
                          height: double.infinity,
                          child: TextoPer(
                              texto: provLog.obtLogAct()?.titulo ?? "",
                              tam: 12,
                              color: Colors.white)),
                      onPressed: (_) {
                        provLog.togglerLogExtendido(!provLog.logExtendido);
                      },
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          color: Deco.cGray0,
                          height: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: TextoPer(
                              texto: provLog.obtLogAct()?.desc ?? "", tam: 12)),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black54,
                height: 0.5,
              )
            ],
          ),
        );
      }),
    );
  }
}
