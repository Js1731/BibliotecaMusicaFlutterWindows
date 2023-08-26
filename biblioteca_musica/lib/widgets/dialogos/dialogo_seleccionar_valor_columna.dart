import 'package:biblioteca_musica/backend/controles/control_panel_central_columnas.dart';
import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/widgets/btn_color.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:biblioteca_musica/widgets/dialogos/abrir_dialogo.dart';
import 'package:biblioteca_musica/widgets/dialogos/item_valor_columna_dialogo.dart';
import 'package:biblioteca_musica/widgets/form/txt_field.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';

Future<List<ValorColumnaData>> obtValoresColumna(
    int idTipo, String filtro) async {
  final consulta = appDb.select(appDb.valorColumna)
    ..where(
        (tbl) => tbl.idColumna.equals(idTipo) & tbl.nombre.like("%$filtro%"));
  final resultados = await consulta.get();

  return resultados;
}

///Abre una interfaz para seleccionar un Valor Columna posible de una Columna.
///
///Permite utilizar una barra de busqueda para filtrar por nombre los Valores.
Future abrirDialogoSeleccionarValorColumn(
    ColumnaData columna, ValorColumnaData? valori) async {
  //
  ValorColumnaData? valorSel = valori;
  List<ValorColumnaData> lstValoresPropiedad =
      await obtValoresColumna(columna.id, "");
  String filtroBusquedaValorColumna = "";

  return mostrarDialogo<ValorColumnaData?>(
      contenido: AlertDialog(
    title: TextoPer(
        texto: "Escoger ${columna.nombre}", tam: 20, weight: FontWeight.bold),
    content: StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        width: 600,
        height: 350,
        child: Column(
          children: [
            //BARRA DE BUSQUEDA
            Row(
              children: [
                Expanded(
                    child: TextFieldCustom(
                  filtroBusquedaValorColumna,
                  (nuevo) => filtroBusquedaValorColumna = nuevo,
                )),

                const SizedBox(width: 10),

                //BUSCAR VALORES COLUMNA POR NOMBRE
                BtnColor(
                    setcolor: SetColores.morado1,
                    texto: "Buscar",
                    onPressed: (_) async {
                      lstValoresPropiedad = await obtValoresColumna(
                          columna.id, filtroBusquedaValorColumna);
                      setState(
                        () {},
                      );
                    })
              ],
            ),

            const SizedBox(height: 20),

            //LISTA DE VALORES COLUMNA
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Deco.cGray, borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  child: Wrap(spacing: 15, runSpacing: 30, children: [
                    for (var valor in lstValoresPropiedad)
                      ItemValorColumnaDialogo(
                        seleccionado: valor.id == valorSel?.id,
                        valorPropiedad: valor,
                        onSeleccionado: (_) {
                          setState(() {
                            valorSel = valor;
                          });
                        },
                      )
                  ]),
                ),
              ),
            ),

            const SizedBox(height: 10),

            //OPCIONES DEL DIALOGO
            Row(
              children: [
                //AGREGAR NUEVO VALOR COLUMNA
                BtnColor(
                    setcolor: SetColores.morado0,
                    texto: "Nuevo ${columna.nombre}",
                    onPressed: (_) async {
                      valorSel = await agregarValorColumna(columna);
                      lstValoresPropiedad = await obtValoresColumna(
                          columna.id, filtroBusquedaValorColumna);
                      setState(() {});
                    }),

                const Spacer(flex: 3),

                //SELECCIONAR NUEVAS COLUMNAS
                BtnColor(
                    setcolor: SetColores.morado0,
                    texto: "Seleccionar",
                    onPressed: (_) {
                      Navigator.pop(context, valorSel);
                    }),

                const SizedBox(width: 10),

                //CANCELAR Y CERRAR DIALOGO
                BtnColor(
                    setcolor: SetColores.morado0,
                    texto: "Cancelar",
                    onPressed: (_) {
                      Navigator.pop(context);
                    })
              ],
            )
          ],
        ),
      );
    }),
  ));
}
