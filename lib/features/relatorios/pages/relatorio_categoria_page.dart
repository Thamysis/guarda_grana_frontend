import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/despesa_model.dart';

class RelatorioPorCategoriaPage extends StatefulWidget {
  final List<DespesaModel> despesas;
  final int mes;
  final int ano;

  const RelatorioPorCategoriaPage({
    super.key,
    required this.despesas,
    required this.mes,
    required this.ano,
  });

  @override
  State<RelatorioPorCategoriaPage> createState() => _RelatorioPorCategoriaPageState();
}

class _RelatorioPorCategoriaPageState extends State<RelatorioPorCategoriaPage> {
  late int _mes;
  late int _ano;

  @override
  void initState() {
    super.initState();
    _mes = widget.mes;
    _ano = widget.ano;
  }

  static const mesesNomes = [
    '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  @override
  Widget build(BuildContext context) {
    final anosDisponiveis = List<int>.generate(8, (i) => DateTime.now().year - 5 + i);

    final despesasMes = widget.despesas.where((d) {
      final data = DateTime.parse(d.data);
      return data.month == _mes && data.year == _ano;
    }).toList();

    Map<String, double> somaPorCategoria = {};
    for (var d in despesasMes) {
      somaPorCategoria[d.categoria] = (somaPorCategoria[d.categoria] ?? 0) + d.valor;
    }

    final total = somaPorCategoria.values.fold<double>(0, (a, b) => a + b);
    final categoriaColors = [
      Colors.orange,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.amber,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas por Categoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seletor de mês e ano no topo
            Row(
              children: [
                const Text('Mês:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _mes,
                  items: List.generate(
                    12,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text(mesesNomes[i + 1]),
                    ),
                  ),
                  onChanged: (novoMes) {
                    setState(() {
                      _mes = novoMes!;
                    });
                  },
                ),
                const SizedBox(width: 16),
                const Text('Ano:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _ano,
                  items: anosDisponiveis
                      .map((ano) => DropdownMenuItem(
                            value: ano,
                            child: Text(ano.toString()),
                          ))
                      .toList(),
                  onChanged: (novoAno) {
                    setState(() {
                      _ano = novoAno!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: (somaPorCategoria.isEmpty)
                  ? const Center(child: Text('Nenhuma despesa neste mês.'))
                  : PieChart(
                      PieChartData(
                        sections: somaPorCategoria.entries.toList().asMap().entries.map((entry) {
                          int idx = entry.key;
                          //final categoria = entry.value.key;
                          final valor = entry.value.value;
                          final percentual = total > 0 ? (valor / total) * 100 : 0.0;
                          return PieChartSectionData(
                            value: valor,
                            color: categoriaColors[idx % categoriaColors.length],
                            title: '${percentual.toStringAsFixed(0)}%\nR\$${valor.toStringAsFixed(2)}',
                            titleStyle: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black,
                            ),
                            radius: 70,
                          );
                        }).toList(),
                        sectionsSpace: 4,
                        centerSpaceRadius: 32,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            // Legenda
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: somaPorCategoria.keys.toList().asMap().entries.map((entry) {
                int idx = entry.key;
                String categoria = entry.value;
                double valor = somaPorCategoria[categoria] ?? 0.0;
                return Chip(
                  avatar: CircleAvatar(
                    backgroundColor: categoriaColors[idx % categoriaColors.length],
                  ),
                  label: Text(
                    '$categoria  R\$${valor.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: categoriaColors[idx % categoriaColors.length],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: categoriaColors[idx % categoriaColors.length].withOpacity(0.08),
                  side: BorderSide(
                    color: categoriaColors[idx % categoriaColors.length],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: R\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}