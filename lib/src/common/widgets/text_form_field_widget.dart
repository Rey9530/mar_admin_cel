import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marcacion_admin/src/common/const/styles.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';

class TextFormFieldCustomWidget extends StatefulWidget {
  const TextFormFieldCustomWidget({
    super.key,
    required this.label,
    required this.controller,
    this.hinText,
    this.isPassword = false,
    this.keyboardType = TextInputType.none,
    this.cursorColor,
    this.onChange,
    this.onFieldSubmitted,
    this.isDark = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.suffixIcon,
    this.contentPadding,
    this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.start,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.inputFormatters,
    this.validations,
  });
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double? fontSize;
  final EdgeInsetsGeometry? contentPadding;
  final bool isDark;
  final bool autoFocus;
  final bool readOnly;
  final Function? onChange;
  final Function(String)? onFieldSubmitted;
  final String label;
  final String? hinText;
  final TextInputType keyboardType;
  final bool isPassword;
  final Color? cursorColor;
  final TextEditingController controller;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final List<Function(String)>? validations;
  @override
  State<TextFormFieldCustomWidget> createState() =>
      _TextFormFieldCustomWidgetState();
}

class _TextFormFieldCustomWidgetState extends State<TextFormFieldCustomWidget> {
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  bool showText = true;
  bool isError = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: TextFormField(
        textAlign: widget.textAlign,
        readOnly: widget.readOnly,
        autofocus: widget.autoFocus,
        inputFormatters: widget.inputFormatters,
        onFieldSubmitted: widget.onFieldSubmitted,
        cursorColor: widget.isDark ? getTheme(context).primary : Colors.white,
        controller: widget.controller,
        obscureText: (widget.isPassword && showText),
        focusNode: _focus,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String? valor) {
          if (valor == null || valor.isEmpty) {
            return "Este campo es requerido ";
          }
          if (widget.validations != null && widget.validations!.isNotEmpty) {
            for (var i = 0; i < widget.validations!.length; i++) {
              var function = widget.validations![i];
              var respValid = function(valor);
              if (respValid != null) {
                return respValid;
              }
            }
          }
          return null;
        },
        onChanged: (valor) {
          setState(() {
            isError = (valor.isEmpty);
          });
          if (widget.onChange != null) {
            widget.onChange!(valor);
          }
        },
        style: TextStyle(
          color: widget.isDark ? getTheme(context).primary : Colors.white,
          fontWeight: widget.fontWeight,
          fontSize: widget.fontSize,
        ),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: widget.contentPadding,
          floatingLabelBehavior: widget.floatingLabelBehavior,
          suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      showText = !showText;
                    });
                  },
                  child: showText
                      ? Icon(
                          Icons.visibility_off,
                          color: (_focus.hasFocus ||
                                  widget.controller.text.isNotEmpty)
                              ? widget.isDark
                                  ? getTheme(context).primary
                                  : Colors.white
                              : (widget.isDark
                                      ? getTheme(context).primary
                                      : Colors.white)
                                  .withOpacity(0.6),
                        )
                      : Icon(
                          Icons.visibility,
                          color: (_focus.hasFocus ||
                                  widget.controller.text.isNotEmpty)
                              ? widget.isDark
                                  ? getTheme(context).primary
                                  : Colors.white
                              : (widget.isDark
                                      ? getTheme(context).primary
                                      : Colors.white)
                                  .withOpacity(0.6),
                        ),
                )
              : widget.suffixIcon,
          labelText: widget.label,
          hintText: widget.hinText,
          hintStyle: const TextStyle(color: hinTextPassword),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.isDark ? getTheme(context).primary : Colors.white,
              width: 4,
            ),
          ),
          errorStyle: const TextStyle(height: 0.4),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: error,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.isDark ? getTheme(context).primary : Colors.white,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.isDark ? getTheme(context).primary : Colors.white,
              width: 2,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: error,
              width: 2,
            ),
          ),
          labelStyle: TextStyle(
            color: (_focus.hasFocus || widget.controller.text.isNotEmpty)
                ? widget.isDark
                    ? getTheme(context).primary
                    : Colors.white
                : (widget.isDark ? getTheme(context).primary : Colors.white),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
