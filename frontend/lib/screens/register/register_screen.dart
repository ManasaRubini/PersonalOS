import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/custom_textfield.dart';
import '../dashboard/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  String _role = "Executive";

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    final success = await auth.register(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      role: _role,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create PersonalOS"),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [

                    const Icon(
                      Icons.psychology_alt,
                      size: 90,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Welcome",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Create your AI Digital Twin",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),

                    const SizedBox(height: 40),

                    CustomTextField(
                      controller: _nameController,
                      hint: "Full Name",
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter your name";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _emailController,
                      hint: "Email",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            !value.contains("@")) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      value: _role,

                      decoration: const InputDecoration(
                        labelText: "Role",
                        prefixIcon: Icon(Icons.work),
                      ),

                      items: const [
                        DropdownMenuItem(
                          value: "Executive",
                          child: Text("Executive"),
                        ),
                        DropdownMenuItem(
                          value: "Tech Lead",
                          child: Text("Tech Lead"),
                        ),
                        DropdownMenuItem(
                          value: "Strategist",
                          child: Text("Strategist"),
                        ),
                      ],

                      onChanged: (value) {
                        setState(() {
                          _role = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      height: 55,

                      child: ElevatedButton(
                        onPressed:
                            auth.isLoading ? null : _register,

                        child: auth.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Create Digital Twin",
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}