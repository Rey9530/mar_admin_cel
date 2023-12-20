import 'package:fluro/fluro.dart';
import 'package:marcacion_admin/src/routes/auth_handlers.dart';
import 'package:marcacion_admin/src/routes/companies_handlers.dart';
import 'package:marcacion_admin/src/routes/contract_handlers.dart';
import 'package:marcacion_admin/src/routes/dashboard_handlers.dart';
import 'package:marcacion_admin/src/routes/employes_handlers.dart';
import 'package:marcacion_admin/src/routes/reports_handlers.dart';
import 'package:marcacion_admin/src/routes/user_handlers.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static String rootRoute = '/';

  // Auth Router
  static String loginRoute = '/auth/login';
  static String dashboardRoute = '/dashboard';
  static String employesRoute = '/employes';
  static String employeAddRoute = '/employes/create';
  static String employeEditRoute = '/employes/update/:uuid';
  static String companiesRoute = '/companies';
  static String userProfileRoute = '/profile';
  static String reportsRoute = '/reports';
  static String contractsRoute = '/contracts';
  static String contractsCreateRoute = '/contracts/create';
  static String contractsEditRoute = '/contracts/update/:uuid';
  static String contractsSchedulesRoute = '/contracts/schedules/:uuid';
  static String contractsEmployesRoute = '/contracts/employes/:uuid';
  static String contractsMarkingsRoute = '/contracts/markings/:uuid';

  static void configureRoutes() {
    TransitionType transitionType = TransitionType.none;
    // Auth Routes
    router.define(
      rootRoute,
      handler: AuthHandlers.login,
      transitionType: transitionType,
    );
    router.define(
      loginRoute,
      handler: AuthHandlers.login,
      transitionType: transitionType,
    );

    // Dashboard
    router.define(
      dashboardRoute,
      handler: DashboardHandlers.dashboard,
      transitionType: transitionType,
    );

    // Ver employes
    router.define(
      employesRoute,
      handler: EmployesHandlers.list,
      transitionType: transitionType,
    );

    // agregar empleados
    router.define(
      employeAddRoute,
      handler: EmployesHandlers.addEmploye,
      transitionType: transitionType,
    );

    // editar empleados
    router.define(
      employeEditRoute,
      handler: EmployesHandlers.editEmploye,
      transitionType: transitionType,
    );
    // empresas
    router.define(
      companiesRoute,
      handler: CompaniesHandlers.list,
      transitionType: transitionType,
    );

    // Perfil
    router.define(
      userProfileRoute,
      handler: UserHandlers.view,
      transitionType: transitionType,
    );

    // reportes
    router.define(
      reportsRoute,
      handler: ReportsHandlers.view,
      transitionType: transitionType,
    );

    // Contratos/ proyectos
    router.define(
      contractsRoute,
      handler: ContractHandlers.view,
      transitionType: transitionType,
    );
    router.define(
      contractsCreateRoute,
      handler: ContractHandlers.form,
      transitionType: transitionType,
    );
    router.define(
      contractsEditRoute,
      handler: ContractHandlers.form,
      transitionType: transitionType,
    );

    router.define(
      contractsSchedulesRoute,
      handler: ContractHandlers.schedules,
      transitionType: transitionType,
    );

    router.define(
      contractsEmployesRoute,
      handler: ContractHandlers.employes,
      transitionType: transitionType,
    );

    router.define(
      contractsMarkingsRoute,
      handler: ContractHandlers.markings,
      transitionType: transitionType,
    );

    // 404
    // router.notFoundHandler = NoPageFoundHandlers.noPageFound;
    router.notFoundHandler = AuthHandlers.login;
  }
}
