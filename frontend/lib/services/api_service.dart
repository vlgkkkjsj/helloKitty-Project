import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/';

  // Adiciona uma nova tarefa
  static Future<bool> addTask(Task task) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    return response.statusCode == 201;
  }

  // Lista todas as tarefas
  static Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar tarefas: ${response.statusCode}');
    }
  }
}
