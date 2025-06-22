import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/receita_model.dart';
import '../../../../data/services/api_service.dart';

class EditarReceitaPage extends StatefulWidget {
  final ReceitaModel receita;

  const EditarReceitaPage({super.key, required this.receita});

  @override
  State<EditarReceitaPage> createState() => _EditarReceitaPageState();
}

class _EditarReceitaPageState extends State<EditarReceitaPage> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final valorController = TextEditingController();
  final dataController = TextEditingController();

  String? categoriaSelecionada;
  String? formaPagamentoSelecionada;

  final api = ApiService();

  final Map<String, String> categorias = {
    'Salário': 'SALARIO',
    'Rendimentos': 'RENDIMENTOS',
    'Investimentos': 'INVESTIMENTOS',
    'Vendas': 'VENDAS',
    'Reembolsos': 'REEMBOLSOS',
    'Outros': 'OUTROS',
  };

  @override
  void initState() {
    super.initState();

    nomeController.text = widget.receita.nome;
    descricaoController.text = widget.receita.descricao;
    valorController.text = widget.receita.valor.toStringAsFixed(2);

    // Converte data para dd/MM/yyyy
    dataController.text = DateFormat('dd/MM/yyyy')
        .format(DateTime.parse(widget.receita.data));

    categoriaSelecionada = categorias.entries
        .firstWhere((e) => e.value == widget.receita.categoria,
            orElse: () => const MapEntry('', ''))
        .key;
  }

  Future<void> _selecionarData(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(widget.receita.data) ?? DateTime.now(),
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

      final receitaEditada = ReceitaModel(
        id: widget.receita.id,
        nome: nomeController.text,
        descricao: descricaoController.text,
        valor: double.tryParse(valorController.text) ?? 0,
        data: dataFormatada,
        categoria: categorias[categoriaSelecionada] ?? '',
        // usuarioId: widget.receita.usuarioId,
      );

      await api.editarReceita(receitaEditada); // <-- backend deve ter PUT /receitas/:id
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Receita')),
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
                    decoration:
                        const InputDecoration(labelText: 'Data (dd/mm/aaaa)'),
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
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar Alterações')),
            ],
          ),
        ),
      ),
    );
  }
}
