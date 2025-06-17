import 'despesa_model.dart';
import 'receita_model.dart';

class UsuarioModel {
  final int id;
  final String nome;
  final String email;
  final double saldoInicial;
  final double? saldoAtual;
  final List<DespesaModel> despesas;
  final List<ReceitaModel> receitas;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.saldoInicial,
    this.saldoAtual,
    required this.despesas,
    required this.receitas,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      saldoInicial: (json['saldoInicial'] as num).toDouble(),
      saldoAtual: json['saldoAtual'] != null ? (json['saldoAtual'] as num).toDouble() : null,
      despesas: (json['despesas'] as List<dynamic>)
          .map((e) => DespesaModel.fromJson(e))
          .toList(),
      receitas: (json['receitas'] as List<dynamic>)
          .map((e) => ReceitaModel.fromJson(e))
          .toList(),
    );
  }
}
