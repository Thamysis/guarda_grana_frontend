import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/despesa_model.dart';
import '../models/receita_model.dart';
import '../models/usuario_model.dart'; // importe o novo model

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // EXISTENTE: Buscar todas as despesas (caso precise em outra tela)
  Future<List<DespesaModel>> getDespesas() async {
    final response = await http.get(Uri.parse('$baseUrl/despesas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => DespesaModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar despesas');
    }
  }

  // EXISTENTE: Criar despesa
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

  Future<void> editarDespesa(DespesaModel despesa) async {
    final response = await http.put(
      Uri.parse('$baseUrl/despesas/${despesa.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(despesa.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao editar despesa');
    }
  }

  Future<void> deletarDespesa(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/despesas/$id'));
  
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar despesa');
    }
  }


  // Buscar todas as receitas (caso precise em outra tela)
  Future<List<ReceitaModel>> getReceitas() async {
    final response = await http.get(Uri.parse('$baseUrl/receitas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => ReceitaModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar receitas');
    }
  }


  // Criar receita
  Future<void> criarReceita(ReceitaModel receita) async {
    final response = await http.post(
      Uri.parse('$baseUrl/receitas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(receita.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erro ao criar receita');
    }
  }

  // Editar receita
  Future<void> editarReceita(ReceitaModel receita) async {
    final response = await http.put(
      Uri.parse('$baseUrl/receitas/${receita.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(receita.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao editar receita');
    }
  }

  // Deletar receita
  Future<void> deletarReceita(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/receitas/$id'));
  
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar receita');
    }
  }


  // NOVO: Buscar usuário por ID (com despesas, receitas, contas, etc)
  Future<UsuarioModel> fetchUsuario(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/usuarios/$id'));

    print('Body (utf8): ${utf8.decode(response.bodyBytes)}');
    
    if (response.statusCode == 200) {
      return UsuarioModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes))
);
    } else {
      throw Exception('Erro ao buscar usuário');
    }
  }
}
