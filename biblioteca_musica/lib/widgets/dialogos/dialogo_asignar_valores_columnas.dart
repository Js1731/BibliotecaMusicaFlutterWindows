import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/widgets/btn_color.dart';
import 'package:biblioteca_musica/widgets/dialogos/abrir_dialogo.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_seleccionar_valor_columna.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'item_valor_columna_editable_dialogo.dart';
import 'package:flutter/material.dart';

///Abre un dialogo para que el usuario seleccione que Valor Columna quiere asignar a las Columnas indicadas.
///
///Retorna un mapa que asocia una Columna : ValorColumna.
Future<Map<ColumnaData, ValorColumnaData?>?> abrirDialogoAsignarPropiedad(
    List<ColumnaData> lstColumnas) async {
  final Map<ColumnaData, ValorColumnaData?> mapaValoresAsignados = {
    for (final columna in lstColumnas) columna: null
  };
  return mostrarDialogoAlerta(
    //TITULO
    title: TextoPer(
      texto: "Asignar Valores",
      tam: 20,
      weight: FontWeight.bold,
    ),

    content: StatefulBuilder(
      builder: (context, setState) => SizedBox(
        width: 400,
        height: 200,
        child: ListView.builder(
          itemCount: mapaValoresAsignados.keys.length,
          itemBuilder: (context, index) {
            final columna = lstColumnas[index];
            return ItemValorColumnaEditableDialogo(
                onPressed: () async {
                  ValorColumnaData? valorSel =
                      await abrirDialogoSeleccionarValorColumna(
                          columna, mapaValoresAsignados[columna]);

                  if (valorSel == null) return;

                  mapaValoresAsignados[columna] = valorSel;
                  setState(() {});
                },
                columna: columna,
                valorColumna: mapaValoresAsignados[columna]);
          },
        ),
      ),
    ),

    actions: (context) => [
      BtnColor(
          w: 100,
          setcolor: SetColores.morado1,
          texto: "Aplicar",
          onPressed: (_) {
            Navigator.pop(context, mapaValoresAsignados);
          }),
      BtnColor(
          w: 100,
          setcolor: SetColores.morado1,
          texto: "Cancelar",
          onPressed: (_) {
            Navigator.pop(context);
          })
    ],
  );
}
