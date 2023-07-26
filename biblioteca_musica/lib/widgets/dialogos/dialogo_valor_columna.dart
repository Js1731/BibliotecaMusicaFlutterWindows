import 'dart:io';

import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/pantallas/item_valor_columna.dart';
import 'package:biblioteca_musica/pantallas/pant_principal.dart';
import 'package:biblioteca_musica/widgets/btn_color.dart';
import 'package:biblioteca_musica/widgets/dialogos/abrir_dialogo.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/widgets/form/form_field_imagen.dart';
import 'package:biblioteca_musica/widgets/form/txt_field.dart';
import 'package:biblioteca_musica/widgets/texto_per.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca_musica/widgets/imagen_round_rect.dart';

///Abre un dialogo para que el usuario edite la imagen y el nombre de un [ValorColumna].
///
///Retorna un mapa con {nombre : Nombre del ValorColumna, url : URL de la imagen asociada al ValorColumna}
Future<Map<String, String?>?> abrirDialogoEditarValorColumna(
    ColumnaData tipoPropiedad, ValorColumnaData valorPropiedad) {
  String? url;
  if (File(obtDirImagen(valorPropiedad.id)).existsSync()) {
    url = obtDirImagen(valorPropiedad.id);
  }
  return abrirDialogoValorColumna(
      tipoPropiedad.nombre, valorPropiedad.nombre, url);
}

///Abre un dialogo para que el usuario ingrese un nuevo [ValorColumna].
///
///Retorna un mapa con {nombre : Nombre del ValorColumna, url : URL de la imagen asociada al ValorColumna}
Future<Map<String, String?>?> abrirDialogoAgregarValorColumna(
    ColumnaData tipoPropiedad) {
  return abrirDialogoValorColumna(tipoPropiedad.nombre, null, null);
}

Future<bool> esNombreColumnaUnico(String nombre) async {
  return await (appDb.select(appDb.valorColumna)
            ..where((tbl) => tbl.nombre.equals(nombre)))
          .getSingleOrNull() ==
      null;
}

Future<Map<String, String?>?> abrirDialogoValorColumna(
    String nombreTipoPropiedad, String? nombreInicial, String? urlInicial) {
  final formkey = GlobalKey<FormState>();
  String? urlGlobal = urlInicial;
  String nombre = nombreInicial ?? "";
  return mostrarDialogo<Map<String, String?>>(
      contenido: AlertDialog(
    title: TextoPer(
        texto:
            "${nombreInicial == null ? "Agregar" : "Editar"} $nombreTipoPropiedad",
        tam: 25,
        weight: FontWeight.bold),
    content: Form(
        key: formkey,
        child: StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: 350,
            height: 150,
            child: Row(children: [
              ImagenRectRounded(
                url: urlGlobal,
                tam: 120,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nombre"),
                    TextFormFieldCustom(nombre, (nuevo) {
                      nombre = nuevo;
                    }),
                    const SizedBox(height: 10),
                    FormFieldImagen(urlInicial: urlInicial, (url_) {
                      return null;
                    }, (url_) {
                      urlGlobal = url_;
                      setState(() {});
                    })
                  ],
                ),
              )
            ]),
          ),
        )),
    actions: [
      BtnColor(
          setcolor: SetColores.morado0,
          w: 100,
          texto: nombreInicial != null ? "Actualizar" : "Agregar",
          onPressed: (_) async {
            if (formkey.currentState!.validate()) {
              if (!await esNombreColumnaUnico(nombre) &&
                  nombre != nombreInicial) {
                await mostrarDialogoConfirmar(keyPantPrincipal.currentContext!,
                    "$nombre ya existe.", "Ingrese un nombre unico.");
                return;
              }
              Navigator.pop(keyPantPrincipal.currentContext!,
                  {"nombre": nombre, "url": urlGlobal});
            }
          }),
      BtnColor(
          setcolor: SetColores.morado2,
          w: 100,
          texto: "Cancelar",
          onPressed: (_) {
            Navigator.pop(keyPantPrincipal.currentContext!);
          })
    ],
  ));
}
