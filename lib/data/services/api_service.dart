import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/despesa_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<List<DespesaModel>> getDespesas() async {
    final response = await http.get(Uri.parse('$baseUrl/despesas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DespesaModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar despesas');
    }
  }

  Future<void> criarDespesa(DespesaModel despesa) async {
    final response = await http.post(
      Uri.parse('$baseUrl/despesas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(despesa.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar despesa');
    }
  }
}
