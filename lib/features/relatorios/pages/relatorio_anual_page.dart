import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/despesa_model.dart';
import '../../../data/models/receita_model.dart';
import 'relatorio_mensal_page.dart';
import 'relatorio_categoria_page.dart';

class RelatorioAnualPage extends StatefulWidget {
  final List<DespesaModel> despesas;
  final List<ReceitaModel> receitas;

  const RelatorioAnualPage({
    super.key,
    required this.despesas,
    required this.receitas,
  });

  @override
  State<RelatorioAnualPage> createState() => _RelatorioAnualPageState();
}

class _RelatorioAnualPageState extends State<RelatorioAnualPage> {
  late int anoSelecionado;

  @override
  void initState() {
    super.initState();
    anoSelecionado = DateTime.now().year;
  }

  Map<int, double> agruparPorMes(List<dynamic> lista, int ano) {
    final Map<int, double> somaPorMes = {};
    for (var item in lista) {
      final data = DateTime.parse(item.data);
      if (data.year == ano) {
        final mes = data.month;
        somaPorMes[mes] = (somaPorMes[mes] ?? 0) + item.valor;
      }
    }
    return somaPorMes;
  }

  @override
  Widget build(BuildContext context) {
    // Anos possíveis (de 5 anos atrás até 2 anos à frente)
    final anosDisponiveis = List<int>.generate(8, (i) => DateTime.now().year - 5 + i);

    final receitasPorMes = agruparPorMes(widget.receitas, anoSelecionado);
    final despesasPorMes = agruparPorMes(widget.despesas, anoSelecionado);

    // Garante que todos os meses estejam presentes com valor 0 se não houver dados
    Map<int, double> fillMeses(Map<int, double> original) {
      final result = <int, double>{};
      for (int i = 1; i <= 12; i++) {
        result[i] = original[i] ?? 0.0;
      }
      return result;
    }

    final receitasMes = fillMeses(receitasPorMes);
    final despesasMes = fillMeses(despesasPorMes);

    final maxY = [
      ...receitasMes.values,
      ...despesasMes.values
    ].fold<double>(0, (prev, el) => el > prev ? el : prev) * 1.1; // 10% acima do máximo

    final minY = 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Relatório Anual')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Seletor de ano
            Row(
              children: [
                const Text('Ano:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: anoSelecionado,
                  items: anosDisponiveis
                      .map((ano) => DropdownMenuItem(
                            value: ano,
                            child: Text(ano.toString()),
                          ))
                      .toList(),
                  onChanged: (novoAno) {
                    setState(() {
                      anoSelecionado = novoAno!;
                    });
                  },
                ),
              ],
            ),
            // Totais
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Receitas', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    Text(
                      'R\$ ${receitasPorMes.values.fold(0.0, (a, b) => a + b).toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Despesas', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    Text(
                      '-R\$ ${despesasPorMes.values.fold(0.0, (a, b) => a + b).toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Gráfico de linhas receitas/despesas
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minX: 1,
                  maxX: 12,
                  minY: minY,
                  maxY: maxY == 0 ? 10 : maxY,
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
                        interval: maxY == 0 ? 2 : (maxY / 4),
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
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
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // --- Botões ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RelatorioMensalPage(
                        despesas: widget.despesas,
                        receitas: widget.receitas,
                        mes: DateTime.now().month,
                        ano: anoSelecionado,
                      ),
                    ),
                  );
                },
                child: const Text('Relatório Mensal'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RelatorioPorCategoriaPage(
                        despesas: widget.despesas,
                        mes: DateTime.now().month,
                        ano: anoSelecionado,
                      ),
                    ),
                  );
                },
                child: const Text('Gastos por Categoria'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}