import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';
import 'package:marcacion_admin/src/modules/dashboard/view/models/chart_mode.dart';

class DashboardProvider extends ChangeNotifier {
  bool loading = false;
  List<ContrationChart> gendersChart = [];
  double totalGender = 0;
  List<ContrationChart> contrationsChart = [];
  double totalContration = 0;

  Future getChartsData(id) async {
    if (id == '0' || id == 0) return;
    try {
      if (loading) return;
      totalGender = 0;
      totalContration = 0;
      loading = true;
      // notifyListeners();
      var resp = await DioConnection.get_('/charts/get/$id');
      var code = ChartResponse.fromJson(resp);
      gendersChart = code.data.genders;
      for (var element in gendersChart) {
        totalGender = totalGender + element.cantidad;
      }
      contrationsChart = code.data.contrations;
      for (var element in contrationsChart) {
        totalContration = totalContration + element.cantidad;
      }
      for (var element in contrationsChart) {
        print((element.cantidad / totalContration));
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
