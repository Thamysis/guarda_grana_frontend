import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/usuario_model.dart';
import '../../../data/services/api_service.dart';

class RegistroFinanceiro {
  final String nome;
  final String descricao;
  final double valor;
  final String data;
  final bool isReceita;

  RegistroFinanceiro({
    required this.nome,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.isReceita,
  });
}

class DashboardController extends ChangeNotifier {
  UsuarioModel? usuario;
  bool loading = false;
  String? error;
  List<RegistroFinanceiro> ultimosRegistros = [];

  Future<void> fetchUsuario() async {
    loading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('usuario_id');
      if (userId == null) throw Exception('ID do usuário não encontrado');

      usuario = await ApiService().fetchUsuario(userId);
      _gerarUltimosRegistros();
      error = null;
    } catch (e) {
      error = 'Erro ao buscar usuário';
    }
    loading = false;
    notifyListeners();
  }

  void _gerarUltimosRegistros() {
    if (usuario == null) return;

    final despesas = usuario!.despesas
        .map((e) => RegistroFinanceiro(
              nome: e.nome,
              descricao: e.descricao,
              valor: -e.valor,
              data: e.data,
              isReceita: false,
            ));
    final receitas = usuario!.receitas
        .map((e) => RegistroFinanceiro(
              nome: e.nome,
              descricao: e.descricao,
              valor: e.valor,
              data: e.data,
              isReceita: true,
            ));

    final todos = [...despesas, ...receitas];

    todos.sort((a, b) => b.data.compareTo(a.data));

    ultimosRegistros = todos.take(10).toList();
  }
}