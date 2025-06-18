import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTaskScreen extends StatefulWidget {
  final String user;  // <-- adicionei aqui

  const AddTaskScreen({super.key, required this.user});  // <-- construtor recebe username

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  String _selectedPriority = 'Low';

  bool _isSubmitting = false;

Future<void> _submitTask() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isSubmitting = true);

  final url = Uri.parse('http://127.0.0.1:8000/api/tasks/');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'priority': _selectedPriority,
      'user': widget.user, // <- 🔥 Correção essencial
    }),
  );

  setState(() => _isSubmitting = false);

  if (response.statusCode == 201) {
    Navigator.pop(context, true);
  } else {
    final error = jsonDecode(response.body);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.pink[50],
        title: const Text(
          'Erro ao adicionar',
          style: TextStyle(color: Colors.brown),
        ),
        content: Text(error.toString()),
        actions: [
          TextButton(
            child: const Text('OK', style: TextStyle(color: Colors.pink)),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        title: const Text(
          'Add New Task',
          style: TextStyle(color: Colors.brown),
        ),
        iconTheme: const IconThemeData(color: Colors.brown),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/hello_kitty.gif',
                  height: 100,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Let\'s add a task!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _titleController,
                  decoration: _inputDecoration('Title'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: _inputDecoration('Description'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: _inputDecoration('Priority'),
                  items: ['Low', 'Medium', 'High']
                      .map((priority) => DropdownMenuItem<String>(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedPriority = value);
                    }
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Task',
                          style: TextStyle(color: Colors.white),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.brown),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      filled: true,
      fillColor: Colors.pink[50],
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.pink),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
