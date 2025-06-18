import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/registro_list_tile.dart';
import '../../../core/theme/app_colors.dart'; // ajuste o caminho conforme onde colocou


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

          final saldo = usuario.saldoAtual ?? usuario.saldoInicial;
          final saldoStr = saldo.toStringAsFixed(2).replaceAll('.', ',');
          final partes = saldoStr.split(',');
          final saldoInteiro = partes[0]; // ex: "14,235"
          final saldoDecimal = partes[1]; // ex: "34"

          return Scaffold(
            appBar: AppBar(
              title: Text('Olá, ${usuario.nome}!'),
              actions: [
                IconButton(icon: const Icon(Icons.settings), onPressed: () {/* Metas */}),
              ],
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary, // Fundo mais claro
                    //borderRadius: BorderRadius.circular(24),
                    
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.accent, // Fundo mais escuro (ex: roxo escuro)
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Saldo da Conta',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          const SizedBox(height: 10),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'R\$ ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  TextSpan(
                                    text: saldoInteiro, // parte inteira, ex: "14,235"
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 44,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ',${saldoDecimal}', // parte decimal, ex: "34"
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
