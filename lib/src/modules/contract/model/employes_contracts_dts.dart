// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/const/const.dart';
import 'package:marcacion_admin/src/common/models/dropdown_button_data_model.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/contract/model/index.dart';
import 'package:marcacion_admin/src/modules/contract/viewmodel/contracts_provider.dart';
import 'package:provider/provider.dart';

class EmployeesContractsTDS extends DataTableSource {
  final List<EmpSchedule> contracts;
  final BuildContext context;
  final int total;

  EmployeesContractsTDS(this.contracts, this.context, this.total);

  @override
  DataRow? getRow(int index) {
    final contract = contracts[index];
    var provider = Provider.of<ContractsProvider>(context, listen: false);
    return DataRow.byIndex(
      color:
          MaterialStateColor.resolveWith((states) => const Color(0XFFFFFFFF)),
      index: index,
      cells: [
        DataCell(Text(contract.marEmpEmployees.empNombres)),
        DataCell(Text(contract.marEmpEmployees.empSurnames)),
        DataCell(Text(contract.marEmpEmployees.empCodigoEmp)),
        DataCell(Text(contract.marEmpEmployees.marConHiring.conNames)),
        DataCell(Text(contract.marEmpEmployees.marUbiLocations.ubiNames)),
        DataCell(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            width: 200,
            child: SelectCompaniesWidget(
              controller: TextEditingController(),
              title: '',
              selected: DropdownButtonData(
                id: contract.asiCodhor,
                title: "",
              ),
              onChange: (val) async {
                await provider.updateScheduleEmpCtr(contract.asiCodigo, val.id);
              },
              items: [
                ...provider.hoursCtr.map(
                  (e) => DropdownButtonData(
                    id: e.horCodigo,
                    title: e.horName,
                  ),
                ),
              ],
            ),
            // Text(contract.asiCodhor),
          ),
        ),
        DataCell(
          IconButton(
            onPressed: () {
              final dialog = AlertDialog(
                title: Column(
                  children: [
                    Image.asset("assets/icons/borrarred.png"),
                    Text(
                      'Eliminar ${contract.marEmpEmployees.empNombres} ${contract.marEmpEmployees.empSurnames}',
                      style: const TextStyle(color: error),
                    ),
                  ],
                ),
                content: const Text(
                  '¿Confirmas que deseas eliminar este contrato?',
                  style: TextStyle(color: primary),
                ),
                actions: [
                  Row(
                    children: [
                      BtnOutlineWidget(
                        title: 'Cancelar',
                        onPress: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      BtnWidget(
                        title: "Si, Eliminar",
                        width: 200,
                        onPress: () async {
                          await Provider.of<ContractsProvider>(context,
                                  listen: false)
                              .deleteEmployee(contract.asiCodigo);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              );

              showDialog(context: context, builder: (_) => dialog);
            },
            icon: Container(
              width: 50,
              height: 30,
              decoration: BoxDecoration(
                color: error,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset("assets/icons/delete.png"),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => total;

  @override
  int get selectedRowCount => 0;
}
