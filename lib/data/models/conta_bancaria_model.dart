class ContaBancariaModel {
  final int id;
  final String nome;
  final String descricao;
  final String categoria;
  final double saldoAtual;

  ContaBancariaModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.saldoAtual,
  });

  factory ContaBancariaModel.fromJson(Map<String, dynamic> json) {
    return ContaBancariaModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      categoria: json['categoria'] as String,
      saldoAtual: (json['saldoAtual'] as num).toDouble(),
    );
  }
}
