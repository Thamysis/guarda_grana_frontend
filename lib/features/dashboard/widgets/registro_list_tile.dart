import 'package:flutter/material.dart';
import 'package:guarda_grana_frontend/core/theme/app_colors.dart';
import '../controllers/dashboard_controller.dart';

class RegistroListTile extends StatelessWidget {
  final RegistroFinanceiro registro;
  const RegistroListTile({super.key, required this.registro});

  String getDataFormatada() {
    try {
      final date = DateTime.parse(registro.data);
      final now = DateTime.now();
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        return 'Hoje';
      } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
        return 'Ontem';
      } else {
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
      }
    } catch (_) {
      return registro.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: registro.isReceita ? AppColors.bgGreen: AppColors.bgRed,
        child: Icon(
          registro.isReceita ? Icons.arrow_downward : Icons.arrow_upward,
          color: registro.isReceita ? AppColors.green: AppColors.red,
        ),
      ),
      title: Text(registro.nome),
      subtitle: Text(getDataFormatada()),
      trailing: Text(
        '${registro.valor >= 0 ? '+' : '-'}R\$ ${registro.valor.abs().toStringAsFixed(2)}',
        style: TextStyle(
          color: registro.valor >= 0 ? AppColors.green: AppColors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
