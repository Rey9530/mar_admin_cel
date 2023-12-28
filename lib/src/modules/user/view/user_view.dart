import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/const/const.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';
import 'package:marcacion_admin/src/common/services/services.dart';
import 'package:marcacion_admin/src/common/widgets/widgets.dart';
import 'package:marcacion_admin/src/modules/user/viewmodel/user_provider.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BreadCrumbsWidget(
            showLogout: false,
            title: 'Usuario',
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: BigUserWidget(),
          ),
          UserInfoWidget(),
        ],
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 740,
      padding: const EdgeInsets.only(top: 100),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          ItemUserInfoWidget(
            title: 'Nombres',
            subtitle: LocalStorage.prefs.getString('nombres') ?? "",
          ),
          ItemUserInfoWidget(
            title: 'Apellido',
            subtitle: LocalStorage.prefs.getString('apellidos') ?? "",
          ),
          ItemUserInfoWidget(
            title: 'Código de empleado:',
            subtitle: LocalStorage.prefs.getString('codigo') ?? "",
          ),
          const ItemUserInfoWidget(
            title: 'Contraseña',
            subtitle: "**********",
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: 300,
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 300,
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const ModalChangePasswordWidget(),
                );
              },
              child: const Text(
                "Cambiar contraseña",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: neutral,
                  decorationColor: neutral,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModalChangePasswordWidget extends StatelessWidget {
  const ModalChangePasswordWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context);
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      title: Column(
        children: [
          Image.asset("assets/icons/_changepassword.png"),
          Text(
            'Cambiar contraseña',
            style: TextStyle(
              color: getTheme(context).primary,
              fontWeight: FontWeight.w400,
              fontSize: 24,
            ),
          ),
        ],
      ),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 450,
        width: 340,
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextFormFieldCustomWidget(
              isDark: true,
              label: "Contraseña actual",
              hinText: 'Escribe la contraseña actual',
              controller: providerUser.password,
              isPassword: true,
              onChange: (valor) {
                // provider.validarInput();
              },
            ),
            const SizedBox(height: 20),
            TextFormFieldCustomWidget(
              isDark: true,
              label: "Nueva contraseña",
              hinText: 'Escribe la nueva contraseña',
              controller: providerUser.passwordNew,
              isPassword: true,
              onChange: (valor) {
                providerUser.updateTextPassword();
              },
            ),
            const SizedBox(height: 20),
            TextFormFieldCustomWidget(
              isDark: true,
              label: "Repite la nueva contraseña",
              hinText: 'Repite la nueva contraseña',
              controller: providerUser.passwordRepeat,
              isPassword: true,
              onChange: (valor) {
                providerUser.updateTextPassword();
              },
            ),
            const SizedBox(height: 40),
            const ContaintPasswordWidget()
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            BtnOutlineWidget(
              height: 40,
              width: 80,
              title: 'Cancelar',
              onPress: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            BtnWidget(
              colorDisable:hinTextPassword,
              title: "Cambiar",
              width: 200,
              disable: !providerUser.isReady,
              loading: providerUser.loading,
              onPress: () async {
                await providerUser.updatePassword();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ContaintPasswordWidget extends StatelessWidget {
  const ContaintPasswordWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final providerUser = Provider.of<UserProvider>(context);
    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tu contraseña debe cumplir con:",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: getTheme(context).primary,
              fontSize: 18,
            ),
          ),
          ContainItemWidget(
            isOk: providerUser.condictionCharacter,
            title: "Debe tener entre 8 y 12 caracteres",
          ),
          ContainItemWidget(
            isOk: providerUser.condictionCapital,
            title: "Una mayúscula",
          ),
          ContainItemWidget(
            isOk: providerUser.condictionNumber,
            title: "Un número",
          ),
          ContainItemWidget(
            isOk: providerUser.condictionCharSpecial,
            title: "Un carácter especial",
          ),
        ],
      ),
    );
  }
}

class ContainItemWidget extends StatelessWidget {
  const ContainItemWidget({
    super.key,
    required this.isOk,
    required this.title,
  });
  final bool isOk;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isOk
            ? Image.asset("assets/icons/check.png")
            : Image.asset("assets/icons/uncheck.png"),
        const SizedBox(width: 5),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: isOk ? getTheme(context).primary : hinTextPassword,
          ),
        ),
      ],
    );
  }
}

class ItemUserInfoWidget extends StatelessWidget {
  const ItemUserInfoWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: userCardBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: getTheme(context).primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: getTheme(context).primary,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
