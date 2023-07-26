import 'package:flutter/cupertino.dart';

abstract class FilaConfig extends StatefulWidget{

  final String texto;
  final Widget campo;
  final Map<String, dynamic> mapaDatos;
  final String keyDato;

  const FilaConfig({required this.texto, 
                    required this.campo,
                    required this.mapaDatos,
                    required this.keyDato,
                     super.key});

  @override
  State<StatefulWidget> createState() => EstadoFileConfig();

}

class EstadoFileConfig extends State<FilaConfig>{

  @override
  Widget build(BuildContext context) {
    return Row(
    children: [
      Expanded(
        child: Text(widget.texto),
      ),
      
      widget.campo
    ],
  );
  }

}