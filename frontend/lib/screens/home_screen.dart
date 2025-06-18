import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_task_screen.dart';
import '../models/task.dart';
import '../services/api_service.dart';
import 'register_screen.dart';

class HelloKittyHomePage extends StatefulWidget {
  const HelloKittyHomePage({super.key});

  @override
  State<HelloKittyHomePage> createState() => _HelloKittyHomePageState();
}

class _HelloKittyHomePageState extends State<HelloKittyHomePage> {
  late Future<List<Task>> _tasksFuture;
  bool isLoggedIn = false;
  String user = '';

  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tasksFuture = Future.value([]); // Inicia vazio até login
  }

  void _refreshTasks() {
    if (isLoggedIn && user.isNotEmpty) {
      setState(() {
        _tasksFuture = ApiService.fetchTasks(user);
      });
    }
  }

 Future<void> login(String userInput, String password) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/login/');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': userInput, 'password': password}), // << CORRIGIDO AQUI
  );

  if (response.statusCode == 200) {
    setState(() {
      isLoggedIn = true;
      user = userInput;
      _tasksFuture = ApiService.fetchTasks(userInput);
    });
    Navigator.pop(context); // Fecha drawer
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro de login'),
        content: const Text('Usuário ou senha inválidos'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}


  void logout() {
    setState(() {
      isLoggedIn = false;
      user = '';
      _tasksFuture = Future.value([]); // Limpa lista de tasks
    });
    Navigator.pop(context); // Fecha drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      drawer: Drawer(
        child: isLoggedIn
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, size: 80, color: Colors.pink),
                    Text('Bem-vindo, $user!',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: logout,
                      child: const Text("Logout"),
                    )
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _userController,
                        decoration: const InputDecoration(
                          labelText: 'Usuário',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Informe o usuário' : null,
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
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login(_userController.text,
                                _passwordController.text);
                          }
                        },
                        child: const Text('Entrar'),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Não tem conta? ',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Cadastre-se',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  },
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
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text('Hello Kitty Tasks'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/hello_kitty.gif',
                    height: 120,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'a beautiful day!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<List<Task>>(
                    future: _tasksFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Text(
                          'Loading...',
                          style:
                              TextStyle(fontSize: 18, color: Colors.brown),
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                          'Error',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        );
                      } else {
                        return Text(
                          'Tasks Total: ${snapshot.data!.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.brown,
                          ),
                        );
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: isLoggedIn
                        ? () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(
                                        user: user,
                                      )),
                            );
                            if (result == true) {
                              _refreshTasks();
                            }
                          }
                        : null,
                    child: Chip(
                      backgroundColor:
                          isLoggedIn ? Colors.pink : Colors.grey[400],
                      label: Text(
                        'Add Task',
                        style: TextStyle(
                            color: isLoggedIn
                                ? Colors.white
                                : Colors.grey[700]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: FutureBuilder<List<Task>>(
                future: _tasksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erro ao carregar tarefas'));
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                      isLoggedIn
                          ? 'Nenhuma tarefa encontrada'
                          : 'Faça login para ver suas tarefas',
                      style: const TextStyle(fontSize: 16),
                    ));
                  }

                  final tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskTile(
                        title: task.title,
                        icon: Icons.task_alt,
                        emoji: task.priority == 'High'
                            ? '🔥'
                            : task.priority == 'Medium'
                                ? '💼'
                                : '🧸',
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sections',
              style: TextStyle(
                fontSize: 18,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  SectionIcon(icon: Icons.card_giftcard),
                  SectionIcon(icon: Icons.menu_book),
                  SectionIcon(icon: Icons.shopping_bag),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String emoji;

  const TaskTile({
    super.key,
    required this.icon,
    required this.title,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(icon, color: Colors.pink),
      ),
    );
  }
}

class SectionIcon extends StatelessWidget {
  final IconData icon;

  const SectionIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.pink[100],
      radius: 30,
      child: Icon(
        icon,
        color: Colors.brown,
      ),
    );
  }
}
