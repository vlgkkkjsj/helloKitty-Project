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
    body: jsonEncode({'username': userInput, 'password': password}),
  );

  if (response.statusCode == 200) {
    setState(() {
      isLoggedIn = true;
      user = userInput;
      _tasksFuture = ApiService.fetchTasks(userInput);
    });
    Navigator.pop(context);
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

      backgroundColor: const Color(0xFFFFF0F5),

      child: isLoggedIn
      
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 80, color: Colors.pink),
              const SizedBox(height: 10),
              Text(
                'Bem-vindo, $user!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: logout,
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.brown),
                ),
              ),
            ],
          ),
        )
      : Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Campo Usuário
                TextFormField(
                  controller: _userController,
                  decoration: InputDecoration(
                    labelText: 'Usuário',
                    labelStyle: const TextStyle(color: Colors.pink),
                    filled: true,
                    fillColor: const Color(0xFFFFF0F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.pink),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.pink),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.pink, width: 2),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe o usuário' : null,
                ),
                const SizedBox(height: 10),

                // Campo Senha
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: const TextStyle(color: Colors.pink),
                    filled: true,
                    fillColor: const Color(0xFFFFF0F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.pink),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.pink),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.pink, width: 2),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Informe a senha' : null,
                ),
                const SizedBox(height: 20),

                // Botão Entrar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      login(_userController.text, _passwordController.text);
                    }
                  },
                  child: const Text(
                    'Entrar',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),

                const SizedBox(height: 20),

                // Link para Cadastro
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Não tem conta? ',
                      style: const TextStyle(color: Colors.brown),
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
  backgroundColor: const Color(0xFFFFF0F5),
  elevation: 0,
  title: const Text(
    'Hello Kitty Tasks',
    style: TextStyle(color: Colors.brown),
  ),
  iconTheme: const IconThemeData(color: Colors.brown),
),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F5),
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
                  ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(

                    backgroundColor: isLoggedIn ? Colors.pink : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: isLoggedIn
                        ? () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTaskScreen(user: user),
                              ),
                            );
                            if (result == true) {
                              _refreshTasks();
                            }
                          }
                        : null,
                    child: Text(
                      'Add Task',
                      style: TextStyle(
                        color: isLoggedIn ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
              color: const Color(0xFFFFF0F5),
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
                        task: task, // ✅ CORRETO
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
  final Task task;
  final IconData icon;
  final String emoji;

  const TaskTile({
    super.key,
    required this.task,
    required this.icon,
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
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: const Color(0xFFFFF0F5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Center(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.brown,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.description.isNotEmpty) ...[
                    const Text(
                      "Descrição:",
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F5),
                        border: Border.all(color: Colors.pink),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.description,
                        style: const TextStyle(color: Colors.brown),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const Text(
                    "Data de entrega:",
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F5),
                      border: Border.all(color: Colors.pink),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.dueDate ?? 'Não definida',
                      style: const TextStyle(color: Colors.brown),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Prioridade:",
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F5),
                      border: Border.all(color: Colors.pink),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.priority,
                      style: const TextStyle(color: Colors.brown),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Status:",
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F5),
                      border: Border.all(color: Colors.pink),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.isCompleted ? "✅ Concluída" : "❌ Não concluída",
                      style: const TextStyle(color: Colors.brown),
                    ),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      "Fechar",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        leading: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          task.title,
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
