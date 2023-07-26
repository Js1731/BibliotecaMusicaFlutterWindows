import 'package:biblioteca_musica/widgets/btn_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FormFieldImagen extends FormField<String> {
  final FormFieldValidator<String> validador;
  final Function(String) onCambio;

  FormFieldImagen(this.validador, this.onCambio, {urlInicial, super.key})
      : super(
            initialValue: urlInicial,
            validator: validador,
            builder: (FormFieldState<String> estado) {
              return Column(children: [
                BtnColor(
                    setcolor: SetColores.morado0,
                    texto: "Buscar Imagen...",
                    onPressed: (_) async {
                      FilePickerResult? resultados =
                          await FilePicker.platform.pickFiles();
                      if (resultados != null) {
                        estado.didChange(resultados.files.first.path);
                        onCambio(resultados.files.first.path!);
                      }
                    }),
                Text(
                  estado.value ?? "...",
                  softWrap: true,
                )
              ]);
            });
}
