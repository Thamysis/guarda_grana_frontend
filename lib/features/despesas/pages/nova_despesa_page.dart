import 'package:flutter/material.dart';
import '../../../../data/models/despesa_model.dart';
import '../../../../data/services/api_service.dart';

class NovaDespesaPage extends StatefulWidget {
  const NovaDespesaPage({super.key});

  @override
  State<NovaDespesaPage> createState() => _NovaDespesaPageState();
}

class _NovaDespesaPageState extends State<NovaDespesaPage> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final dataController = TextEditingController();
  final categoriaController = TextEditingController();

  final api = ApiService();

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final despesa = DespesaModel(
        nome: nomeController.text,
        descricao: descricaoController.text,
        valor: double.tryParse(valorController.text) ?? 0,
        data: dataController.text,
        categoria: categoriaController.text,
      );

      await api.criarDespesa(despesa);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Despesa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome'), validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(controller: descricaoController, decoration: const InputDecoration(labelText: 'Descrição')),
              TextFormField(controller: valorController, decoration: const InputDecoration(labelText: 'Valor'), keyboardType: TextInputType.number),
              TextFormField(controller: dataController, decoration: const InputDecoration(labelText: 'Data (AAAA-MM-DD)')),
              TextFormField(controller: categoriaController, decoration: const InputDecoration(labelText: 'Categoria')),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
