// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/const/const.dart';
import 'package:marcacion_admin/src/common/services/services.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/contract/model/contracts_model.dart';
import 'package:marcacion_admin/src/modules/contract/viewmodel/contracts_provider.dart';
import 'package:provider/provider.dart';

class ContractsTDS extends DataTableSource {
  final List<Contract> contracts;
  final BuildContext context;
  final int total;

  ContractsTDS(this.contracts, this.context, this.total);

  @override
  DataRow? getRow(int index) {
    final contract = contracts[index];
    return DataRow.byIndex(
      color:
          MaterialStateColor.resolveWith((states) => const Color(0XFFFFFFFF)),
      index: index,
      cells: [
        DataCell(Text(contract.ctrName)),
        DataCell(Text(contract.ctrNumContrato)),
        DataCell(Text(contract.marEprCompanies.eprName)),
        DataCell(Text(contract.ctrDateStart)),
        DataCell(Text(contract.ctrDateEnd)),
        DataCell(Text(contract.ctrDateStartPro.isEmpty ? "NO" : "SI")),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () {
                  NavigationService.navigateTo(
                      "/contracts/update/${contract.ctrCodigo}");
                },
                icon: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Image.asset("assets/icons/editarsvg.png"),
                ),
              ),
              IconButton(
                onPressed: () {
                  NavigationService.navigateTo(
                      "/contracts/employes/${contract.ctrCodigo}");
                },
                icon: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.people_outline,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  NavigationService.navigateTo(
                    "/contracts/schedules/${contract.ctrCodigo}",
                  );
                },
                icon: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  NavigationService.navigateTo(
                    "/contracts/markings/${contract.ctrCodigo}",
                  );
                },
                icon: Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  final dialog = AlertDialog(
                    title: Column(
                      children: [
                        Image.asset("assets/icons/borrarred.png"),
                        Text(
                          'Eliminar ${contract.ctrName}',
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
                                  .deleteContracts(contract.ctrCodigo);

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
            ],
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
