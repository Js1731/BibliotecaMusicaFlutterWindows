import 'package:biblioteca_musica/bloc/cubit_reproductor_movil.dart';
import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/pantallas/reproductor/controles_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/reproductor/modo_reproduccion.dart';
import 'package:biblioteca_musica/pantallas/reproductor/slider_progreso_reproduccion.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

class PanelExpandido extends StatelessWidget {
  const PanelExpandido({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BlocReproductor, EstadoReproductor,
            Tuple2<CancionColumnaPrincipal?, ListaReproduccionData?>>(
        selector: (state) => Tuple2(
            state.cancionReproducida, state.listaReproduccionReproducida),
        builder: (context, data) {
          final cancion = data.item1;
          final listaSel = data.item2;

          return LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextoPer(
                      texto: listaSel?.nombre ?? "---",
                      color: Colors.white,
                      tam: 18),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: LimitedBox(
                          maxWidth: 270,
                          maxHeight: 270,
                          child: ImagenRectRounded(
                            url: rutaImagen(cancion?.valorColumnaPrincipal?.id),
                            tam: constraints.maxWidth - 70,
                          ),
                        ),
                      ),
                      TextoPer(
                        texto: cancion?.nombre ?? "---",
                        color: Colors.white,
                        tam: 18,
                      ),
                      TextoPer(
                        texto: cancion?.valorColumnaPrincipal?.nombre ?? "---",
                        color: Colors.white54,
                        tam: 18,
                      ),
                      const SizedBox(height: 10),
                      const SliderProgresoReproductor(),
                      const ControlesReproduccion(
                          modoResp: ModoResponsive.muyReducido),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: ModoReproduccion(),
                      ),
                    ],
                  ),
                ),
                _BtnContraerPanelRep(onPressed: (context) {
                  context.read<CubitReproductorMovil>().cambiarModo(false);
                })
              ],
            );
          });
        });
  }
}

class _BtnContraerPanelRep extends BtnGenerico {
  _BtnContraerPanelRep({required super.onPressed})
      : super(builder: (hover, context) {
          return Container(
            width: double.maxFinite,
            height: 50,
            decoration: BoxDecoration(
                color: DecoColores.rosa,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.zero,
                  child: Icon(Icons.arrow_drop_down_rounded,
                      size: 60, color: DecoColores.rosaOscuro),
                ),
                Icon(Icons.arrow_drop_down_rounded,
                    size: 60, color: DecoColores.rosaOscuro),
                Icon(Icons.arrow_drop_down_rounded,
                    size: 60, color: DecoColores.rosaOscuro),
              ],
            ),
          );
        });
}
