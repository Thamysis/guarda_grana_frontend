class DespesaModel {
  final int? id;
  final String nome;
  final String? descricao;
  final double valor;
  final String data;
  final String? categoria;

  DespesaModel({
    this.id,
    required this.nome,
    this.descricao,
    required this.valor,
    required this.data,
    this.categoria,
  });

  factory DespesaModel.fromJson(Map<String, dynamic> json) {
    return DespesaModel(
      id: json['id'],
      nome: json['nome'] ?? 'Sem nome',
      descricao: json['descricao'],
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      data: json['data'] ?? '',
      categoria: json['categoria'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'data': data,
      'categoria': categoria,
    };
  }
}
