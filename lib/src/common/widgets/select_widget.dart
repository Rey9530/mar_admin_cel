import 'package:flutter/material.dart';
import 'package:marcacion_admin/src/common/const/const.dart';
import 'package:marcacion_admin/src/common/helpers/helpers.dart';
import 'package:marcacion_admin/src/common/models/dropdown_button_data_model.dart';

class SelectCompaniesWidget extends StatefulWidget {
  const SelectCompaniesWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.items,
    this.textSelected = 'Selecciona una opción',
    this.selected,
    this.onChange,
    this.isRequired = true,
    this.isDisable = false,
  });
  final List<DropdownButtonData>? items;
  final DropdownButtonData? selected;
  final String title;
  final String textSelected;
  final bool isRequired;
  final bool isDisable;
  final TextEditingController controller;
  final Function(DropdownButtonData)? onChange;

  @override
  State<SelectCompaniesWidget> createState() => SelectCompaniesWidgetState();
}

class SelectCompaniesWidgetState extends State<SelectCompaniesWidget> {
  // Initial Selected Value
  String dropdownvalue = '0';

  // List of items in our dropdown menu
  List<DropdownButtonData> items = [];
  @override
  void initState() {
    super.initState();
    if (widget.selected != null) {
      dropdownvalue = widget.selected?.id ?? '0';
      var ifExist = widget.items
          ?.where((element) => element.id == dropdownvalue)
          .toList();
      if (ifExist != null && ifExist.isEmpty) {
        dropdownvalue = '0';
      }
    }
    items = [
      ...[
        DropdownButtonData(title: widget.textSelected, id: '0'),
      ],
      if (widget.items != null && widget.items!.isNotEmpty) ...widget.items!
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: DropdownButtonFormField<String>(
        value: dropdownvalue,
        isExpanded: true,
        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),
        borderRadius: BorderRadius.circular(4),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.isRequired
            ? (value) {
                if (value != "0") return null;
                return "Este campo es requerido";
              }
            : null,
        decoration: InputDecoration(
          labelText: widget.title,
          errorStyle: const TextStyle(height: 0.4),
          labelStyle: TextStyle(
            color: widget.isDisable
                ? getTheme(context).tertiary.withOpacity(0.5)
                : getTheme(context).primary,
            fontWeight: FontWeight.w400,
          ),

          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: error,
              width: 2,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: error,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.isDisable
                  ? getTheme(context).tertiary.withOpacity(0.5)
                  : getTheme(context).tertiary.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.isDisable
                  ? getTheme(context).tertiary.withOpacity(0.5)
                  : getTheme(context).primary,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.isDisable
                  ? getTheme(context).tertiary.withOpacity(0.5)
                  : getTheme(context).primary,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: getTheme(context).tertiary.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        // Array list of items
        items: widget.isDisable
            ? null
            : items.map(
                (DropdownButtonData item) {
                  return DropdownMenuItem<String>(
                    value: item.id,
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: widget.isDisable
                            ? getTheme(context).tertiary.withOpacity(0.5)
                            : getTheme(context).primary,
                      ),
                    ),
                  );
                },
              ).toList(),
        onChanged: (String? newValue) {
          if (widget.onChange != null) {
            var itemSelected =
                items.where((element) => element.id == newValue).toList().first;
            widget.onChange!(itemSelected);
          }
          if (newValue != null) {
            setState(() {
              dropdownvalue = newValue;
              widget.controller.text = newValue;
            });
          }
        },
      ),
    );
  }
}
