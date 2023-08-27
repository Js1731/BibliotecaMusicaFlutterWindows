import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/widgets/btn_flotante_icono.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';

class ItemValorColumnaEditableDialogo extends StatelessWidget {
  final ColumnaData columna;
  final ValorColumnaData? valorColumna;
  final VoidCallback onPressed;
  final bool enabled;

  const ItemValorColumnaEditableDialogo({
    super.key,
    required this.onPressed,
    required this.columna,
    required this.valorColumna,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 25,
      child: Stack(
        children: [
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Deco.cGray, borderRadius: BorderRadius.circular(35)),
          ),

          //VALOR COLUMNA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  child: TextoPer(
                      texto: valorColumna?.nombre ?? "(...)",
                      tam: 14,
                      align: TextAlign.right),
                ),
                const SizedBox(width: 10),
                BtnFlotanteIcono(
                    enabled: enabled,
                    onPressed: onPressed,
                    tamIcono: 15,
                    tam: 20,
                    icono: Icons.edit),
              ],
            ),
          ),
          //COLUMNA
          Container(
              width: 120,
              height: double.maxFinite,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: DecoColores.rosaClaro,
                  borderRadius: BorderRadius.circular(35)),
              child: TextoPer(
                texto: columna.nombre,
                tam: 14,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
