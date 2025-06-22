import 'package:flutter/material.dart';
import '../../../../data/services/api_service.dart';
import '../../../../data/models/receita_model.dart';

class ListReceitasPage extends StatefulWidget {
  const ListReceitasPage({super.key});

  @override
  State<ListReceitasPage> createState() => _ListReceitasPageState();
}

class _ListReceitasPageState extends State<ListReceitasPage> {
  final api = ApiService();
  late Future<List<ReceitaModel>> receitas;

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
  }

  void _carregarReceitas() {
    receitas = api.getReceitas();
  }

  Future<void> _confirmarExclusao(ReceitaModel receita) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('Deseja realmente excluir esta receita?'),
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
      await api.deletarReceita(receita.id);
      setState(_carregarReceitas); // recarrega lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receitas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/receitas/nova');
          setState(_carregarReceitas); // recarrega ao voltar
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<ReceitaModel>>(
        future: receitas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma receita encontrada'));
          } else {
            final lista = snapshot.data!;
            return ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final receita = lista[index];
                return ListTile(
                  title: Text(receita.nome),
                  subtitle: Text('${receita.categoria} • ${receita.data}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'R\$ ${receita.valor.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            '/receitas/editar',
                            arguments: receita,
                          );
                          setState(_carregarReceitas); 
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmarExclusao(receita),
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
