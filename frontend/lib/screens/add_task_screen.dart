import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTaskScreen extends StatefulWidget {
  final String user;

  const AddTaskScreen({super.key, required this.user});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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
        'user': widget.user,
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
          title: const Text('Erro ao adicionar'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      );
    }
  }

  InputDecoration _kittyDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.pink),
      filled: true,
      fillColor: const Color(0xFFFCEEF2),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.pink, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.pink, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text('Add New Task', style: TextStyle(color: Colors.brown)),
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              Image.asset('assets/hello_kitty.gif', height: 120),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: _kittyDecoration('Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: _kittyDecoration('Description'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: _kittyDecoration('Priority'),
                borderRadius: BorderRadius.circular(20), // 💖 borda mais arredondada
                items: [
                  DropdownMenuItem(
                    value: 'High',
                    child: Text('🔥 High'),
                  ),
                  DropdownMenuItem(
                    value: 'Medium',
                    child: Text('💼 Medium'),
                  ),
                  DropdownMenuItem(
                    value: 'Low',
                    child: Text('🧸 Low'),
                  ),
                ],
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
                  backgroundColor: const Color(0xFFF48FB1),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit Task',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
