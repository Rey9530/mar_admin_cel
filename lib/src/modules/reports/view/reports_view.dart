import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marcacion_admin/src/common/models/dropdown_button_data_model.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/contract/viewmodel/contracts_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

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
    var provider = Provider.of<ContractsProvider>(context, listen: false);
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
          const SizedBox(
            width: 400,
            child: _ListCompaniesWidget(),
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
                    hinText: 'dd/mm/AAAA',
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##/##/####',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    controller: provider.startDateFilter,
                    onChange: (valor) async {},
                    suffixIcon: InkWell(
                      onTap: () async {
                        var data = await showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year-3),
                          lastDate: DateTime(DateTime.now().year, 12, 31),
                          // barrierDismissible: false,
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          locale: const Locale('es', 'ES'),
                        );
                        if (data != null) {
                          String onlydate =
                              DateFormat("dd/MM/yyyy").format(data);
                          provider.startDateFilter.text = onlydate;
                          provider.notifyListens();
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
                    hinText: 'dd/mm/AAAA',
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##/##/####',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    controller: provider.endDateFilter,
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
                          String onlydate =
                              DateFormat("dd/MM/yyyy").format(data);
                          provider.endDateFilter.text = onlydate;
                          provider.notifyListens();
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
            child: const BtnGenerateWidget(),
          ),
        ],
      ),
    );
  }
}

class BtnGenerateWidget extends StatelessWidget {
  const BtnGenerateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context);
    return BtnWidget(
      disable: (provider.startDateFilter.text.length < 10 ||
          provider.endDateFilter.text.length < 10 ||
          provider.companyFilter.text.length < 10),
      width: 200,
      loading: provider.loading,
      title: "Generar reporte",
      onPress: () async {
        await provider.generateExcelMakingsContracts();
      },
    );
  }
}

class _ListCompaniesWidget extends StatelessWidget {
  const _ListCompaniesWidget();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context, listen: false);
    return SizedBox(
      width: 500,
      child: FutureBuilder(
        future: provider.getContracts(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: 50,
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return SelectCompaniesWidget(
            controller: provider.companyFilter,
            title: 'Lista de contratos',
            onChange: (val) {
              provider.notifyListens();
            },
            textSelected: 'Seleccione una opcion por favor',
            items: [
              if (snapshot.data != null)
                ...provider.contracts.map(
                  (e) => DropdownButtonData(
                    id: e.ctrCodigo,
                    title: e.ctrName,
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
