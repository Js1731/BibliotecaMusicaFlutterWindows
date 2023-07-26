import 'package:biblioteca_musica/backend/datos/AppDb.dart';
import 'package:biblioteca_musica/backend/misc/sincronizacion.dart';
import 'package:biblioteca_musica/backend/providers/provider_general.dart';
import 'package:biblioteca_musica/main.dart';
import 'package:biblioteca_musica/pantallas/pant_principal.dart';
import 'package:biblioteca_musica/widgets/dialogos/dialogo_texto.dart';

class ContPanelLateral {
  Future<void> agregarListaNueva() async {
    String? nombre = await mostrarDialogoTexto(
      keyPantPrincipal.currentContext!,
      "Nueva Lista",
    );

    if (nombre == null) return;

    int idNuevaLista = await appDb
        .into(appDb.listaReproduccion)
        .insert(ListaReproduccionCompanion.insert(nombre: nombre));

    await cargarListas();
    provGeneral.seleccionarLista(idNuevaLista);
    provListaRep.actualizarMapaCancionesSel();
    await sincronizar();
  }

  Future<void> cargarListas() async {
    provGeneral.actualizarListaListasRep();
  }
}
