import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/hospital_model.dart';

class HospitalService {
  static const _baseUrl = "https://nominatim.openstreetmap.org/search";

  static Future<List<Hospital>> searchHospitals(String query) async {
    final url = Uri.parse("$_baseUrl?format=json&q=$query hospital Rajkot&limit=5");
    final response = await http.get(url, headers: {'User-Agent': 'com.waitmed.app'});

    if (response.statusCode != 200) return [];

    final List data = json.decode(response.body);
    return data.map((item) {
      return Hospital(
        name: item['display_name'] ?? 'Unknown Hospital',
        lat: double.parse(item['lat']),
        lng: double.parse(item['lon']),
        website: '',
        address: item['display_name'] ?? '',
        hours: '',
      );
    }).toList();
  }
}
