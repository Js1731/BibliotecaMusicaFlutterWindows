import 'package:biblioteca_musica/bloc/columnas_sistema/bloc_columnas_sistema.dart';
import 'package:biblioteca_musica/bloc/columnas_sistema/eventos_columnas_sistema.dart';
import 'package:biblioteca_musica/bloc/sincronizador/cubit_sincronizacion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/btn_flotante_simple.dart';
import '../widgets/decoracion_.dart';
import '../widgets/form/txt_field.dart';
import '../widgets/texto_per.dart';

class ContenidoAgregarColumna extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final VoidCallback onAgregarColumna;
  final Widget btnVolver;
  final TextEditingController txtController = TextEditingController();

  ContenidoAgregarColumna({
    super.key,
    required this.btnVolver,
    required this.onAgregarColumna,
  });

  void _agregarColumna(BuildContext context) {
    if (_formkey.currentState!.validate()) {
      context
          .read<BlocColumnasSistema>()
          .add(EvAgregarColumna(txtController.text));
      context.read<CubitSincronizacion>().cambiarEstado(EstadoSinc.nuevoLocal);
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
              ///TITULO
              SizedBox(
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

              //DESCRIPCION
              TextoPer(
                texto: "Ingrese el nombre de la nueva columna",
                tam: 14,
              ),
              const SizedBox(height: 10),

              //TEXTFIELD PARA NOMBRE
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

              ///BOTON AGREGAR
              BtnFlotanteSimple(
                  ancho: 250,
                  onPressed: () {
                    _agregarColumna(context);
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
