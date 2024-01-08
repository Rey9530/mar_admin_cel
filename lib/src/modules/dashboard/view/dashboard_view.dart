import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marcacion_admin/src/common/const/const.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';
import 'package:marcacion_admin/src/common/models/dropdown_button_data_model.dart';
import 'package:marcacion_admin/src/common/services/services.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/dashboard/view/widgets/bar_graph_widget.dart';
import 'package:marcacion_admin/src/modules/dashboard/view/widgets/chat_status_widget.dart';
import 'package:marcacion_admin/src/modules/dashboard/view/widgets/pie_chart_widget.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BreadCrumbsWidget(
              title: 'Dashboard',
            ),
            SizedBox(height: 20),
            BodyDashboardWidget(),
          ],
        ),
      ),
    );
  }
}

class BodyDashboardWidget extends StatelessWidget {
  const BodyDashboardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: secondary40,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.only(top: 20),
          child: const Wrap(
            children: [
              CardUserCustomerWidget(),
              Employees1Widget(
                title: 'Empleados a tiempo',
                icon: 'user_check.svg',
              ),
              Employees1Widget(
                title: 'Empleados con retraso',
                icon: 'user_minus.svg',
              ),
              Employees1Widget(
                title: 'Empleados horas extra',
                icon: 'alarm.svg',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Wrap(
          children: [
            CharMonthWidget(),
            CharGenderWidget(),
            CharStatusWidget(),
          ],
        )
      ],
    );
  }
}

class CharMonthWidget extends StatelessWidget {
  const CharMonthWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      height: 450,
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: ,
        border: Border.all(
          color: const Color(0XFFEFEFEF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const LineChartAsisten(),
    );
  }
}

class CharGenderWidget extends StatelessWidget {
  const CharGenderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 450,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        // color: ,
        border: Border.all(
          color: const Color(0XFFEFEFEF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const PieChartGenderWidget(),
    );
  }
}

class CharStatusWidget extends StatelessWidget {
  const CharStatusWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 610,
      height: 450,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        // color: ,
        border: Border.all(
          color: const Color(0XFFEFEFEF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const ChartStatusWidget(),
    );
  }
}

class Employees1Widget extends StatelessWidget {
  const Employees1Widget({
    super.key,
    required this.title,
    required this.icon,
  });
  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 350,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image.asset("assets/icons/$icon"),
          SvgPicture.asset("assets/svg/$icon", semanticsLabel: 'Acme Logo'),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              color: getTheme(context).primary,
            ),
          ),
          Text(
            "0",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: getTheme(context).primary,
            ),
          ),
          const Text(
            "0%",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: secondary80,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          const Text(
            "vs el mes pasado.",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: secondary60,
            ),
          ),
        ],
      ),
    );
  }
}

class CardUserCustomerWidget extends StatelessWidget {
  const CardUserCustomerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hola, ${LocalStorage.prefs.getString('nombres') ?? ""} ${LocalStorage.prefs.getString('apellidos') ?? ""}",
            style: TextStyle(
              color: getTheme(context).primary,
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
          const Wrap(
            children: [
              Text(
                "Estas son ",
                style: TextStyle(
                  color: secondary80,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "las estadísticas diarias",
                style: TextStyle(
                  color: secondary80,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "según el proyecto seleccionado",
                style: TextStyle(
                  color: secondary80,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: getTheme(context).primary,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selecciona un contrato",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  height: 55,
                  child: SelectCompaniesWidget(
                    controller: TextEditingController(),
                    title: '',
                    onChange: (val) {},
                    selected: DropdownButtonData(
                      id: "0",
                      title: "Selecciona una opción",
                    ),
                    items: [
                      DropdownButtonData(
                        id: "1",
                        title: "Empresa 1",
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
