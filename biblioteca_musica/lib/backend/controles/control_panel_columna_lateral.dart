import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/pantallas/pant_principal.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_confirmar.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_texto.dart';

Future<void> agregarColumna() async {
  String? nombrePropiedad = await mostrarDialogoTexto(
      keyPantPrincipal.currentContext!, "Agregar nueva Columna");

  if (nombrePropiedad == null) return;

  if (!await nombreTipoPropiedadEsUnico(nombrePropiedad)) {
    mostrarDialogoConfirmar(keyPantPrincipal.currentContext!,
        "$nombrePropiedad ya existe", "Ingrese un nombre unico");
    return;
  }

  await appDb
      .into(appDb.columna)
      .insert(ColumnaCompanion.insert(nombre: nombrePropiedad));

  await actualizarDatosLocales();
}

Future<bool> nombreTipoPropiedadEsUnico(String nombre) async {
  return await (appDb.select(appDb.columna)
            ..where((tbl) => tbl.nombre.equals(nombre)))
          .getSingleOrNull() ==
      null;
}

class ContPanelColumnaLateral {
  Stream<List<ColumnaData>> crearStreamPropiedades() =>
      appDb.select(appDb.columna).watch();
}
