import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/despesa_model.dart';
import '../models/receita_model.dart';
import '../models/usuario_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // Buscar todas as despesas
  Future<List<DespesaModel>> getDespesas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/despesas'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => DespesaModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar despesas');
    }
  }

  Future<void> criarDespesa(DespesaModel despesa) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/despesas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(despesa.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar despesa');
    }
  }

  Future<void> editarDespesa(DespesaModel despesa) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final response = await http.put(
      Uri.parse('$baseUrl/despesas/${despesa.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(despesa.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao editar despesa');
    }
  }

  Future<void> deletarDespesa(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/despesas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar despesa');
    }
  }

  Future<List<ReceitaModel>> getReceitas() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/receitas'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => ReceitaModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar receitas');
    }
  }

  Future<void> criarReceita(ReceitaModel receita) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/receitas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(receita.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar receita');
    }
  }

  Future<void> editarReceita(ReceitaModel receita) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final response = await http.put(
      Uri.parse('$baseUrl/receitas/${receita.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(receita.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao editar receita');
    }
  }

  Future<void> deletarReceita(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final response = await http.delete(
      Uri.parse('$baseUrl/receitas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar receita');
    }
  }

  // Buscar usuário por ID (com despesas, receitas, contas, etc)
  Future<UsuarioModel> fetchUsuario(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) throw Exception('Usuário não logado');

    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      return UsuarioModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Erro ao buscar usuário');
    }
  }
}