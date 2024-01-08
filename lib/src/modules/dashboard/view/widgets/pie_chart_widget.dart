import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/const/const.dart';

class PieChartGenderWidget extends StatefulWidget {
  const PieChartGenderWidget({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 20, left: 10),
          child: const Text(
            "Género",
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: Expanded(
                    child: PieChart(
                      PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 60,
                        sections: showingSections(),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 70,
                  child: const Column(
                    children: [
                      Text(
                        "250",
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0XFF313945),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Empleados",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0XFF313945),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const ItemGender(
          color: success,
          title: 'Mujeres',
        ),
        const SizedBox(height: 5),
        const ItemGender(
          color: primary,
          title: 'Hombres',
        ),
        const SizedBox(height: 70),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: success,
            value: 50,
            title: '125',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: primary,
            value: 50,
            title: '125',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class ItemGender extends StatelessWidget {
  const ItemGender({
    super.key,
    required this.color,
    required this.title,
  });
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 25,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}
