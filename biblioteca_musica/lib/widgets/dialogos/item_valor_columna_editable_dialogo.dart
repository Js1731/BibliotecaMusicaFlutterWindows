import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

class ItemValorColumnaEditableDialogo extends StatelessWidget {
  final ColumnaData columna;
  final ValorColumnaData? valorColumna;
  final VoidCallback onPressed;

  const ItemValorColumnaEditableDialogo(
      {super.key,
      required this.onPressed,
      required this.columna,
      required this.valorColumna});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 30,
      child: Stack(
        children: [
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Deco.cGray, borderRadius: BorderRadius.circular(35)),
          ),

          //COLUMNA
          Container(
              width: 120,
              height: double.maxFinite,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Deco.cMorado2,
                  borderRadius: BorderRadius.circular(35)),
              child: TextoPer(
                texto: columna.nombre,
                tam: 14,
                color: Colors.white,
              )),

          //VALOR COLUMNA
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 200,
                child: TextoPer(
                    texto: valorColumna?.nombre ?? "(...)",
                    tam: 14,
                    align: TextAlign.right),
              ),
              IconButton(
                  onPressed: onPressed,
                  iconSize: 16,
                  splashRadius: 20,
                  icon: const Icon(Icons.edit)),
            ],
          )
        ],
      ),
    );
  }
}
