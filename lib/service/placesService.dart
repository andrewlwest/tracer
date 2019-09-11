import 'package:Tracer/model/place.dart';
import 'package:Tracer/service/tracer_service.dart';

class PlacesModel {
  static List<Place> places;

  static Future loadPlaces() async {
    try {
      TracerService svc = new TracerService();
      places = await svc.getPlaces();
      print('here');
    } catch (e) {
      print(e);
    }
  }
}