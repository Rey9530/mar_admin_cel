// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marcacion_admin/src/common/const/const.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';
import 'package:marcacion_admin/src/common/services/navigation_service.dart';
import 'package:marcacion_admin/src/routes/router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/contract/viewmodel/contracts_provider.dart';

class MakingsContractsView extends StatelessWidget {
  const MakingsContractsView({super.key, this.uuid});
  final String? uuid;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context, listen: false);
    return FutureBuilder(
      future: provider.loadMakings(uuid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return const MakingsBodyWidget();
      },
    );
  }
}

class MakingsBodyWidget extends StatelessWidget {
  const MakingsBodyWidget({
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
                'Contratos / ${provider.contract?.ctrName ?? ''} / Marcaciones',
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
              "Has una búsqueda de los empleados que han marcado.",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: FiltersWidget(),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: CustomTableWidget(),
          ),
        ],
      ),
    );
  }
}

class CustomTableWidget extends StatelessWidget {
  const CustomTableWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Table(
        border: TableBorder.all(color: Color(0XFFEFEFEF)),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: secondary40,
              borderRadius: BorderRadius.circular(4),
            ),
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: _titleText('Código de empleado'),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: _titleText('Empleado'),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: _titleText('Entrada'),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: _titleText('Salida'),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: _titleText('Fecha'),
              ),
            ],
          ),
          for (var item in provider.emplmakingsCtr)
            TableRow(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: _contentText(item.codigo),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.centerLeft,
                  child: _contentText('${item.nombres} ${item.apellidos}'),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: _contentText(item.entrada),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: _contentText(item.salida),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: _contentText(item.fecha),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Text _titleText(title) => Text(
        title,
        style: TextStyle(
          color: primary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );

  Text _contentText(title) => Text(
        title,
        style: TextStyle(
          color: primary,
          fontWeight: FontWeight.w300,
        ),
      );
}

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context);
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10 ),
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
            hinText: 'dd/mm/AAAA',
            controller: provider.startDateFilter,
            onChange: (String valor) async {
              // provider.validarInput();
            },
            suffixIcon: InkWell(
              onTap: () async {
                var data = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  locale: const Locale('es', 'ES'),
                );
                if (data != null) {
                  String onlydate = DateFormat("dd/MM/yyyy").format(data);
                  provider.startDateFilter.text = onlydate;
                }
              },
              child: Image.asset("assets/icons/calendar_primary.png"),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
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
            label: "Fecha fin",
            hinText: 'dd/mm/AAAA',
            controller: provider.endDateFilter,
            onChange: (String valor) async {},
            suffixIcon: InkWell(
              onTap: () async {
                var data = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now().add(Duration(days: 30)),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  locale: const Locale('es', 'ES'),
                );
                if (data != null) {
                  String onlydate = DateFormat("dd/MM/yyyy").format(data);
                  provider.endDateFilter.text = onlydate;
                }
              },
              child: Image.asset("assets/icons/calendar_primary.png"),
            ),
          ),
        ),
        BtnWidget(
          width: 200,
          height: 60,
          loading: provider.loading,
          title: "Filtrar",
          onPress: () async {
            // provider.saveEmploye();
            await provider.getMakingsContracts(true);
          },
        ), 
      ],
    );
  }
}
