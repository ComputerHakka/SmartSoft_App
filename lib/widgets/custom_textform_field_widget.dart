import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required this.title,
      this.initialValue,
      this.onChanged,
      this.readOnly = false})
      : super(key: key);

  final String title;
  final String? initialValue;
  final Function(String)? onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              onChanged: onChanged,
              readOnly: readOnly,
              decoration: InputDecoration(
                isDense: true,
                labelText: title,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
