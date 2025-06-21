import 'package:flutter/material.dart';
import '../../../../data/services/api_service.dart';
import '../../../../data/models/despesa_model.dart';

class ListDespesasPage extends StatefulWidget {
  const ListDespesasPage({super.key});

  @override
  State<ListDespesasPage> createState() => _ListDespesasPageState();
}

class _ListDespesasPageState extends State<ListDespesasPage> {
  final api = ApiService();
  late Future<List<DespesaModel>> despesas;

  @override
  void initState() {
    super.initState();
    _carregarDespesas();
  }

  void _carregarDespesas() {
    despesas = api.getDespesas();
  }

  Future<void> _confirmarExclusao(DespesaModel despesa) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('Deseja realmente excluir esta despesa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await api.deletarDespesa(despesa.id);
      setState(_carregarDespesas); // recarrega lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Despesas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/despesas/nova');
          setState(_carregarDespesas); // recarrega ao voltar
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<DespesaModel>>(
        future: despesas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma despesa encontrada'));
          } else {
            final lista = snapshot.data!;
            return ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final despesa = lista[index];
                return ListTile(
                  title: Text(despesa.nome),
                  subtitle: Text('${despesa.categoria} • ${despesa.data}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'R\$ ${despesa.valor.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            '/despesas/editar',
                            arguments: despesa,
                          );
                          setState(_carregarDespesas); 
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmarExclusao(despesa),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
