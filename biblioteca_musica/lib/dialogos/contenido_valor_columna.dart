import 'package:biblioteca_musica/datos/AppDb.dart';
import 'package:biblioteca_musica/misc/archivos.dart';
import 'package:biblioteca_musica/repositorios/repositorio_columnas.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/btn_flotante_icono.dart';
import '../widgets/btn_flotante_simple.dart';
import '../widgets/decoracion_.dart';
import '../widgets/form/txt_field.dart';
import '../widgets/imagen_round_rect.dart';
import '../widgets/texto_per.dart';

class ContenidoValorColumna extends StatefulWidget {
  final ColumnaData columna;
  final void Function(ValorColumnaData nuevoValorColuma)? onAceptarValorColumna;
  final Widget? btnVolver;
  final ValorColumnaData? valorColumnaIni;

  const ContenidoValorColumna(
      {super.key,
      required this.columna,
      this.onAceptarValorColumna,
      this.btnVolver,
      this.valorColumnaIni});

  @override
  State<StatefulWidget> createState() => _EstadoContenidoValorColumna();
}

class _EstadoContenidoValorColumna extends State<ContenidoValorColumna> {
  String? urlSel;
  final _formKey = GlobalKey<FormState>();
  final txtController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.valorColumnaIni != null) {
      urlSel = rutaImagen(widget.valorColumnaIni!.id);
      txtController.text = widget.valorColumnaIni!.nombre;
    }
  }

  Future<void> _buscarImagen() async {
    final FilePickerResult? resultados = await FilePicker.platform.pickFiles();

    if (resultados == null) return;

    setState(() {
      urlSel = resultados.paths.first;
    });
  }

  Future<void> _agregarValorColumna(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final valorColumnaNuevo = await context
          .read<RepositorioColumnas>()
          .agregarValorColumna(txtController.text, widget.columna.id, urlSel);

      if (widget.onAceptarValorColumna != null) {
        widget.onAceptarValorColumna!(valorColumnaNuevo);
      }
    }
  }

  Future<void> _editarValorColumna(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final valorColumnaNuevo = await context
          .read<RepositorioColumnas>()
          .editarValorColumna(
              widget.valorColumnaIni!.id, txtController.text, urlSel);

      if (widget.onAceptarValorColumna != null) {
        widget.onAceptarValorColumna!(valorColumnaNuevo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                      child: widget.btnVolver,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 30),
                      child: TextoPer(
                        texto: widget.columna.nombre,
                        tam: 16,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              ///IMAGEN DE VALOR COLUMNA
              SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  children: [
                    ImagenRectRounded(
                      tam: 100,
                      radio: 10,
                      sombra: false,
                      url: urlSel,
                    ),
                    Container(
                      margin: const EdgeInsets.all(2),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: BtnFlotanteIcono(
                          onPressed: () async {
                            await _buscarImagen();
                          },
                          icono: Icons.file_open,
                          color: Colors.black38,
                          tamIcono: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),

              ///RUTA
              TextoPer(
                  texto: urlSel ??
                      "Selecciona una imagen para el ${widget.columna.nombre}",
                  color: Colors.black26),
              const SizedBox(height: 10),

              ///DESCRIPCION
              TextoPer(
                texto: "Ingrese el nombre del ${widget.columna.nombre}",
                tam: 14,
              ),
              const SizedBox(height: 10),

              ///TEXTFIELD PARA EL NOMBRE
              TextFormField(
                controller: txtController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingresa un nombre valido";
                  }
                  return null;
                },
                decoration: CustomTxtFieldDecoration(
                    hint: "Ej. Nuevo ${widget.columna.nombre}"),
              ),
              const Spacer(),

              ///BOTON AGREGAR VALOR
              BtnFlotanteSimple(
                  ancho: 250,
                  onPressed: () async {
                    if (widget.valorColumnaIni != null) {
                      await _editarValorColumna(context);
                    } else {
                      await _agregarValorColumna(context);
                    }
                  },
                  texto: widget.valorColumnaIni == null
                      ? "Agregar"
                      : "Actualizar"),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}
