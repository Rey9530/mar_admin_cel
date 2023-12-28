import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/companies/model/companies_dts.dart';
import 'package:marcacion_admin/src/modules/companies/viewmodel/companies_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CompaniesView extends StatelessWidget {
  const CompaniesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CompaniesProvider()),
        ],
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: const [
            BreadCrumbsWidget(
              title: 'Empresas',
            ),
            _BodyCompaniesWidget(),
          ],
        ),
      ),
    );
  }
}

class _BodyCompaniesWidget extends StatelessWidget {
  const _BodyCompaniesWidget();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text(
            "Agregar nueva empresa",
            style: TextStyle(
              color: getTheme(context).primary,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Completa los campos para agregar una nueva empresa. Al terminar da clic en el botón “Guardar”.",
            style: TextStyle(
              color: getTheme(context).primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 50),
          const _EmployeesFormWidget(),
          const ListEmployeesWidget()
        ],
      ),
    );
  }
}

class _EmployeesFormWidget extends StatefulWidget {
  const _EmployeesFormWidget();

  @override
  State<_EmployeesFormWidget> createState() => _EmployeesFormWidgetState();
}

class _EmployeesFormWidgetState extends State<_EmployeesFormWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompaniesProvider>(context);
    Size size = MediaQuery.sizeOf(context);
    return Form(
      key: provider.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            children: [
              Container(
                width: size.width * 0.38,
                constraints: const BoxConstraints(minWidth: 600),
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormFieldCustomWidget(
                  isDark: true,
                  label: "Nombre de la empresa",
                  hinText: 'Escribe el nombre de la empresa',
                  controller: provider.companyName,
                  validations: const [
                    minLength5,
                  ],
                  onChange: (valor) {
                    provider.validInput();
                  },
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: size.width * 0.20,
                margin: const EdgeInsets.only(bottom: 10),
                constraints: const BoxConstraints(minWidth: 350),
                child: TextFormFieldCustomWidget(
                  isDark: true,
                  label: "Dirección de la empresa",
                  hinText: 'Escribe el la dirección de la empresa',
                  controller: provider.companyAddress,
                  validations: const [
                    minLength5,
                  ],
                  onChange: (valor) {
                    provider.validInput();
                  },
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: size.width * 0.20,
                margin: const EdgeInsets.only(bottom: 10),
                constraints: const BoxConstraints(minWidth: 350),
                child: TextFormFieldCustomWidget(
                  isDark: true,
                  label: "Persona de contacto",
                  hinText: 'Escribe el nombre de la persona a contactar ',
                  validations: const [
                    minLength5,
                  ],
                  controller: provider.companyContact,
                  onChange: (valor) {
                    provider.validInput();
                  },
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: size.width * 0.38,
                margin: const EdgeInsets.only(bottom: 10),
                constraints: const BoxConstraints(minWidth: 600),
                child: TextFormFieldCustomWidget(
                  isDark: true,
                  label: "Correo electrónico",
                  hinText:
                      'Escribe el correo de la persona de la empresa a contactar',
                  controller: provider.companyEmail,
                  validations: const [
                    validationIsEmail,
                  ],
                  onChange: (valor) {
                    provider.validInput();
                  },
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: size.width * 0.20,
                margin: const EdgeInsets.only(bottom: 10),
                constraints: const BoxConstraints(minWidth: 350),
                child: TextFormFieldCustomWidget(
                  isDark: true,
                  label: "Teléfono de contacto",
                  hinText: '+503 #### ####',
                  validations: const [
                    minLength10,
                  ],
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '+################',
                      filter: {"#": RegExp(r'[0-9]')},
                      type: MaskAutoCompletionType.lazy,
                    ),
                  ],
                  controller: provider.companyPhone,
                  onChange: (valor) {
                    provider.validInput();
                  },
                ),
              ),
              const SizedBox(width: 20),
              BtnWidget(
                width: size.width * 0.10,
                title: 'Guardar',
                disable: !(provider.isReady),
                loading: provider.loading,
                onPress: () async {
                  if (provider.formKey.currentState?.validate() ?? false) {
                    await provider.postCompanies();
                    provider.formKey.currentState?.reset();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ListEmployeesWidget extends StatefulWidget {
  const ListEmployeesWidget({
    super.key,
  });

  @override
  State<ListEmployeesWidget> createState() => _ListEmployeesWidgetState();
}

class _ListEmployeesWidgetState extends State<ListEmployeesWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<CompaniesProvider>(context, listen: false).getCompanies();
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompaniesProvider>(context);
    var style = TextStyle(
      fontWeight: FontWeight.w600,
      color: getTheme(context).primary,
    );
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: PaginatedDataTable(
          headingRowColor: MaterialStateColor.resolveWith(
              (states) => const Color(0XFFF3F3F4)),
          columns: [
            DataColumn(label: Text('Nombre de la empresa', style: style)),
            DataColumn(label: Text('Dirección de la empresa', style: style)),
            DataColumn(label: Text('Persona de contacto', style: style)),
            DataColumn(label: Text('Correo electrónico', style: style)),
            DataColumn(label: Text('Teléfono de contacto', style: style)),
            DataColumn(label: Text('Acciones', style: style)),
          ],
          // header: const SizedBox(),
          // arrowHeadColor: const Color(0XFFF3F3F4),
          source: CompaniesTDS(provider.companies, context),
          onRowsPerPageChanged: (value) {
            setState(() {
              _rowsPerPage = value ?? 10;
            });
          },
          horizontalMargin: 10,
          rowsPerPage: _rowsPerPage,
        ),
      ),
    );
  }
}
