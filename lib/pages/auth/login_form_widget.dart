// lib/pages/auth/login_form_widget.dart
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class LoginFormWidget extends StatefulWidget {
  final bool isLoginMode;
  final Future<void> Function(String email, String password) onSubmit;
  final VoidCallback? onToggleToSignUp;
  final VoidCallback? onToggleToLogin;

  const LoginFormWidget({
    super.key,
    required this.isLoginMode,
    required this.onSubmit,
    this.onToggleToSignUp,
    this.onToggleToLogin,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // New controller
  bool _isLoadingInsideForm = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Dispose new controller
    super.dispose();
  }

  Future<void> _trySubmit() async {
    final String mode = widget.isLoginMode ? "Login" : "Sign Up";
    dev.log('LoginFormWidget: _trySubmit called for $mode');
    if (!_formKey.currentState!.validate()) {
      dev.log('LoginFormWidget: Form validation failed for $mode.');
      return;
    }
    setState(() => _isLoadingInsideForm = true);
    try {
      await widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text.trim(), // Only password needed for onSubmit callback
      );
    } catch (e) {
      dev.log('LoginFormWidget: Error propagated from onSubmit: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingInsideForm = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    dev.log('LoginFormWidget: Build. isLoginMode: ${widget.isLoginMode}');
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email Address",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email.';
              }
              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              prefixIcon: const Icon(Icons.lock_outline),
            ),
            obscureText: true,
            textInputAction: widget.isLoginMode ? TextInputAction.done : TextInputAction.next, // Next for signup
            onFieldSubmitted: widget.isLoginMode ? (_) => _isLoadingInsideForm ? null : _trySubmit() : null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password.';
              }
              if (!widget.isLoginMode && value.length < 6) {
                return 'Password must be at least 6 characters long.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // --- Confirm Password Field (Only for Sign Up) ---
          if (!widget.isLoginMode)
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _isLoadingInsideForm ? null : _trySubmit(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password.';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),
          if (!widget.isLoginMode) const SizedBox(height: 16), // Spacing after confirm password

          const SizedBox(height: 8), // Adjusted general spacing
          _isLoadingInsideForm
              ? const Center(child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: SizedBox(width:24, height: 24, child: CircularProgressIndicator(strokeWidth: 3,))
                ))
              : ElevatedButton(
                  onPressed: _trySubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  child: Text(widget.isLoginMode ? 'Login' : 'Sign Up'),
                ),
          const SizedBox(height: 12),
          if (widget.isLoginMode && widget.onToggleToSignUp != null)
            TextButton(
              onPressed: _isLoadingInsideForm ? null : widget.onToggleToSignUp,
              child: const Text("Don't have an account? Sign Up"),
            ),
          if (!widget.isLoginMode && widget.onToggleToLogin != null)
             TextButton(
              onPressed: _isLoadingInsideForm ? null : widget.onToggleToLogin,
              child: const Text('Already have an account? Login'),
            ),
        ],
      ),
    );
  }
}