import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';
import 'package:marcacion_admin/src/common/models/dropdown_button_data_model.dart';
import 'package:marcacion_admin/src/common/services/services.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/contract/viewmodel/contracts_provider.dart';
import 'package:marcacion_admin/src/routes/router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class FormContractsView extends StatelessWidget {
  const FormContractsView({super.key, this.uuid});
  final String? uuid;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context, listen: false);
    return FutureBuilder(
      future: provider.loadData(uuid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return const AddContractsBodyWidget();
      },
    );
  }
}

class AddContractsBodyWidget extends StatelessWidget {
  const AddContractsBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          BreadCrumbsWidget(
            title:
                'Contratos / ${provider.uuid != null ? "Actualizar" : "Crear"} contrato',
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GoBackWidget(
              function: () {
                NavigationService.replaceTo(Flurorouter.contractsRoute);
              },
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Completa los campos. Al terminar da clic en el botón “Guardar”.",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 50),
          const _ForNewContractsWidget()
        ],
      ),
    );
  }
}

class _ForNewContractsWidget extends StatelessWidget {
  const _ForNewContractsWidget();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context);
    return Form(
      key: provider.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 1100,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 400,
                  child: TextFormFieldCustomWidget(
                    isDark: true,
                    label: "Nombre del contrato",
                    hinText: 'Escribe el nombre para tu contrato',
                    controller: provider.contractName,
                    validations: const [
                      minLength5,
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  width: 200,
                  child: TextFormFieldCustomWidget(
                    isDark: true,
                    label: "Número de contrato",
                    hinText: 'Escribe el número de contrato',
                    controller: provider.contractsNumber,
                    validations: const [
                      minLength5,
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 200,
                  child: TextFormFieldCustomWidget(
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##/##/####',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    validations: const [
                      validationIsDate,
                    ],
                    isDark: true,
                    label: "Fecha de inicio",
                    hinText: 'DD/MM/AA',
                    controller: provider.startDate,
                    onChange: (String valor) async {},
                    suffixIcon: InkWell(
                      onTap: () async {
                        var data = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now().add(
                            const Duration(days: -6570),
                          ),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          locale: const Locale('es', 'ES'),
                        );
                        if (data != null) {}
                      },
                      child: Image.asset("assets/icons/calendar_primary.png"),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 200,
                  child: TextFormFieldCustomWidget(
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##/##/####',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    validations: const [
                      validationIsDate,
                    ],
                    isDark: true,
                    label: "Fecha de fin",
                    hinText: 'DD/MM/AA',
                    controller: provider.endDate,
                    onChange: (String valor) async {},
                    suffixIcon: InkWell(
                      onTap: () async {
                        var data = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now().add(
                            const Duration(days: -6570),
                          ),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                          locale: const Locale('es', 'ES'),
                        );
                        if (data != null) {}
                      },
                      child: Image.asset("assets/icons/calendar_primary.png"),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 350,
                  child: SelectCompaniesWidget(
                    controller: provider.company,
                    title: 'Empresa',
                    onChange: (val) {},
                    selected: DropdownButtonData(
                      id: provider.company.text,
                      title: provider.company.text,
                    ),
                    items: [
                      ...provider.companies.map(
                        (e) => DropdownButtonData(
                          id: e.eprCodigo,
                          title: e.eprNombre,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  width: 170,
                  child: TextFormFieldCustomWidget(
                    isDark: true,
                    label: "Horas extras",
                    hinText: 'Ingrese una cantidad',
                    controller: provider.extraHours,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  width: 160,
                  child: const SwitchListTileExample(),
                ),
                if (provider.isExtendable)
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    width: 150,
                    child: TextFormFieldCustomWidget(
                      isDark: true,
                      label: "Inicio de prórroga",
                      hinText: 'DD/MM/AA',
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '##/##/####',
                          filter: {"#": RegExp(r'[0-9]')},
                          type: MaskAutoCompletionType.lazy,
                        ),
                      ],
                      validations: const [
                        validationIsDate,
                      ],
                      controller: provider.startDateExtendable,
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
                          if (data != null) {}
                        },
                        child: Image.asset("assets/icons/calendar_primary.png"),
                      ),
                    ),
                  ),
                if (provider.isExtendable)
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    width: 150,
                    child: TextFormFieldCustomWidget(
                      isDark: true,
                      label: "Fin de prórroga",
                      hinText: 'DD/MM/AA',
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: '##/##/####',
                          filter: {"#": RegExp(r'[0-9]')},
                          type: MaskAutoCompletionType.lazy,
                        ),
                      ],
                      validations: const [
                        validationIsDate,
                      ],
                      controller: provider.endDateExtendable,
                      onChange: (valor) async {},
                      suffixIcon: InkWell(
                        onTap: () async {
                          var data = await showDatePicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(DateTime.now().year, 12, 31),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                            locale: const Locale('es', 'ES'),
                          );
                          if (data != null) {}
                        },
                        child: Image.asset("assets/icons/calendar_primary.png"),
                      ),
                    ),
                  ),
                if (!provider.isExtendable)
                  const SizedBox(
                    width: 340,
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: BtnWidget(
                    width: 200,
                    height: 60,
                    loading: provider.loading,
                    title: "Guardar",
                    onPress: () async {
                      // provider.saveContract();
                      if (provider.formKey.currentState?.validate() ?? false) {
                        await provider.saveContract();
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SwitchListTileExample extends StatefulWidget {
  const SwitchListTileExample({super.key});

  @override
  State<SwitchListTileExample> createState() => _SwitchListTileExampleState();
}

class _SwitchListTileExampleState extends State<SwitchListTileExample> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context, listen: false);
    return Container(
      alignment: Alignment.center,
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Switch(
            activeColor: Colors.white,
            inactiveThumbColor: getTheme(context).primary,
            inactiveTrackColor: Colors.white,
            activeThumbImage: const AssetImage("assets/icons/check_24px.png"),
            inactiveThumbImage: const AssetImage("assets/icons/icon_close.png"),
            activeTrackColor: getTheme(context).primary,
            value: provider.isExtendable,
            onChanged: (bool value) {
              setState(() {
                provider.changeIsExtendable(value);
              });
            },
          ),
          const SizedBox(width: 10),
          Text(
            "Prorrogable",
            style: TextStyle(
              color: getTheme(context).primary,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
