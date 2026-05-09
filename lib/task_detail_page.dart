import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'todos_scope.dart';

// we must persist the textField data (_description)
class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key, required this.id});

  final String id;

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  TextEditingController? _description;
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    // also called once after init
    super.didChangeDependencies();
    final scope = TodosScope.of(context);
    final todo = scope.findById(widget.id);
    if (todo != null && _description == null) {
      // notice how the _TaskDetailPageState does not hold a reference to the Todo
      // instead it grabs it from the scope when it needs it
      _description = TextEditingController(text: todo.description);
    } 
  }

  @override
  void dispose() {
    // dispose tears down the listener (of the value of the text)
    _description?.dispose();
    super.dispose();
  }

  Future<void> _share(BuildContext context) async {
    final link = 'todoapp://task/${widget.id}';
    await Clipboard.setData(ClipboardData(text: link));
    if (! context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied')),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    if (file == null || !mounted) return;
    final scope = TodosScope.of(context);
    final todo = scope.findById(widget.id);
    if (todo == null) return;
    scope.update(todo.id, todo.copyWith(imagePath: file.path));
  }

  Future<void> _showPickerSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        // could have used a column but Wrap automatically resized to content height
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                // just like the "add task" button, we are treating those interactions as fleeting (just a popup).
                // if we had to deeplink to e.g. the image picker we would have to change and
                // use the Router.
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = TodosScope.of(context);
    final todo = scope.findById(widget.id);

    if (todo == null) {
      return const Scaffold(
        body: Center(child: Text('Task not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Task Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Checkbox(
                value: todo.done,
                onChanged: (_) => scope.toggle(todo.id),
              ),
              Expanded(
                child: Text(
                  todo.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Created: ${todo.createdAt.toLocal()}'),
          const SizedBox(height: 16),
          TextField(
            controller: _description,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            onChanged: (text) =>
                scope.update(todo.id, todo.copyWith(description: text)),
          ),
          const SizedBox(height: 16),
          if (todo.imagePath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(todo.imagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const SizedBox(height: 200, child: Center(child: Icon(Icons.broken_image))),
              ),
            ),
            const SizedBox(height: 8),
            // could have use a ListTile but using TextButton.icon because 
            // is more compact by default 
            TextButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove picture'),
              onPressed: () =>
                  scope.update(todo.id, todo.copyWith(clearImage: true)),
            ),
            const SizedBox(height: 8),
          ],
          FilledButton.icon(
            icon: const Icon(Icons.add_a_photo),
            label: Text('Add picture'),
            onPressed: _showPickerSheet,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Share (deeplink)'),
            onPressed: () => _share(context),
          ),
        ],
      ),
    );
  }
}
