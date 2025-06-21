import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  // 🔁 Ajuste este IP se estiver usando emulador ou dispositivo físico
  static const String baseUrl = 'http://127.0.0.1:8000/api/tasks/';

  // ================================
  // POST - Adiciona nova tarefa
  // ================================
  static Future<bool> addTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Erro ao adicionar tarefa: ${response.statusCode}');
        print('Resposta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão ao adicionar tarefa: $e');
      return false;
    }
  }

  // ================================
  // GET - Lista tarefas por usuário
  // ================================
  static Future<List<Task>> fetchTasks(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?user=$username'),
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Task.fromJson(data)).toList();
      } else {
        print('Erro ao buscar tarefas: ${response.statusCode}');
        print('Resposta: ${response.body}');
        throw Exception('Erro ao buscar tarefas');
      }
    } catch (e) {
      print('Erro de conexão ao buscar tarefas: $e');
      throw Exception('Erro de conexão');
    }
  }
}
