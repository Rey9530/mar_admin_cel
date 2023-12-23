import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/models/dropdown_button_data_model.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BreadCrumbsWidget(
            title: 'Reportes',
          ),
          BodyReportsWidget(),
        ],
      ),
    );
  }
}

class BodyReportsWidget extends StatelessWidget {
  const BodyReportsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height * 0.85,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Completa los filtros para generar un reporte.",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 400,
            child: SelectCompaniesWidget(
              controller: TextEditingController(),
              title: 'Código de contrato',
              items: [
                DropdownButtonData(id: '1', title: 'Limpieza'),
                DropdownButtonData(id: '2', title: 'Mantenimiento'),
                DropdownButtonData(id: '3', title: 'Vigilancia'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 180,
                  child: TextFormFieldCustomWidget(
                    isDark: true,
                    label: "Desde",
                    hinText: 'DD/MM/AA',
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##/##/####',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    controller: TextEditingController(),
                    onChange: (valor) async {},
                    suffixIcon: InkWell(
                      onTap: () async {
                        var data = await showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year),
                          lastDate: DateTime(DateTime.now().year, 12, 31),
                          // barrierDismissible: false,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          locale: const Locale('es', 'ES'),
                        );
                        if (data != null) {
                          // String onlydate =
                          //     DateFormat("dd/MM/yyyy").format(data);
                          // provider.employeDateStart.text = onlydate;
                        }
                      },
                      child: Image.asset("assets/icons/calendar_primary.png"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: TextFormFieldCustomWidget(
                    isDark: true,
                    label: "Hasta",
                    hinText: 'DD/MM/AA',
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##/##/####',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    controller: TextEditingController(),
                    onChange: (valor) async {},
                    suffixIcon: InkWell(
                      onTap: () async {
                        var data = await showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year),
                          lastDate: DateTime(DateTime.now().year, 12, 31),
                          // barrierDismissible: false,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          locale: const Locale('es', 'ES'),
                        );
                        if (data != null) {
                          // String onlydate =
                          //     DateFormat("dd/MM/yyyy").format(data);
                          // provider.employeDateStart.text = onlydate;
                        }
                      },
                      child: Image.asset("assets/icons/calendar_primary.png"),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 400,
            alignment: Alignment.center,
            child: BtnWidget(
              disable: true,
              width: 200,
              title: "Generar reporte",
              onPress: () {},
            ),
          ),
        ],
      ),
    );
  }
}
