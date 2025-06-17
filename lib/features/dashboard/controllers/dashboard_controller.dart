import 'package:flutter/material.dart';
import '../../../data/models/usuario_model.dart';
import '../../../data/services/api_service.dart';

// Classe para uso interno no dashboard: um registro genérico
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
      usuario = await ApiService().fetchUsuario(1); // Troque o ID se necessário
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
              valor: -e.valor, // Negativo para saída
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

    todos.sort((a, b) => b.data.compareTo(a.data)); // Mais recente primeiro

    ultimosRegistros = todos.take(10).toList();
  }
  
}
