import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/services/services.dart';
import 'package:marcacion_admin/src/modules/auth/viewmodel/provider_auth.dart';
import 'package:marcacion_admin/src/modules/contract/viewmodel/contracts_provider.dart';
import 'package:marcacion_admin/src/modules/dashboard/viewmodel/dashboard_provider.dart';
import 'package:marcacion_admin/src/modules/employees/viewmodel/employes_provider.dart';
import 'package:marcacion_admin/src/modules/user/viewmodel/user_provider.dart';
import 'package:provider/provider.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ContractsProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => SideMenuProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => EmployeesProvider()),
      ],
      child: child,
    );
  }
}
