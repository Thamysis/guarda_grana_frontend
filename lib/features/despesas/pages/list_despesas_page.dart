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
    despesas = api.getDespesas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Despesas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/despesas/nova'),
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
            return ListView(
              children: snapshot.data!
                  .map((e) => ListTile(
                        title: Text(e.nome),
                        subtitle: Text('${e.categoria} • ${e.data}'),
                        trailing: Text('R\$ ${e.valor.toStringAsFixed(2)}'),
                      ))
                  .toList(),
            );
          }
        },
      ),
    );
  }
}
