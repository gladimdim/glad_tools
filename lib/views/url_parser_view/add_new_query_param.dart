import 'package:flutter/material.dart';

class AddNewQueryParamView extends StatelessWidget {
  final Function(MapEntry<String, String> entry) onAdd;

  AddNewQueryParamView({Key? key, required this.onAdd}) : super(key: key);
  final TextEditingController _tName = TextEditingController();
  final TextEditingController _tValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                    label: Text("Name"),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    )),
                controller: _tName,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                    label: Text("Value"),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    )),
                controller: _tValue,
              ),
            ),
          ),
          IconButton(
              onPressed: () => onAdd(MapEntry(_tName.text, _tValue.text)),
              icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
