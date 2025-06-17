class ReceitaModel {
  final int id;
  final String nome;
  final String descricao;
  final double valor;
  final String data;
  final String categoria;

  ReceitaModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.categoria,
  });

  factory ReceitaModel.fromJson(Map<String, dynamic> json) {
    return ReceitaModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      data: json['data'] as String,
      categoria: json['categoria'] as String,
    );
  }
}
