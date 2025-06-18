import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _idUserController = TextEditingController();

  bool _isLoading = false;

  Future<void> registerUser() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/register/');

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
          'nickname': _nicknameController.text,
          'age': int.tryParse(_ageController.text) ?? 0,
          'id_user': _idUserController.text,
        }),
      );

      final data = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Cadastro realizado com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        String errorMessage = 'Erro: ';
        if (data is Map) {
          data.forEach((key, value) {
            errorMessage += '\n$key: ${value[0]}';
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de rede ou servidor')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Conta")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Cadastro de Usuário",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuário',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o nome de usuário' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Informe a senha' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Apelido (nickname)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o apelido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Informe a idade' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _idUserController,
                decoration: const InputDecoration(
                  labelText: 'ID do Usuário',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o ID do usuário' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerUser();
                        }
                      },
                      child: const Text('Cadastrar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
