import 'package:biblioteca_musica/bloc/columnas_sistema/bloc_columnas_sistema.dart';
import 'package:biblioteca_musica/dialogos/dialogo_ingresar_texto.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuxiliarColumnasLateral {
  final RepositorioColumnas _repositorioColumnas;

  AuxiliarColumnasLateral(this._repositorioColumnas);

  Future<void> agregarColumna(BuildContext context) async {
    String? nuevoNombre = await abrirDialogoIngresarTexto(
        context, "Nueva Columna", "Ingresa el nombre de la nueva columna");

    if (nuevoNombre == null) return;

    _repositorioColumnas.agregarColumna(nuevoNombre);
  }
}
