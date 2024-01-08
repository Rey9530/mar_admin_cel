// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/services/services.dart';
import 'package:marcacion_admin/src/modules/contract/view/widgets/edit_list_hours_widget.dart';
import 'package:marcacion_admin/src/modules/contract/view/widgets/list_hours_widget.dart';
import 'package:marcacion_admin/src/routes/router.dart';
import 'package:provider/provider.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/contract/viewmodel/contracts_provider.dart';

class SchedulesContractsView extends StatelessWidget {
  const SchedulesContractsView({super.key, this.uuid});
  final String? uuid;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context, listen: false);
    return FutureBuilder(
      future: provider.loadToSchedules(uuid),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return const SchedulesBodyWidget();
      },
    );
  }
}

class SchedulesBodyWidget extends StatelessWidget {
  const SchedulesBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ContractsProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          BreadCrumbsWidget(
            title: 'Contratos / ${provider.contract?.ctrName ?? ''} / Horarios',
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
              "Define uno o más horarios. Al terminar da clic en el botón “Continuar”.",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 50),
          // Container(
          //   color: Colors.yellow,
          //   width: 975,
          //   child: Container(
          //     width: 200,
          //     alignment: Alignment.centerRight,
          //     margin: const EdgeInsets.symmetric(horizontal: 30),
          //     color: Colors.red,
          //     child: Text(
          //       "Paso 2 de 3",
          //       style: TextStyle(
          //         fontWeight: FontWeight.w700,
          //         color: getTheme(context).primary,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 50),
          for (var schedule in provider.schedules)
            EditListHoursWidgets(schedule: schedule),
          const ListHoursWidgets(),
        ],
      ),
    );
  }
}
