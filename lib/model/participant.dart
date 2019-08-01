import 'package:flutter/foundation.dart';

enum Category { observer, admin, expert, }

class Participant {
  const Participant({
    @required this.category,
    @required this.id,
    @required this.name,
  })  : assert(category != null),
        assert(id != null),
        assert(name != null);

  final Category category;
  final int id;
  final String name;

  @override
  String toString() => "$name (id=$id)";
}