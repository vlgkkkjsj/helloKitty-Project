import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedPriority = 'Low';

  bool _isSubmitting = false;

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final url = Uri.parse('http://127.0.0.1:8000/api/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user': _userController.text.trim(),
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'priority': _selectedPriority,
      }),
    );

    setState(() => _isSubmitting = false);

    if (response.statusCode == 201) {
      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: const Text('Add New Task', style: TextStyle(color: Colors.brown)),
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userController,
                decoration: const InputDecoration(
                  labelText: 'User',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'User is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
    );
  }
}
