// class DespesaModel {
//   final int? id;
//   final String nome;
//   final String? descricao;
//   final double valor;
//   final String data;
//   final String? categoria;

//   DespesaModel({
//     this.id,
//     required this.nome,
//     this.descricao,
//     required this.valor,
//     required this.data,
//     this.categoria,
//   });

//   factory DespesaModel.fromJson(Map<String, dynamic> json) {
//     return DespesaModel(
//       id: json['id'],
//       nome: json['nome'] ?? 'Sem nome',
//       descricao: json['descricao'],
//       valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
//       data: json['data'] ?? '',
//       categoria: json['categoria'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'nome': nome,
//       'descricao': descricao,
//       'valor': valor,
//       'data': data,
//       'categoria': categoria,
//     };
//   }
// }

class DespesaModel {
  final int id;
  final String nome;
  final String descricao;
  final String categoria;
  final String formaPagamento;
  final double valor;
  final String data;

  DespesaModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.formaPagamento,
    required this.valor,
    required this.data,
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
    };
  }
}
