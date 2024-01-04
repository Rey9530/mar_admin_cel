// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/services/services.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';
import 'package:marcacion_admin/src/modules/contract/model/index.dart';
import 'package:marcacion_admin/src/modules/employees/model/hours_ctr_mode.dart';
import 'package:marcacion_admin/src/routes/router.dart';

class ContractsProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  String? uuid;

  var contractName = TextEditingController();
  var contractsNumber = TextEditingController();
  var startDate = TextEditingController();
  var endDate = TextEditingController();
  var company = TextEditingController();
  var extraHours = TextEditingController(text: "0");
  bool isExtendable = false;
  var startDateExtendable = TextEditingController();
  var endDateExtendable = TextEditingController();

  bool isReady = false;
  bool loading = false;
  int total = 0;

  ContractsProvider() {
    var date = DateTime.now();
    var monthStart = date.month > 9 ? date.month : "0${date.month}";
    var dayStart = date.day > 9 ? date.day : "0${date.day}";
    startDateFilter.text = "$dayStart/$monthStart/${date.year}";

    var monthEnd = date.month > 9 ? date.month : "0${date.month}";
    var dayEnd = date.day > 9 ? date.day : "0${date.day}";
    endDateFilter.text = "$dayEnd/$monthEnd/${date.year}";
  }

  changeIsExtendable(valor) {
    isExtendable = valor;
    notifyListeners();
  }

  notifyListens() {
    notifyListeners();
  }

  updatePassword() async {
    var data = {
      "curren_password": "password.text",
    };

    try {
      loading = true;
      notifyListeners();
      final resp = await DioConnection.post_('/users/update/password', data);

      notifyListeners();
      if (resp['status'] != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  List<Contract> contracts = [];
  Future<bool> getContracts([load = false]) async {
    try {
      if (load) {
        loading = true;
        notifyListeners();
      }
      final resp = await DioConnection.get_('/contracts');
      final response = ContractsResponse.fromJson(resp);
      contracts = response.data;
      return true;
    } catch (e) {
      return false;
    } finally {
      if (load) {
        loading = false;
      }
      notifyListeners();
    }
  }

  List<EmpSchedule> emplContract = [];
  Future<bool> getEmpContracts([load = false]) async {
    try {
      if (load) {
        loading = true;
        notifyListeners();
      }
      final resp = await DioConnection.get_(
        '/contracts/list/employes/${contract!.ctrCodigo}',
      );
      final response = EmployeesScheduleResponse.fromJson(resp);
      emplContract = response.data;
      return true;
    } catch (e) {
      return false;
    } finally {
      if (load) {
        loading = false;
      }
      notifyListeners();
    }
  }

  List<MakingItem> emplmakingsCtr = [];
  Future<bool> getMakingsContracts([load = false]) async {
    try {
      if (load) {
        loading = true;
        notifyListeners();
      }
      final resp = await DioConnection.get_(
        '/markings/list/contract/${contract!.ctrCodigo}',
        {
          "date_start": startDateFilter.text,
          "date_end": endDateFilter.text,
        },
      );
      final response = MakingCtrResponse.fromJson(resp);
      emplmakingsCtr = response.data;
      return true;
    } catch (e) {
      return false;
    } finally {
      if (load) {
        loading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> generateExcelMakingsContracts() async {
    try {
      loading = true;
      notifyListeners();
      // var dir = await getApplicationDocumentsDirectory();
      // await dio.download("http://tu-api.com/excel/download", savePath);
      var data = await DioConnection.getExcel(
        '/markings/excel/contract/${companyFilter.text}',
        {
          "date_start": startDateFilter.text,
          "date_end": endDateFilter.text,
        },
      );

      final blob = html.Blob(
        [data],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
      final url = html.Url.createObjectUrlFromBlob(blob);
      var dateTime = DateTime.now().millisecondsSinceEpoch;
      html.AnchorElement(href: url)
        ..setAttribute('download', 'asistencia_$dateTime.xlsx')
        ..click();

      // Limpiar
      html.Url.revokeObjectUrl(url);

      return true;
    } catch (e) {
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  loadData(uui) async {
    uuid = uui;
    await getCompanies();
    if (uuid != null) await getRegister();
    if (uuid == null) await cleanForm();
  }

  addItem(codeEmp) async {
    try {
      await DioConnection.post_(
        '/contracts/employe/${contract!.ctrCodigo}/$codeEmp',
        {},
      );
      await getEmpContracts();
    } catch (e) {
      return;
    } finally {
      employees = [];
      query = '';
      notifyListeners();
    }
  }

  Future<bool> deleteEmployee(String id) async {
    try {
      await DioConnection.delete_('/contracts/employe/$id');
      NotificationsService.showSnackbarSuccess("Empleado Eliminado");
      await getEmpContracts();
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  loadToSchedules(uui) async {
    uuid = uui;
    if (uuid == null) NavigationService.replaceTo(Flurorouter.contractsRoute);
    await getRegister();
    if (contract == null) {
      NavigationService.replaceTo(Flurorouter.contractsRoute);
    }
    await getDays();
    await getSchedules();
  }

  loadToEmployees(uui) async {
    uuid = uui;
    if (uuid == null) NavigationService.replaceTo(Flurorouter.contractsRoute);
    await getRegister();
    await getEmpContracts();
    await getHoursContracts(uuid ?? '');
    employees = [];
    if (contract == null) {
      NavigationService.replaceTo(Flurorouter.contractsRoute);
    }
  }

  var startDateFilter = TextEditingController();
  var endDateFilter = TextEditingController();
  var companyFilter = TextEditingController();
  loadMakings(uui) async {
    uuid = uui;
    if (uuid == null) NavigationService.replaceTo(Flurorouter.contractsRoute);
    await getRegister();
    await getMakingsContracts();
    employees = [];
    if (contract == null) {
      NavigationService.replaceTo(Flurorouter.contractsRoute);
    }
  }

  List<HoursCtr> hoursCtr = [];
  bool loadingHours = false;
  Future getHoursContracts(String idCtr) async {
    try {
      if (idCtr.length < 10) return;
      if (loading) return;
      loadingHours = true;
      notifyListeners();
      var resp =
          await DioConnection.get_('/employes/get/contracts/hours/$idCtr');
      var code = HoursCtrResponse.fromJson(resp);
      hoursCtr = code.data;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      loadingHours = false;
      notifyListeners();
    }
  }

  String query = '';

  List<EmployeesContract> employees = [];
  Future<bool> getEmployees([load = false]) async {
    if (query.length < 3) {
      employees = [];
      notifyListeners();
      return false;
    }
    try {
      if (load) {
        loading = true;
        notifyListeners();
      }
      final resp = await DioConnection.get_(
        '/contracts/get/employes/${contract!.ctrCodigo}',
        {
          "page": 1,
          "quantity": 10,
          "query": query,
          "company": company.text,
        },
      );
      final response = EmployeesContractResponse.fromJson(resp);
      employees = response.data;
      return true;
    } catch (e) {
      return false;
    } finally {
      if (load) {
        loading = false;
      }
      notifyListeners();
    }
  }

  List<Day> days = [];
  List<Schedule> schedule = [];
  Future<bool> getDays() async {
    try {
      final resp = await DioConnection.get_('/contracts/get/days');
      final response = DaysResponse.fromJson(resp);
      days = response.data;
      schedule = [];
      for (var day in days) {
        schedule.add(Schedule(
          day: day,
          entrada1: TextEditingController(),
          salida1: TextEditingController(),
          entrada2: TextEditingController(),
          salida2: TextEditingController(),
        ));
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cleanForm() async {
    try {
      contractName.text = '';
      contractsNumber.text = '';
      startDate.text = '';
      endDate.text = '';
      company.text = '';
      extraHours.text = '0';
      isExtendable = false;
      startDateExtendable.text = '';
      endDateExtendable.text = '';
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Contract? contract;
  Future<bool> getRegister() async {
    try {
      final resp = await DioConnection.get_('/contracts/$uuid');
      final response = Contract.fromJson(resp['data']);
      contract = response;
      contractName.text = response.ctrName;
      contractsNumber.text = response.ctrNumContrato;
      startDate.text = response.ctrDateStart;
      endDate.text = response.ctrDateEnd;
      company.text = response.marEprCompanies.eprCodigo;
      extraHours.text = response.ctrHorasExtras.toString();
      isExtendable = response.ctrDateEndPro.isNotEmpty &&
          response.ctrDateEndPro.isNotEmpty;
      startDateExtendable.text = response.ctrDateEndPro;
      endDateExtendable.text = response.ctrDateEndPro;
      return true;
    } catch (e) {
      return false;
    }
  }

  List<ContractCompanies> companies = [];
  Future<bool> getCompanies() async {
    try {
      final resp = await DioConnection.get_('/contracts/get/companies');
      final response = CompaniesResponse.fromJson(resp);
      companies = response.data;
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  List<ListHoursCtr> schedules = [];
  Future<bool> getSchedules() async {
    try {
      final resp = await DioConnection.get_('/contracts/list/schedule/$uuid');
      final response = ListHoursCtrResponse.fromJson(resp);
      schedules = response.data;
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future saveContract() async {
    try {
      if (loading) return;
      loading = true;
      notifyListeners();

      var horasExtras = int.tryParse(extraHours.text) ?? 0;
      var data = {
        "ctr_nombre": contractName.text,
        "ctr_numero_contrato": contractsNumber.text,
        "horas_extras": horasExtras,
        "ctr_fecha_inicio": startDate.text,
        "ctr_fecha_fin": endDate.text,
        "ctr_fecha_inicio_pro": isExtendable ? startDateExtendable.text : null,
        "ctr_fecha_fin_pro": isExtendable ? endDateExtendable.text : null,
        "marca_ctr_empre": company.text,
      };
      if (uuid != null) {
        await DioConnection.put_('/contracts/$uuid', data);
        NavigationService.navigateTo("/contracts/schedules/$uuid");
      } else {
        var res = await DioConnection.post_('/contracts', data);
        NavigationService.navigateTo(
          "/contracts/schedules/${res["data"]["ctr_codigo"]}",
        );
      }
      await getContracts();
      return true;
    } catch (e) {
      return false;
    } finally {
      loading = false;
    }
  }

  Future updateScheduleContract(ListHoursCtr dataSend) async {
    try {
      if (loading) return;
      loading = true;
      notifyListeners();
      await DioConnection.put_(
        '/contracts/schedule/${dataSend.horCodigo}',
        dataSend.toJson(),
      );
      return true;
    } catch (e) {
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future saveScheduleContract() async {
    try {
      if (loading) return;
      loading = true;
      notifyListeners();
      var data = RequestSchedule(list: schedule).toJson();
      var resp = await DioConnection.post_(
        '/contracts/schedule/${contract?.ctrCodigo}',
        data,
      );
      if (resp['status'] == 201) {
        NavigationService.navigateTo(
          "/contracts/employes/${contract?.ctrCodigo}",
        );
      }
      return true;
    } catch (e) {
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  updateScheduleEmpCtr(asiCode, codHor) async {
    try {
      await DioConnection.put_(
        '/contracts/schedule/$asiCode/$codHor',
        {},
      );
    } catch (e) {
      return;
    }
  }

  Future<bool> deleteContracts(String id) async {
    try {
      await DioConnection.delete_('/contracts/$id');
      NotificationsService.showSnackbarSuccess("Contrato Eliminado");
      await getContracts();
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> deleteSchedule(String id) async {
    try {
      await DioConnection.delete_('/contracts/schedule/$id');
      NotificationsService.showSnackbarSuccess("Horario Eliminado");
      await getSchedules();
      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }
}
