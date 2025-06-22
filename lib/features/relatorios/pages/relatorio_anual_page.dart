import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/despesa_model.dart';
import '../../../data/models/receita_model.dart';

class RelatorioAnualPage extends StatelessWidget {
  final List<DespesaModel> despesas;
  final List<ReceitaModel> receitas;

  const RelatorioAnualPage({
    super.key,
    required this.despesas,
    required this.receitas,
  });

  Map<int, double> agruparPorMes(List<dynamic> lista) {
    final Map<int, double> somaPorMes = {};
    for (var item in lista) {
      final mes = DateTime.parse(item.data).month;
      somaPorMes[mes] = (somaPorMes[mes] ?? 0) + item.valor;
    }
    return somaPorMes;
  }

  // Garante que todos os meses de 1 a 12 existam no mapa (preenche zeros onde não houver valor)
  Map<int, double> preencherMeses(Map<int, double> dados) {
    final novo = <int, double>{};
    for (var m = 1; m <= 12; m++) {
      novo[m] = dados[m] ?? 0.0;
    }
    return novo;
  }

  @override
  Widget build(BuildContext context) {
    final receitasPorMes = agruparPorMes(receitas);
    final despesasPorMes = agruparPorMes(despesas);

    final receitasMes = preencherMeses(receitasPorMes);
    final despesasMes = preencherMeses(despesasPorMes);

    // Cálculo do limite do gráfico (eixo Y)
    final valores = [
      ...receitasMes.values,
      ...despesasMes.values,
    ];
    final double minY = 0;
    final double maxY = valores.isNotEmpty ? (valores.reduce(max) * 1.2) : 1000;

    return Scaffold(
      appBar: AppBar(title: const Text('Relatório Anual')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Título e totais
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Receitas',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'R\$ ${receitasMes.values.fold(0.0, (a, b) => a + b).toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Despesas',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '-R\$ ${despesasMes.values.fold(0.0, (a, b) => a + b).toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Gráfico de linhas
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minX: 1,
                  maxX: 12,
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: receitasMes.entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 4,
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: despesasMes.entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 4,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: maxY / 4,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const meses = [
                            '', 'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
                            'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ'
                          ];
                          if (value.toInt() >= 1 && value.toInt() <= 12) {
                            return Text(
                              meses[value.toInt()],
                              style: TextStyle(fontSize: 12),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}