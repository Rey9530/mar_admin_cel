import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/const/const.dart';

class LineChartAsisten extends StatefulWidget {
  const LineChartAsisten({super.key});

  @override
  State<LineChartAsisten> createState() => _LineChartAsistenState();
}

class _LineChartAsistenState extends State<LineChartAsisten> {
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 20),
            const Text(
              "Asistencias",
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "90% ",
                  style: TextStyle(
                    color: colortext,
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Text(
                    " +5.2% ",
                    style: TextStyle(
                      color: success,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "asistencia",
                  style: TextStyle(
                    color: colortext,
                    fontWeight: FontWeight.w300,
                    fontSize: 26,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  " vs el mes anterior",
                  style: TextStyle(
                    color: colortext,
                    fontWeight: FontWeight.w600, 
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
          ],
        ),
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(mainData()),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 16,
      color: primary,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'Ene';
        break;
      case 2:
        text = 'Feb';
        break;
      case 3:
        text = 'Mar';
        break;
      case 4:
        text = 'Abr';
        break;
      case 5:
        text = 'May';
        break;
      case 6:
        text = 'Jun';
        break;
      case 7:
        text = 'Jul';
        break;
      case 8:
        text = 'Ago';
        break;
      case 9:
        text = 'Sep';
        break;
      case 10:
        text = 'Oct';
        break;
      case 11:
        text = 'Nov';
        break;
      case 12:
        text = 'Dic';
        break;
      default:
        text = '';
        break;
    }
    var widgetC = Text(text, style: style);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: widgetC,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 15,
      color: primary,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10';
        break;
      case 2:
        text = '20';
        break;
      case 3:
        text = '30';
        break;
      case 4:
        text = '40';
        break;
      case 5:
        text = '50';
        break;
      case 6:
        text = '60';
        break;
      case 7:
        text = '70';
        break;
      case 8:
        text = '80';
        break;
      case 9:
        text = '90';
        break;
      case 10:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.black, //AppColors.mainGridLineColor,
            strokeWidth: 0.5,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.black,
            strokeWidth: 0.5,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0XFF37434D)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2, 2),
            FlSpot(3, 8),
            FlSpot(4, 7),
            FlSpot(5, 6),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isStepLineChart: false,
          isCurved: false,
          barWidth: 0,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                success.withOpacity(0.9),
                const Color(0XFFD9D9D9).withOpacity(0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
