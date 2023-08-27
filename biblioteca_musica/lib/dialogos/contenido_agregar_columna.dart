import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/btn_flotante_icono.dart';
import '../widgets/btn_flotante_simple.dart';
import '../widgets/decoracion_.dart';
import '../widgets/form/txt_field.dart';
import '../widgets/imagen_round_rect.dart';
import '../widgets/texto_per.dart';

class ContenidoAgregarColumna extends StatelessWidget {
  final RepositorioColumnas _repositorioColumnas;
  final _formkey = GlobalKey<FormState>();
  final VoidCallback onAgregarColumna;

  final Widget btnVolver;

  final TextEditingController txtController = TextEditingController();

  ContenidoAgregarColumna(
    this._repositorioColumnas, {
    super.key,
    required this.btnVolver,
    required this.onAgregarColumna,
  });

  void agregarColumna() {
    if (_formkey.currentState!.validate()) {
      _repositorioColumnas.agregarColumna(txtController.text);
      onAgregarColumna();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Container(
        decoration: const BoxDecoration(
            color: DecoColores.gris,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: 30,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: btnVolver,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 30),
                      child: TextoPer(
                        texto: "Agregar Columna",
                        tam: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TextoPer(
                texto: "Ingrese el nombre de la nueva columna",
                tam: 14,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: txtController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingresa un nombre valido";
                  }
                  return null;
                },
                decoration:
                    const CustomTxtFieldDecoration(hint: "Ej. Nueva Columna"),
              ),
              const Spacer(),
              BtnFlotanteSimple(
                  ancho: 250,
                  onPressed: () {
                    agregarColumna();
                  },
                  texto: "Agregar"),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}
