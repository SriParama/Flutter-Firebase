import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  String selectItem;
  String hintText;
  List items;
  var onChanged;
  CustomDropdown(
      {super.key,
      required this.selectItem,
      required this.hintText,
      required this.onChanged,
      required this.items});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownButtonFormField<String>(
        hint: Text(widget.hintText),

        // isDense: true,
        // isDense: true,
        // alignment: Alignment.centerLeft,
        borderRadius: BorderRadius.circular(5.0),

        // underline: SizedBox(),
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 219, 25, 41), width: 2),
            ),
            errorStyle: TextStyle(height: 0),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: 'Gender',
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            // isDense: true,
            hintStyle: TextStyle(color: Colors.grey[500])),
        autovalidateMode: AutovalidateMode.onUserInteraction,

        validator: (value) {
          if (value == null) {
            return '';
          }
          return null;
        },

        isExpanded: true,

        // style: TextStyle(textBaseline: TextBaseline.alphabetic),
        value: widget.selectItem.isEmpty ? null : widget.selectItem,
        onChanged: widget.onChanged,
        items: <String>[...widget.items]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            alignment: Alignment.center,
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
