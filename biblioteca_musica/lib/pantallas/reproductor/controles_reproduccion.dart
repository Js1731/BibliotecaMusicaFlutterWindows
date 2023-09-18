import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/reproductor/bloc_reproductor.dart';
import '../../bloc/reproductor/estado_reproductor.dart';
import '../../bloc/reproductor/evento_reproductor.dart';
import '../../datos/cancion_columna_principal.dart';
import '../../widgets/decoracion_.dart';
import 'btn_accion_reproductor.dart';

class ControlesReproduccion extends StatelessWidget {
  const ControlesReproduccion({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlocReproductor, EstadoReproductor,
            CancionColumnaPrincipal?>(
        selector: (state) => state.cancionReproducida,
        builder: (context, cancionRep) {
          return Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Deco.cGray1),
                color: DecoColores.rosaOscuro,
                borderRadius: BorderRadius.circular(30)),
            child: BlocSelector<BlocReproductor, EstadoReproductor, bool>(
                selector: (state) => state.reproduciendo,
                builder: (_, reproduciendo) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BtnAccionReproductor(
                          pausado: reproduciendo,
                          enabled: cancionRep != null,
                          icono: Icons.skip_previous,
                          onPressed: (_) async {
                            context
                                .read<BlocReproductor>()
                                .add(EvRegresarCancion());
                          }),
                      const SizedBox(width: 5),
                      BtnAccionReproductor(
                          pausado: reproduciendo,
                          enabled: cancionRep != null,
                          icono: Icons.fast_rewind,
                          onPressed: (_) async {
                            context
                                .read<BlocReproductor>()
                                .add(EvRegresar10s());
                          }),
                      const SizedBox(width: 5),
                      BtnAccionReproductor(
                          pausado: reproduciendo,
                          enabled: cancionRep != null,
                          icono: reproduciendo ? Icons.pause : Icons.play_arrow,
                          onPressed: (_) async {
                            context
                                .read<BlocReproductor>()
                                .add(EvTogglePausa());
                          }),
                      const SizedBox(width: 5),
                      BtnAccionReproductor(
                          pausado: reproduciendo,
                          enabled: cancionRep != null,
                          icono: Icons.fast_forward,
                          onPressed: (_) async {
                            context.read<BlocReproductor>().add(EvAvanzar10s());
                          }),
                      const SizedBox(width: 5),
                      BtnAccionReproductor(
                          pausado: reproduciendo,
                          enabled: cancionRep != null,
                          icono: Icons.skip_next,
                          onPressed: (_) async {
                            context
                                .read<BlocReproductor>()
                                .add(EvAvanzarCancion());
                          }),
                    ],
                  );
                }),
          );
        });
  }
}
