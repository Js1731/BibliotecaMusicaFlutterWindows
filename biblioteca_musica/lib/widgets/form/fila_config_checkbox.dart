import 'package:biblioteca_musica/widgets/form/fila_config.dart';
import 'package:flutter/material.dart';

class FilaConfigCheckBox extends FilaConfig{
  FilaConfigCheckBox({
    required String txt,
    required mapaDatos,
    required keyDato,
    super.key}) : 
  super(texto: txt, 
        mapaDatos: mapaDatos,
        keyDato: keyDato,
        campo: StatefulBuilder(
          builder: (context, setState) {
            return Checkbox(
                    value: mapaDatos[keyDato],
                    onChanged: (nuevo) {
                      setState(() {
                        mapaDatos[keyDato] = nuevo;
                      });
                    },
            );
          }
        ));

}