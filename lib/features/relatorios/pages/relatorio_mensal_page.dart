import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../data/models/despesa_model.dart';
import '../../../data/models/receita_model.dart';

class RelatorioMensalPage extends StatefulWidget {
  final List<DespesaModel> despesas;
  final List<ReceitaModel> receitas;
  final int mes;
  final int ano;

  const RelatorioMensalPage({
    super.key,
    required this.despesas,
    required this.receitas,
    required this.mes,
    required this.ano,
  });

  @override
  State<RelatorioMensalPage> createState() => _RelatorioMensalPageState();
}

class _RelatorioMensalPageState extends State<RelatorioMensalPage> {
  late int mesSelecionado;
  late int anoSelecionado;

  @override
  void initState() {
    super.initState();
    mesSelecionado = widget.mes;
    anoSelecionado = widget.ano;
  }

  @override
  Widget build(BuildContext context) {
    final receitasMes = widget.receitas.where((r) {
      final data = DateTime.parse(r.data);
      return data.month == mesSelecionado && data.year == anoSelecionado;
    }).toList();
    final despesasMes = widget.despesas.where((d) {
      final data = DateTime.parse(d.data);
      return data.month == mesSelecionado && data.year == anoSelecionado;
    }).toList();

    final totalReceitas = receitasMes.fold<double>(0, (s, r) => s + r.valor);
    final totalDespesas = despesasMes.fold<double>(0, (s, d) => s + d.valor);
    final total = totalReceitas + totalDespesas;

    final meses = [
      '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];

    final anosDisponiveis = List<int>.generate(8, (i) => DateTime.now().year - 5 + i);

    return Scaffold(
      appBar: AppBar(title: const Text('Relatório Mensal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Seletor de mês e ano
            Row(
              children: [
                const Text('Mês:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: mesSelecionado,
                  items: List.generate(
                    12,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text(meses[i + 1]),
                    ),
                  ),
                  onChanged: (novoMes) {
                    setState(() {
                      mesSelecionado = novoMes!;
                    });
                  },
                ),
                const SizedBox(width: 16),
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
            // Exibir totais
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Receitas', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    Text(
                      'R\$ ${totalReceitas.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Despesas', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    Text(
                      '-R\$ ${totalDespesas.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Gráfico pizza
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: totalReceitas,
                      color: Colors.green,
                      title: total > 0
                          ? '${((totalReceitas / total) * 100).toStringAsFixed(1)}%'
                          : '0%',
                      radius: 70,
                    ),
                    PieChartSectionData(
                      value: totalDespesas,
                      color: Colors.red,
                      title: total > 0
                          ? '${((totalDespesas / total) * 100).toStringAsFixed(1)}%'
                          : '0%',
                      radius: 70,
                    ),
                  ],
                  sectionsSpace: 4,
                  centerSpaceRadius: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}