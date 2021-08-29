import 'package:flutter/material.dart';
import 'package:glad_tools/components/ui/bordered_all.dart';

class QueryListView extends StatelessWidget {
  final Map<String, String> queryParameters;
  final Function(Map<String, String>) onQueryUpdate;

  QueryListView(
      {Key? key, required this.queryParameters, required this.onQueryUpdate})
      : super(key: key);

  final List<TextEditingController> _controllers = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var query in queryParameters.entries) {
      final c = TextEditingController();
      c.text = query.value;
      _controllers.add(c);
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
                label: Text(query.key),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(),
                )),
            controller: c,
            onSubmitted: (String? value) {
              updateQuery(value, query);
            },
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: widgets,
      ),
    );
  }

  void updateQuery(String? value, MapEntry<String, String> query) {
    Map<String, String> map = Map.from(queryParameters);

    if (value == null) {
      map.removeWhere((key, value) => key == query.key);
      onQueryUpdate(map);
    } else {
      map.update(query.key, (v) => value);
    }
    onQueryUpdate(map);
  }
}
