import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class HelloKittyHomePage extends StatefulWidget {
  const HelloKittyHomePage({super.key});

  @override
  State<HelloKittyHomePage> createState() => _HelloKittyHomePageState();
}

class _HelloKittyHomePageState extends State<HelloKittyHomePage> {
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = ApiService.fetchTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = ApiService.fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Loading...',
                          style: TextStyle(fontSize: 18, color: Colors.brown),
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
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddTaskScreen()),
                      );
                      _refreshTasks(); // Recarrega após voltar
                    },
                    child: const Chip(
                      backgroundColor: Colors.pink,
                      label: Text(
                        'Add Task',
                        style: TextStyle(color: Colors.white),
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
                    return const Center(child: Text('Erro ao carregar tarefas'));
                  } else if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhuma tarefa encontrada'));
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
