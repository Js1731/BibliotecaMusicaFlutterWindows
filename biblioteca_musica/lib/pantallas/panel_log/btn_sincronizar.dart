import 'package:biblioteca_musica/bloc/cubit_configuracion.dart';
import 'package:biblioteca_musica/bloc/logs/bloc_log.dart';
import 'package:biblioteca_musica/bloc/sincronizador/cubit_sincronizacion.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/plantilla_hover.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BtnSincronizar extends StatelessWidget {
  final bool conLog;

  const BtnSincronizar({super.key, this.conLog = true});
  String textoEstado(EstadoSinc estado) {
    switch (estado) {
      case EstadoSinc.nuevoLocal:
        return "Sinc Servidor";

      case EstadoSinc.nuevoRemoto:
        return "Sinc Local";

      case EstadoSinc.sincronizado:
        return "Sincronizado";

      case EstadoSinc.sincronizando:
        return "Sincronizando";

      case EstadoSinc.desinc:
        return "Conflictos";

      case EstadoSinc.initSinc:
        return "Sincronizar";
    }
  }

  IconData? iconoEstado(EstadoSinc estado) {
    switch (estado) {
      case EstadoSinc.nuevoLocal:
        return Icons.upload;

      case EstadoSinc.nuevoRemoto:
        return Icons.download;

      case EstadoSinc.sincronizado:
        return null;

      case EstadoSinc.sincronizando:
        return Icons.sync;

      case EstadoSinc.desinc:
        return Icons.sync_problem_rounded;

      case EstadoSinc.initSinc:
        return Icons.sync;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitSincronizacion, EstadoSinc>(
        builder: (context, state) {
      return FutureBuilder(
          future: obtNumeroVersionLocal(),
          builder: (context, snapshot) {
            return PlantillaHover(
                enabled: true,
                constructorContenido: (context, hover) {
                  return GestureDetector(
                    onTap: () {
                      context.read<CubitSincronizacion>().sincronizar(
                          context.read<BlocLog>(), context.read<CubitConf>());
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 170,
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                          color:
                              hover ? DecoColores.rosa : DecoColores.rosaOscuro,
                          borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(20),
                              topLeft: const Radius.circular(20),
                              bottomRight: conLog
                                  ? const Radius.circular(20)
                                  : Radius.zero,
                              topRight: conLog
                                  ? const Radius.circular(20)
                                  : Radius.zero)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            state == EstadoSinc.sincronizado
                                ? Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(top: 2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: DecoColores.rosaClaro1),
                                  )
                                : Icon(iconoEstado(state),
                                    color: DecoColores.gris),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextoPer(
                                    texto: textoEstado(state),
                                    color: Colors.white,
                                    tam: 14,
                                  ),
                                  TextoPer(
                                      texto:
                                          "ver. ${snapshot.connectionState == ConnectionState.done ? snapshot.data : "..."}",
                                      color: Deco.cGray1,
                                      tam: 10)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          });
    });
  }
}
