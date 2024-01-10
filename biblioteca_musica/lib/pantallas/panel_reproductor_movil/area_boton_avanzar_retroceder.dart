import 'package:biblioteca_musica/bloc/reproductor/bloc_reproductor.dart';
import 'package:biblioteca_musica/bloc/reproductor/evento_reproductor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AreaBtnAvanzarRetroceder extends StatelessWidget {
  const AreaBtnAvanzarRetroceder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(child: GestureDetector(
            onDoubleTap: () {
              context.read<BlocReproductor>().add(EvRegresar10s());
            },
          )),
          Expanded(child: GestureDetector(
            onDoubleTap: () {
              context.read<BlocReproductor>().add(EvAvanzar10s());
            },
          ))
        ],
      ),
    );
  }
}
