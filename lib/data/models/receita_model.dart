class ReceitaModel {
  final int id;
  final String nome;
  final String descricao;
  final String categoria;
  final double valor;
  final String data;


  ReceitaModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.valor,
    required this.data,
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

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria,
      'valor': valor,
      'data': data,
    };
  }
}