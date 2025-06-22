import 'package:flutter/material.dart';
import '../features/despesas/pages/list_despesas_page.dart';
import '../features/despesas/pages/nova_despesa_page.dart';
import '../features/despesas/pages/editar_despesa_page.dart';

class AppRoutes {
  static const despesas = '/despesas';
  static const nova_despesa = '/despesas/nova';
  static const editar_despesa = '/despesas/editar';

  static Map<String, WidgetBuilder> routes = {
    despesas: (_) => const ListDespesasPage(),
    nova_despesa:(_) => const NovaDespesaPage(),
    editar_despesa:(_) => const EditarDespesaPage()
  };
}
