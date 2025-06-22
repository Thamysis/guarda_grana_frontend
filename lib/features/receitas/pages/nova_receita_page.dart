import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/receita_model.dart';
import '../../../../data/services/api_service.dart';

class NovaReceitaPage extends StatefulWidget {
  const NovaReceitaPage({super.key});

  @override
  State<NovaReceitaPage> createState() => _NovaReceitaPageState();
}

class _NovaReceitaPageState extends State<NovaReceitaPage> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final dataController = TextEditingController();

  String? categoriaSelecionada;

  final api = ApiService();

  // Mapas para combo boxes
  final Map<String, String> categorias = {
    'Salário': 'SALARIO',
    'Rendimentos': 'RENDIMENTOS',
    'Investimentos': 'INVESTIMENTOS',
    'Vendas': 'VENDAS',
    'Reembolsos': 'REEMBOLSOS',
    'Outros': 'OUTROS',
  };

  Future<void> _selecionarData(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dataController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final dataFormatada = DateFormat('yyyy-MM-dd').format(
        DateFormat('dd/MM/yyyy').parse(dataController.text),
      );

      final receita = ReceitaModel(
        id: 0,
        nome: nomeController.text,
        descricao: descricaoController.text,
        valor: double.tryParse(valorController.text) ?? 0,
        data: dataFormatada,
        categoria: categorias[categoriaSelecionada] ?? '',
      );

      await api.criarReceita(receita);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Receita')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: valorController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
              ),
              GestureDetector(
                onTap: () => _selecionarData(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dataController,
                    decoration: const InputDecoration(labelText: 'Data (dd/mm/aaaa)'),
                    validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                value: categoriaSelecionada,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: categorias.keys
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    categoriaSelecionada = value;
                  });
                },
                validator: (v) => v == null ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
