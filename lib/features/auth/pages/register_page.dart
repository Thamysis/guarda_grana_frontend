import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _fazerCadastro() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/usuarios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': _nomeController.text,
          'email': _emailController.text,
          'senha': _senhaController.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Cadastro realizado, volta para login
        Navigator.pop(context);
      } else {
        setState(() {
          _error = 'Erro ao cadastrar usuário';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro na conexão';
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
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
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
                          _fazerCadastro();
                        }
                      },
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}