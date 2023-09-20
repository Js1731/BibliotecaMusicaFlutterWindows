import 'package:biblioteca_musica/misc/utiles.dart';
import 'package:biblioteca_musica/widgets/btn_generico.dart';
import 'package:biblioteca_musica/widgets/btn_popupmenu_generico.dart';
import 'package:biblioteca_musica/widgets/decoracion_.dart';
import 'package:flutter/material.dart';

class CintaOpciones extends StatefulWidget {
  final List<Widget> lstOpciones;

  const CintaOpciones({required this.lstOpciones, super.key});

  @override
  State<StatefulWidget> createState() => EstadoCintaOpciones();
}

class EstadoCintaOpciones extends State<CintaOpciones> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.maxFinite,
      height: 35,
      decoration: BoxDecoration(
          color: DecoColores.gris0, borderRadius: BorderRadius.circular(5)),
      child: Row(children: widget.lstOpciones),
    );
  }
}

class SeccionCintaOpciones extends StatefulWidget {
  final List<Widget> lstItems;
  const SeccionCintaOpciones({required this.lstItems, super.key});

  @override
  State<StatefulWidget> createState() => EstadoSeccionCintaOpciones();
}

class EstadoSeccionCintaOpciones extends State<SeccionCintaOpciones> {
  @override
  Widget build(BuildContext context) {
    List<Widget> lstItems = [];

    for (var i = 0; i < widget.lstItems.length - 1; i++) {
      final item = widget.lstItems[i];

      lstItems.insert(lstItems.length, item);

      if (item is! TextoCintaOpciones) {
        lstItems.insert(
            lstItems.length,
            const VerticalDivider(
              width: 2,
            ));
      }
    }
    lstItems.insert(lstItems.length, widget.lstItems.last);

    return Container(
      height: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Deco.cGray0),
      child: Row(children: lstItems),
    );
  }
}

class TextoCintaOpciones extends StatelessWidget {
  final IconData? icono;
  final String texto;

  const TextoCintaOpciones({super.key, this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          icono != null ? Icon(icono) : const SizedBox(),
          Text(texto),
        ],
      ),
    );
  }
}

class BotonCintaOpciones extends BtnGenerico {
  BotonCintaOpciones(
      {required String texto,
      required IconData icono,
      required ModoResponsive modoResponsive,
      super.onPressed,
      super.key})
      : super(
          builder: (hover, context) => Container(
            height: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: hover ? Colors.white24 : Colors.transparent,
            child: Row(
              children: [
                Icon(
                  icono,
                  color: Deco.cGray1,
                ),
                if (modoResponsive == ModoResponsive.normal)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(texto),
                  ),
              ],
            ),
          ),
        );
}

class BotonPopUpMenuCintaOpciones<T> extends BtnPopupMenuGenerico<T> {
  BotonPopUpMenuCintaOpciones(
      {super.key,
      super.enabled,
      IconData? icono,
      required String texto,
      required ModoResponsive modoResponsive,
      required super.onSelected,
      required super.itemBuilder})
      : super(
            botonBuilder: (hover, context) => Container(
                  height: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: hover ? Colors.white24 : Colors.transparent,
                  child: Row(
                    children: [
                      icono != null
                          ? Icon(
                              icono,
                              color: Deco.cGray1,
                            )
                          : const SizedBox(),
                      if (modoResponsive == ModoResponsive.normal)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(texto),
                        ),
                    ],
                  ),
                ));
}
