class DespesaModel {
  final int id;
  final String nome;
  final String descricao;
  final String categoria;
  final String formaPagamento;
  final double valor;
  final String data;
  final Map<String, dynamic>? usuario;

  DespesaModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.formaPagamento,
    required this.valor,
    required this.data,
    this.usuario,
  });

  factory DespesaModel.fromJson(Map<String, dynamic> json) {
    return DespesaModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      categoria: json['categoria'] as String,
      formaPagamento: json['formaPagamento'] as String,
      valor: (json['valor'] as num).toDouble(),
      data: json['data'] as String,
      usuario: json['usuario'] as Map<String, dynamic>?, // Opcional
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'categoria': categoria,
      'formaPagamento': formaPagamento,
      'valor': valor,
      'data': data,
      if (usuario != null) 'usuario': usuario,
    };
  }
}
