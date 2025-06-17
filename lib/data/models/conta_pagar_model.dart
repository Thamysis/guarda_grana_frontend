class ContaPagarModel {
  final int id;
  final String nome;
  final String descricao;
  final String categoria;
  final double valor;
  final String data;
  final bool receberNotificacao;

  ContaPagarModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.valor,
    required this.data,
    required this.receberNotificacao,
  });

  factory ContaPagarModel.fromJson(Map<String, dynamic> json) {
    return ContaPagarModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      categoria: json['categoria'] as String,
      valor: (json['valor'] as num).toDouble(),
      data: json['data'] as String,
      receberNotificacao: json['receberNotificacao'] as bool,
    );
  }
}
