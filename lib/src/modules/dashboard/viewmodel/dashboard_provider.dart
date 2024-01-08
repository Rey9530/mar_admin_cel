import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';

class DashboardProvider extends ChangeNotifier {

  bool loading = false;
  Future getChartsData() async {
    try {
      if (loading) return;
      loading = true;
      // notifyListeners();
      var resp = await DioConnection.get_('/employes/get/catalogs');
      // var code = CatalogResponse.fromJson(resp); 
      return true;
    } catch (e) {
      return false;
    } finally {
      loading = false;
    }
  }
}
