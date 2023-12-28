import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marcacion_admin/src/common/const/const.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';
import 'package:marcacion_admin/src/common/models/dropdown_button_data_model.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/employees/viewmodel/employes_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class AddEmployeeView extends StatelessWidget {
  const AddEmployeeView({super.key, this.uuid});
  final String? uuid;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<EmployeesProvider>(context, listen: false);
    return FutureBuilder(
      future: provider.getsCatalogs(uuid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return const AddEmployeBodyWidget();
      },
    );
  }
}

class AddEmployeBodyWidget extends StatelessWidget {
  const AddEmployeBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<EmployeesProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          BreadCrumbsWidget(
            title:
                'Empleados / ${provider.uuid != null ? "${provider.employeeName.text} ${provider.employeeSurname.text}" : "Nuevo empleado"}',
          ),
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: GoBackWidget(),
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
          const _FormewEmployeWidget()
        ],
      ),
    );
  }
}

class _FormewEmployeWidget extends StatelessWidget {
  const _FormewEmployeWidget();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<EmployeesProvider>(context);
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      const SizedBox(width: 30),
                      Container(
                        padding: const EdgeInsets.only(top: 7),
                        child: const Icon(
                          Icons.info_outline,
                          size: 36,
                        ),
                      ),
                      Text(
                        "Código: ",
                        style: TextStyle(
                          color: getTheme(context).primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        "TER-${provider.employeeCode}",
                        style: const TextStyle(
                          color: textGraySubtitle,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 400,
                  child: TextFormFieldCustomWidget(
                    isDark: true,
                    label: "Nombres",
                    hinText: 'Escribe los nombres del nuevo empleado',
                    controller: provider.employeeName,
                    onChange: (valor) {
                      // provider.validarInput();
                    },
                    validations: const [
                      minLength5,
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 400,
                  child: TextFormFieldCustomWidget(
                    isDark: true,
                    label: "Apellidos",
                    hinText: 'Escribe los apellidos del nuevo empleado',
                    controller: provider.employeeSurname,
                    onChange: (valor) {
                      // provider.validarInput();
                    },
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
                    label: "Fecha de nacimiento",
                    hinText: 'dd/mm/AAAA',
                    controller: provider.employeeBirthDate,
                    onChange: (String valor) async {
                      if (valor.length < 10) return;
                      try {
                        await provider.generateCode(valor);
                      } catch (e) {
                        return;
                      }
                      // provider.validarInput();
                    },
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
                        if (data != null) {
                          String onlydate =
                              DateFormat("dd/MM/yyyy").format(data);
                          provider.employeeBirthDate.text = onlydate;
                          String birthDate =
                              DateFormat("yyyy-MM-dd").format(data);
                          await provider.generateCode(birthDate);
                        }
                      },
                      child: Image.asset("assets/icons/calendar_primary.png"),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 405,
                  child: const SelectGenderWidget(),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 620,
                  child: SelectCompaniesWidget(
                    controller: provider.employeeLocation,
                    title: 'Sede asignada',
                    onChange: (val) {},
                    selected: DropdownButtonData(
                      id: provider.employeeLocation.text,
                      title: provider.employeeLocation.text,
                    ),
                    items: [
                      ...provider.sedes.map(
                        (e) => DropdownButtonData(
                          id: e.ubiCodigo,
                          title: e.ubiNombre,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 400,
                  child: SelectCompaniesWidget(
                    controller: provider.employeeCompany,
                    title: 'Empresa',
                    onChange: (val) async {
                      await provider.getContracts(val.id);
                    },
                    selected: DropdownButtonData(
                      id: provider.employeeCompany.text,
                      title: provider.employeeCompany.text,
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 400,
                  child: const _SelectContractsWidget(),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 200,
                  child: const SelectHoursWidget(),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 400,
                  child: SelectCompaniesWidget(
                    controller: provider.employeeContratacion,
                    title: 'Tipo de contratación',
                    selected: DropdownButtonData(
                      id: provider.employeeContratacion.text,
                      title: provider.employeeContratacion.text,
                    ),
                    items: [
                      ...provider.contratations.map(
                        (e) => DropdownButtonData(
                          id: e.conCodigo,
                          title: e.conNombre,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: 400,
                  child: TextFormFieldCustomWidget(
                    isDark: true,
                    label: "Fecha de inicio",
                    hinText: 'dd/mm/AAAA',
                    validations: const [
                      validationIsDate,
                    ],
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##/##/####',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    controller: provider.employeeDateStart,
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
                          provider.employeeDateStart.text = onlydate;
                        }
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
                    isDark: true,
                    label: "Fecha de fin",
                    hinText: 'dd/mm/AAAA',
                    validations: const [
                      validationIsDate,
                    ],
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '##/##/####',
                        filter: {"#": RegExp(r'[0-9]')},
                        type: MaskAutoCompletionType.lazy,
                      ),
                    ],
                    controller: provider.employeeDateEnd,
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
                        if (data != null) {
                          String onlydate =
                              DateFormat("dd/MM/yyyy").format(data);
                          provider.employeeDateStart.text = onlydate;
                        }
                      },
                      child: Image.asset("assets/icons/calendar_primary.png"),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: BtnWidget(
                    width: 200,
                    height: 60,
                    loading: provider.loading,
                    title: "Guardar",
                    onPress: () async {
                      // provider.saveEmploye();
                      if (provider.formKey.currentState?.validate() ?? false) {
                        await provider.saveEmploye();
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

class SelectHoursWidget extends StatelessWidget {
  const SelectHoursWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<EmployeesProvider>(context);
    return provider.loadingHours
        ? const CircularProgressIndicator()
        : SelectCompaniesWidget(
            isRequired: false,
            controller: provider.employeeHours,
            title: 'Horario',
            selected: DropdownButtonData(
              id: provider.employeeHours.text,
              title: provider.employeeHours.text,
            ),
            items: [
              ...provider.hoursCtr.map(
                (e) => DropdownButtonData(
                  id: e.horCodigo,
                  title: e.horName,
                ),
              ),
            ],
          );
  }
}

class _SelectContractsWidget extends StatelessWidget {
  const _SelectContractsWidget();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<EmployeesProvider>(context);
    return provider.loading
        ? const CircularProgressIndicator()
        : SelectCompaniesWidget(
            controller: provider.employeeContact,
            isRequired: false,
            title: 'Código de contrato',
            selected: DropdownButtonData(
              id: provider.employeeContact.text,
              title: provider.employeeContact.text,
            ),
            onChange: (val) async {
              await provider.getHoursContracts(val.id);
            },
            items: [
              ...provider.contractsEmp.map(
                (e) => DropdownButtonData(
                  id: e.ctrCodigo,
                  title: e.ctrNombre,
                ),
              )
            ],
          );
  }
}

class SelectGenderWidget extends StatefulWidget {
  const SelectGenderWidget({
    super.key,
  });

  @override
  State<SelectGenderWidget> createState() => _SelectGenderWidgetState();
}

class _SelectGenderWidgetState extends State<SelectGenderWidget> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<EmployeesProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...provider.genders.map(
          (e) => Padding(
            padding: const EdgeInsets.only(right: 40),
            child: InkWell(
              onTap: () {
                setState(() {
                  provider.employeeGender.text = e.genCodigo;
                });
              },
              child: Row(
                children: [
                  Text(
                    e.genNombre,
                    style: TextStyle(
                      color: getTheme(context).primary,
                      fontSize: 20,
                    ),
                  ),
                  Radio(
                    value: e.genCodigo,
                    groupValue: provider.employeeGender.text,
                    onChanged: (v) {
                      setState(() {
                        provider.employeeGender.text = v!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
