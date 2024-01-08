import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/const/const.dart';
import 'package:marcacion_admin/src/modules/dashboard/viewmodel/dashboard_provider.dart';
import 'package:provider/provider.dart';

class ChartStatusWidget extends StatelessWidget {
  const ChartStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(
            top: 20,
            left: 20,
            bottom: 20,
          ),
          child: const Text(
            "Tipos de empleados",
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        const _BodyChartWidget(),
        const _PercentWidget(),
        const _ListaTipesWidget()
      ],
    );
  }
}

class _ListaTipesWidget extends StatelessWidget {
  const _ListaTipesWidget();

  @override
  Widget build(BuildContext context) {
    var provDash = Provider.of<DashboardProvider>(context);
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          ...provDash.contrationsChart.map(
            (i) => ListItemTipeWidget(
              title: i.nombre,
              cant: i.cantidad.toString(),
              color: i.nombre == 'Fijo'
                  ? primary
                  : i.nombre == 'Reemplazo'
                      ? success
                      : neutral,
              isDottet: i.nombre == 'Apoyo',
            ),
          ),
          // ListItemTipeWidget(
          //   color: primary,
          //   title: 'Fijos',
          //   cant: '182',
          // ),
          // ListItemTipeWidget(
          //   color: success,
          //   title: 'Reemplazo',
          //   cant: '18',
          //   isDottet: true,
          // ),
          // ListItemTipeWidget(
          //   color: neutral,
          //   title: 'Apoyo',
          //   cant: '50',
          // ),
        ],
      ),
    );
  }
}

class ListItemTipeWidget extends StatelessWidget {
  const ListItemTipeWidget({
    super.key,
    required this.color,
    this.isDottet = false,
    required this.title,
    required this.cant,
  });
  final Color color;
  final bool isDottet;
  final String title;
  final String cant;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isDottet ? secondary40 : whiteColor,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(color: primary),
          ),
          const Spacer(),
          Text(
            cant,
            style: const TextStyle(
              color: primary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _PercentWidget extends StatelessWidget {
  const _PercentWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "0%",
            style: TextStyle(color: colortext),
          ),
          Text(
            "100%",
            style: TextStyle(color: colortext),
          ),
        ],
      ),
    );
  }
}

class _BodyChartWidget extends StatelessWidget {
  const _BodyChartWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const ContainerDataWidget(),
      ),
    );
  }
}

class ContainerDataWidget extends StatelessWidget {
  const ContainerDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provDash = Provider.of<DashboardProvider>(context);
    double widthMax = 568.00;
    return Row(
      children: [
        // for (var i in provDash.contrationsChart)
        //   Container(
        //     width: (i.cantidad / provDash.totalContration) * widthMax,
        //     height: 49,
        //     color: primary,
        //   ),
        ...provDash.contrationsChart.map(
          (i) => Container(
            width: i.cantidad / provDash.totalContration * widthMax,
            height: 49,
            color: i.nombre == 'Fijo'
                ? primary
                : i.nombre == 'Reemplazo'
                    ? success
                    : neutral,
          ),
        ),
        // Container(
        //   width: widthMax * 0.5,
        //   height: 49,
        //   color: primary,
        // ),
        // Container(
        //   width: widthMax * 0.3,
        //   height: 49,
        //   color: success,
        // ),
        // Container(
        //   width: widthMax * 0.2,
        //   height: 49,
        //   color: neutral,
        // ),
      ],
    );
  }
}
