import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/registro_list_tile.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardController()..fetchUsuario(),
      child: Consumer<DashboardController>(
        builder: (context, controller, child) {
          if (controller.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (controller.error != null) {
            return Scaffold(
              body: Center(child: Text(controller.error!)),
            );
          }
          final usuario = controller.usuario;
          if (usuario == null) return const SizedBox.shrink();

          return Scaffold(
            appBar: AppBar(
              title: Text('Olá, ${usuario.nome}!'),
              actions: [
                IconButton(icon: const Icon(Icons.flag), onPressed: () {/* Metas */}),
                IconButton(icon: const Icon(Icons.bar_chart), onPressed: () {/* Relatórios */}),
              ],
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Saldo da Conta',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'R\$ ${usuario.saldoAtual?.toStringAsFixed(2) ?? usuario.saldoInicial.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Últimos registros', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      TextButton(
                        onPressed: () {
                          // navegar para todos registros
                        },
                        child: const Text('Ver tudo'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: controller.ultimosRegistros.isEmpty
                      ? const Center(child: Text('Nenhum registro encontrado'))
                      : ListView.builder(
                          itemCount: controller.ultimosRegistros.length,
                          itemBuilder: (context, index) {
                            final registro = controller.ultimosRegistros[index];
                            return RegistroListTile(registro: registro);
                          },
                        ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
                BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'Contas'),
                BottomNavigationBarItem(icon: Icon(Icons.trending_down), label: 'Despesas'),
                BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Receitas'),
              ],
            ),
          );
        },
      ),
    );
  }
}
