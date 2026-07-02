import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../../theme/colors.dart';
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  int dueMinutes = 60;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(
            context,
            provider,
            auth.currentUser!.userId,
          );
        },
        child: const Icon(Icons.add),
      ),

      body: provider.tasks.isEmpty
          ? const Center(
              child: Text(
                "No tasks available",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.tasks.length,
              itemBuilder: (_, index) {
                final task = provider.tasks[index];

                final overdue = task.dueDate != null &&
                    task.dueDate!.isBefore(DateTime.now());

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),

                  child: Padding(
                    padding: const EdgeInsets.all(18),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Row(
                          children: [

                            Expanded(
                              child: Text(
                                task.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            if (overdue)
                              const Chip(
                                label: Text("OVERDUE"),
                                backgroundColor: Colors.red,
                                labelStyle: TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              )
                            else
                              const Chip(
                                label: Text("UPCOMING"),
                              ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(task.description),

                        const SizedBox(height: 16),

                        Row(
                          children: [

                            const Icon(Icons.schedule),

                            const SizedBox(width: 8),

                            Text(
                              task.dueDate != null
                                  ? task.dueDate.toString()
                                  : "No Due Date",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showAddTaskDialog(
    BuildContext context,
    TaskProvider provider,
    String executiveId,
  ) {
    titleController.clear();
    descriptionController.clear();
    dueMinutes = 60;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("New Task"),

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
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [

                        const Text("Due in"),

                        const Spacer(),

                        DropdownButton<int>(
                          value: dueMinutes,
                          items: const [

                            DropdownMenuItem(
                              value: 15,
                              child: Text("15 min"),
                            ),

                            DropdownMenuItem(
                              value: 30,
                              child: Text("30 min"),
                            ),

                            DropdownMenuItem(
                              value: 60,
                              child: Text("1 hour"),
                            ),

                            DropdownMenuItem(
                              value: 120,
                              child: Text("2 hours"),
                            ),

                            DropdownMenuItem(
                              value: 1440,
                              child: Text("1 day"),
                            ),
                          ],
                          onChanged: (value) {
                            setDialogState(() {
                              dueMinutes = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {

                    final success =
                        await provider.addTask(
                      executiveId: executiveId,
                      title: titleController.text,
                      description:
                          descriptionController.text,
                      dueMinutes: dueMinutes,
                    );

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    if (!success) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content:
                              Text("Unable to create task"),
                        ),
                      );
                    }
                  },
                  child: const Text("Create"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}