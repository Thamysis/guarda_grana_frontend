import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/registro_list_tile.dart';
import '../../relatorios/widgets/btn_relatorios.dart';
import '../../relatorios/widgets/btn_metas.dart';
import '../../../core/theme/app_colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, '/despesas');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/receitas');
    }
    setState(() {
      _selectedIndex = index;
    });
  }

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
          final saldoInteiro = partes[0];
          final saldoDecimal = partes[1];

          return Scaffold(
            appBar: AppBar(
              title: Text('Olá, ${usuario.nome}!'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {/* Metas */},
                ),
              ],
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ÁREA AZUL (PRINCIPAL) QUE ENVOLVE ROXO + BOTÃO
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.primary,
                  child: Column(
                    children: [
                      // CONTAINER ROXO DO SALDO
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
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
                                        text: saldoInteiro,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 44,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ',${saldoDecimal}',
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
                      // BOTÃO QUADRADO LOGO ABAIXO DO SALDO E DENTRO DA ÁREA AZUL
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BtnRelatorios(
                              onTap: () {
                                Navigator.pushNamed(context, '/relatorios/anual');
                              },
                              icon: Icons.bar_chart,
                              texto: 'Relatórios',
                            ),
                            BtnMetas(
                              onTap: () {
                                // navegação para a página de Metas
                                // Navigator.pushNamed(context, '/metas');
                              },
                              icon: Icons.flag,
                              texto: 'Metas',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Últimos registros',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: Colors.grey,
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