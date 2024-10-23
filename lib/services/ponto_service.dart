import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchPontosTuristicos() async {
  final response = await http.get(Uri.parse('http://192.168.1.77:3000/api/pontos'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Falha ao carregar pontos turísticos');
  }
}
