import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marcacion_admin/src/common/const/const.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/contract/model/index.dart';
import 'package:marcacion_admin/src/modules/contract/viewmodel/contracts_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ListHoursWidgets extends StatelessWidget {
  const ListHoursWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ItemHoursWidget(),
      ],
    );
  }
}

class ItemHoursWidget extends StatelessWidget {
  const ItemHoursWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context, listen: false);
    return Stack(
      children: [
        Container(
          width: 975,
          height: 650,
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          padding: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColorContainers,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (var day in provider.schedule) DayItemWidget(item: day),
                ],
              ),
              BtnWidget(
                width: 200,
                loading: provider.loading,
                title: "Continuar",
                onPress: () async {
                  await provider.saveScheduleContract();
                },
              )
            ],
          ),
        ),
        Positioned(
          left: 50,
          top: 10,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: Text(
              'Nuevo',
              style: TextStyle(
                color: getTheme(context).primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DayItemWidget extends StatelessWidget {
  const DayItemWidget({
    super.key,
    required this.item,
  });
  final Schedule item;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context);
    return SizedBox(
      width: 130,
      child: Column(
        children: [
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (item.entrada1.text.isEmpty || item.salida1.text.isEmpty)
                  ? colorContainers
                  : getTheme(context).primary,
              border: Border.all(
                width: 1,
                color: getTheme(context).primary,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (item.entrada1.text.isNotEmpty &&
                    item.salida1.text.isNotEmpty) ...[
                  Image.asset("assets/icons/check_white.png"),
                  const SizedBox(width: 5),
                ],
                Text(
                  item.day.diaNombre,
                  style: TextStyle(
                    color: (item.entrada1.text.isEmpty ||
                            item.salida1.text.isEmpty)
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 80,
            child: TextFormFieldCustomWidget(
              isDark: true,
              readOnly: true,
              label: "Entrada",
              hinText: '00:00',
              controller: item.entrada1,
              onChange: (valor) {},
              suffixIcon: InkWell(
                onTap: () {
                  var dialog = DialogTimeWidget(
                    currentTime: item.entrada1.text,
                    onChange: (String valor) {
                      item.entrada1.text = valor;
                      provider.notifyListens();
                    },
                  );
                  showDialog(context: context, builder: (_) => dialog);
                },
                child: Image.asset("assets/icons/alarm-plus.png"),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 80,
            child: TextFormFieldCustomWidget(
              isDark: true,
              readOnly: true,
              label: "Salida",
              hinText: '00:00',
              controller: item.salida1,
              onChange: (valor) {
                // provider.validarInput();
              },
              suffixIcon: InkWell(
                onTap: () {
                  var dialog = DialogTimeWidget(
                    currentTime: item.salida1.text,
                    onChange: (String valor) {
                      item.salida1.text = valor;
                      provider.notifyListens();
                    },
                  );
                  showDialog(context: context, builder: (_) => dialog);
                },
                child: Image.asset("assets/icons/alarm-plus.png"),
              ),
            ),
          ),
          Builder(
            builder: (BuildContext context) {
              var nextDay = provider.schedule
                  .where((e) =>
                      int.tryParse(e.day.diaDiaCodigo) ==
                      (int.tryParse(item.day.diaDiaCodigo) ?? 0) + 1)
                  .toList();
              var beforeDay = provider.schedule
                  .where((e) =>
                      int.tryParse(e.day.diaDiaCodigo) ==
                      (int.tryParse(item.day.diaDiaCodigo) ?? 0) - 1)
                  .toList();
              return (nextDay.isNotEmpty &&
                      item.entrada1.text.isNotEmpty &&
                      item.salida1.text.isNotEmpty &&
                      nextDay.first.entrada1.text.isEmpty &&
                      nextDay.first.salida1.text.isEmpty)
                  ? InkWell(
                      onTap: () {
                        nextDay.first.entrada1.text = item.entrada1.text;
                        nextDay.first.salida1.text = item.salida1.text;
                        provider.notifyListens();
                      },
                      child: SizedBox(
                        height: 45,
                        child: Column(
                          children: [
                            Image.asset("assets/icons/copy.png"),
                            Text(
                              "Duplicar",
                              style: TextStyle(
                                color: getTheme(context).primary,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : (beforeDay.isEmpty &&
                          (item.entrada1.text.isEmpty ||
                              item.salida1.text.isEmpty))
                      ? SizedBox(
                          height: 45,
                          child: Column(
                            children: [
                              Image.asset("assets/icons/copy-disabled.png"),
                              const Text(
                                "Duplicar",
                                style: TextStyle(
                                  color: disabledIcons,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 45,
                        );
            },
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 1,
            width: double.infinity,
            color: Colors.black,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 80,
            child: TextFormFieldCustomWidget(
              isDark: true,
              readOnly: true,
              label: "Entrada",
              hinText: '00:00',
              controller: item.entrada2,
              onChange: (valor) {
                // provider.validarInput();
              },
              suffixIcon: InkWell(
                onTap: () {
                  var dialog = DialogTimeWidget(
                    currentTime: item.entrada2.text,
                    onChange: (String valor) {
                      item.entrada2.text = valor;
                      provider.notifyListens();
                    },
                  );
                  showDialog(context: context, builder: (_) => dialog);
                },
                child: Image.asset("assets/icons/alarm-plus.png"),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 80,
            child: TextFormFieldCustomWidget(
              isDark: true,
              readOnly: true,
              label: "Salida",
              hinText: '00:00',
              controller: item.salida2,
              onChange: (valor) {
                // provider.validarInput();
              },
              suffixIcon: InkWell(
                onTap: () {
                  var dialog = DialogTimeWidget(
                    currentTime: item.salida2.text,
                    onChange: (String valor) {
                      item.salida2.text = valor;
                      provider.notifyListens();
                    },
                  );
                  showDialog(context: context, builder: (_) => dialog);
                },
                child: Image.asset("assets/icons/alarm-plus.png"),
              ),
            ),
          ),
          Builder(
            builder: (BuildContext context) {
              var nextDay = provider.schedule
                  .where((e) =>
                      int.tryParse(e.day.diaDiaCodigo) ==
                      (int.tryParse(item.day.diaDiaCodigo) ?? 0) + 1)
                  .toList();
              var beforeDay = provider.schedule
                  .where((e) =>
                      int.tryParse(e.day.diaDiaCodigo) ==
                      (int.tryParse(item.day.diaDiaCodigo) ?? 0) - 1)
                  .toList();
              return (nextDay.isNotEmpty &&
                      item.entrada2.text.isNotEmpty &&
                      item.salida2.text.isNotEmpty &&
                      nextDay.first.entrada2.text.isEmpty &&
                      nextDay.first.salida2.text.isEmpty)
                  ? InkWell(
                      onTap: () {
                        nextDay.first.entrada2.text = item.entrada2.text;
                        nextDay.first.salida2.text = item.salida2.text;
                        provider.notifyListens();
                      },
                      child: SizedBox(
                        height: 50,
                        child: Column(
                          children: [
                            Image.asset("assets/icons/copy.png"),
                            Text(
                              "Duplicar",
                              style: TextStyle(
                                color: getTheme(context).primary,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : (beforeDay.isEmpty &&
                          (item.entrada2.text.isEmpty ||
                              item.salida2.text.isEmpty))
                      ? SizedBox(
                          height: 45,
                          child: Column(
                            children: [
                              Image.asset("assets/icons/copy-disabled.png"),
                              const Text(
                                "Duplicar",
                                style: TextStyle(
                                  color: disabledIcons,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: 45,
                        );
            },
          ),
        ],
      ),
    );
  }
}

class DialogTimeWidget extends StatelessWidget {
  DialogTimeWidget({
    super.key,
    required this.onChange,
    this.currentTime = '',
  });
  final Function(String) onChange;
  final String currentTime;
  final hora = TextEditingController();
  final minutos = TextEditingController();
  final turno = TextEditingController(text: 'AM');
  @override
  Widget build(BuildContext context) {
    var split = currentTime.split(":");
    if (split.length > 1) {
      hora.text = split[0];
      minutos.text = split[1][0] + split[1][1];
      turno.text = split[1][2] + split[1][3];
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: SizedBox(
        height: 161,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ingresa la hora",
              style: TextStyle(color: textGray),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 126,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 81,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormFieldCustomWidget(
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          fontSize: 40,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 5,
                          ),
                          isDark: true,
                          label: '',
                          controller: hora,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                            MaskTextInputFormatter(
                              mask: '#%',
                              filter: {
                                "#": RegExp(r'[0-1]'),
                                "%": RegExp(r'[0-9]'),
                              },
                              type: MaskAutoCompletionType.lazy,
                            ),
                          ],
                        ),
                        const Text(
                          "Horas",
                          style: TextStyle(color: textGray),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 75,
                    margin: const EdgeInsets.only(bottom: 50),
                    child: Text(
                      ":",
                      style: TextStyle(
                        fontSize: 40,
                        color: getTheme(context).primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 81,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormFieldCustomWidget(
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          fontSize: 40,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 5,
                          ),
                          isDark: true,
                          label: '',
                          controller: minutos,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                            MaskTextInputFormatter(
                              mask: '#%',
                              filter: {
                                "#": RegExp(r'[0-5]'),
                                "%": RegExp(r'[0-9]'),
                              },
                              type: MaskAutoCompletionType.lazy,
                            ),
                          ],
                        ),
                        const Text(
                          "Minutos",
                          style: TextStyle(color: textGray),
                        ),
                      ],
                    ),
                  ),
                  AMPMWidget(
                    value: turno.text,
                    onChange: (String valor) {
                      turno.text = valor;
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancelar",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: getTheme(context).primary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                var h = hora.text.length == 1 ? "0${hora.text}" : hora.text;
                var m = minutos.text.length == 1
                    ? "0${minutos.text}"
                    : minutos.text;
                onChange("$h:$m${turno.text}");
                Navigator.pop(context);
              },
              child: Text(
                " OK ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: getTheme(context).primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AMPMWidget extends StatefulWidget {
  const AMPMWidget({
    super.key,
    required this.onChange,
    this.value = 'AM',
  });
  final Function(String) onChange;
  final String value;
  @override
  State<AMPMWidget> createState() => _AMPMWidgetState();
}

class _AMPMWidgetState extends State<AMPMWidget> {
  bool isAM = true;
  @override
  void initState() {
    super.initState();
    isAM = widget.value == 'AM';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isAM = true;
              });
              widget.onChange("AM");
            },
            child: Container(
              width: 80,
              height: 42,
              decoration: BoxDecoration(
                color: isAM ? getTheme(context).primary : Colors.white,
                border: Border.all(
                  width: 1,
                  color: getTheme(context).primary,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "AM",
                style: TextStyle(
                  color: isAM ? Colors.white : getTheme(context).primary,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isAM = false;
              });
              widget.onChange("PM");
            },
            child: Container(
              width: 80,
              height: 42,
              decoration: BoxDecoration(
                color: isAM ? Colors.white : getTheme(context).primary,
                border: Border.all(
                  width: 1,
                  color: getTheme(context).primary,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                "PM",
                style: TextStyle(
                  color: isAM ? getTheme(context).primary : Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
