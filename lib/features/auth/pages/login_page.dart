import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _fazerLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'senha': _senhaController.text,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['token'];
        final id = json['id'];
        final intId = id is int ? id : int.parse(id.toString());
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setInt('usuario_id', intId);

        // Redireciona para o dashboard ou tela principal
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        setState(() {
          _error = 'Credenciais inválidas';
        });
      }
    } catch (e, s) {
        print('Erro real no login: $e');
        print(s);
        setState(() {
            _error = 'Erro na conexão: $e';
        });
        } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o e-mail' : null,
              ),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a senha' : null,
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _fazerLogin();
                        }
                      },
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Entrar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Não tem conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}