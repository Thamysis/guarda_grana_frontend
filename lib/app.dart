import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

class GuardaGranaApp extends StatelessWidget {
  const GuardaGranaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guarda Grana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: AppRoutes.despesas,
      routes: AppRoutes.routes,
    );
  }
}
