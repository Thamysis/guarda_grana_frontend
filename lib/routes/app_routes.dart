import 'package:flutter/material.dart';
import '../features/despesas/pages/list_despesas_page.dart';
import '../features/despesas/pages/nova_despesa_page.dart';
import '../features/despesas/pages/editar_despesa_page.dart';
import '../features/receitas/pages/list_receitas_page.dart';
import '../features/receitas/pages/nova_receita_page.dart';
import '../features/receitas/pages/editar_receita_page.dart';
import '../data/models/despesa_model.dart';
import '../data/models/receita_model.dart';
import '../features/relatorios/pages/relatorio_anual_page.dart';

class AppRoutes {
  static const despesas = '/despesas';
  static const nova_despesa = '/despesas/nova';
  static const editar_despesa = '/despesas/editar';

  static const receitas = '/receitas';
  static const nova_receita = '/receitas/nova';
  static const editar_receita = '/receitas/editar';

  static const relatorioAnual = '/relatorios/anual';

  static Map<String, WidgetBuilder> routes = {
    despesas: (_) => const ListDespesasPage(),
    nova_despesa: (_) => const NovaDespesaPage(),
    editar_despesa: (context) {
      final despesa = ModalRoute.of(context)!.settings.arguments as DespesaModel;
      return EditarDespesaPage(despesa: despesa);
    },

    receitas: (_) => const ListReceitasPage(),
    nova_receita: (_) => const NovaReceitaPage(),
    editar_receita: (context) {
      final receita = ModalRoute.of(context)!.settings.arguments as ReceitaModel;
      return EditarReceitaPage(receita: receita);
    },
  };
}