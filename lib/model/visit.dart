import 'package:flutter/foundation.dart';

enum Category { all, today, upcoming, past, }

class Visit {
  const Visit({
    @required this.category,
    @required this.site,
    @required this.location,
    @required this.summary,
    @required this.id,
    @required this.isFeatured,
    @required this.name,
    @required this.date,
    @required this.time,
    @required this.price,
  })  : assert(category != null),
        assert(id != null),
        assert(isFeatured != null),
        assert(name != null),
        assert(price != null);

  final Category category;
  final String site;
  final String location;
  final String summary;
  final int id;
  final bool isFeatured;
  final String name;
  final String date;
  final String time;
  final int price;

  String get assetName => '$id-0.jpg';
  String get assetPackage => 'shrine_images';

  @override
  String toString() => "$name (id=$id)";
}