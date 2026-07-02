import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/memory_provider.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  String category = "Strategy";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemoryProvider>();
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Knowledge Base"),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddDialog(
            context,
            provider,
            auth.currentUser!.userId,
          );
        },
      ),

      body: provider.memories.isEmpty
          ? const Center(
              child: Text(
                "No memories added yet.",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.memories.length,
              itemBuilder: (_, index) {
                final memory = provider.memories[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            Chip(
                              label: Text(memory.category),
                            ),

                            const Spacer(),

                            const Icon(Icons.psychology),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Text(
                          memory.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(memory.content),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddDialog(
    BuildContext context,
    MemoryProvider provider,
    String executiveId,
  ) {
    titleController.clear();
    contentController.clear();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Memory"),

          content: SingleChildScrollView(
            child: Column(
              children: [

                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Content",
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: category,
                  items: const [

                    DropdownMenuItem(
                      value: "Strategy",
                      child: Text("Strategy"),
                    ),

                    DropdownMenuItem(
                      value: "Meeting",
                      child: Text("Meeting"),
                    ),

                    DropdownMenuItem(
                      value: "Technical",
                      child: Text("Technical"),
                    ),

                    DropdownMenuItem(
                      value: "General",
                      child: Text("General"),
                    ),
                  ],
                  onChanged: (v) {
                    category = v!;
                  },
                ),
              ],
            ),
          ),

          actions: [

            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {

                final success =
                    await provider.addMemory(
                  executiveId: executiveId,
                  title: titleController.text,
                  content: contentController.text,
                  category: category,
                );

                if (context.mounted) {
                  Navigator.pop(context);

                  if (!success) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content:
                            Text("Failed to save memory"),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}