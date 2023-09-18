import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/estado_reproductor.dart';
import 'package:biblioteca_musica/datos/cancion_columna_principal.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InformacionCancionReproducida extends StatelessWidget {
  final ModoResponsive modo;

  const InformacionCancionReproducida({required this.modo, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: modo == ModoResponsive.normal ? 350 : 60,
      height: 60,
      padding: EdgeInsets.only(right: modo == ModoResponsive.normal ? 10 : 0),
      decoration: BoxDecoration(
          color: DecoColores.rosaOscuro,
          borderRadius: BorderRadius.circular(10)),
      child: BlocSelector<BlocReproductor, EstadoReproductor,
              CancionColumnaPrincipal?>(
          selector: (state) => state.cancionReproducida,
          builder: (context, cancionRep) {
            return Row(
              children: [
                ImagenRectRounded(
                    sombra: false,
                    radio: 10,
                    tam: 60,
                    url: cancionRep?.valorColumnaPrincipal != null
                        ? rutaImagen(cancionRep!.valorColumnaPrincipal!.id)
                        : null),
                if (modo == ModoResponsive.normal) const SizedBox(width: 10),
                if (modo == ModoResponsive.normal)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 250,
                        child: TextoPer(
                          texto: cancionRep?.nombre ?? "--",
                          tam: 20,
                          color: Colors.white,
                          weight: FontWeight.normal,
                        ),
                      ),
                      TextoPer(
                        texto: cancionRep != null
                            ? cancionRep.valorColumnaPrincipal?.nombre ?? "---"
                            : "---",
                        tam: 14,
                        color: Deco.cGray1,
                      )
                    ],
                  )
              ],
            );
          }),
    );
  }
}
