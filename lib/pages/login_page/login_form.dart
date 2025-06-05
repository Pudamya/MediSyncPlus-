// import 'package:flutter/material.dart';
// import 'dart:developer' as dev;

// class LoginForm extends StatefulWidget {
//   final bool isLoginMode;
//   // This callback is triggered when the form's internal submit button is pressed.
//   // It passes the email, password, and whether it was a login attempt.
//   final Future<void> Function(String email, String password, bool isLoginAttempt) onSubmitAttempt;
//   final VoidCallback onToggleMode; // Callback to toggle login/signup mode in the parent (RoleLoginPage)

//   const LoginForm({
//     super.key,
//     required this.isLoginMode,
//     required this.onSubmitAttempt,
//     required this.onToggleMode,
//   });

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   final _formKey = GlobalKey<FormState>(); // Key for THIS form's validation
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoadingInsideForm = false; // Loading state specifically for this form's submit button

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   // This method is called when the "Login" or "Sign Up" button INSIDE this widget is pressed.
//   Future<void> _trySubmit() async {
//     dev.log('LoginForm: _trySubmit called. isLoginMode: ${widget.isLoginMode}');
//     if (!_formKey.currentState!.validate()) {
//       dev.log('LoginForm: Form validation failed.');
//       return; // Don't proceed if validation fails
//     }
//     // If validation passes, form.save() is not strictly needed here as we use controllers.

//     setState(() => _isLoadingInsideForm = true);

//     try {
//       // Call the callback provided by the parent (RoleLoginPage)
//       await widget.onSubmitAttempt(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//         widget.isLoginMode, // Pass current mode (login or signup)
//       );
//     } catch (e) {
//       // Errors from onSubmitAttempt will be caught here if they aren't handled by the parent.
//       // However, RoleLoginPage is designed to handle and display errors.
//       dev.log('LoginForm: Error occurred during or after onSubmitAttempt callback: $e');
//     } finally {
//       // Ensure loading state is reset even if an error occurs in the callback.
//       if (mounted) {
//         setState(() => _isLoadingInsideForm = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     dev.log('LoginForm: Build. isLoginMode: ${widget.isLoginMode}');
//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // Takes up minimum vertical space
//         crossAxisAlignment: CrossAxisAlignment.stretch, // Makes children (like ElevatedButton) stretch horizontally
//         children: [
//           TextFormField(
//             controller: _emailController,
//             decoration: InputDecoration(
//               labelText: "Email Address",
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
//               prefixIcon: const Icon(Icons.email_outlined),
//             ),
//             keyboardType: TextInputType.emailAddress,
//             textInputAction: TextInputAction.next,
//             validator: (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Please enter your email.';
//               }
//               // Basic email format validation
//               if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
//                 return 'Please enter a valid email address.';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: _passwordController,
//             decoration: InputDecoration(
//               labelText: "Password",
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
//               prefixIcon: const Icon(Icons.lock_outline),
//               // You could add a suffixIcon here to toggle password visibility
//             ),
//             obscureText: true,
//             textInputAction: TextInputAction.done,
//             onFieldSubmitted: (_) => _isLoadingInsideForm ? null : _trySubmit(), // Allow submitting with keyboard "done"
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your password.';
//               }
//               if (!widget.isLoginMode && value.length < 6) { // Password length check only for sign-up
//                 return 'Password must be at least 6 characters long.';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 24),
//           // Submit button for this form
//           _isLoadingInsideForm
//               ? const Center(child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 14.0), // Match button's typical padding
//                   child: SizedBox(width:24, height: 24, child: CircularProgressIndicator(strokeWidth: 3,))
//                 ))
//               : ElevatedButton(
//                   onPressed: _trySubmit, // Calls the internal _trySubmit method
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 14.0),
//                     // Styling can be inherited from Theme or set here
//                   ),
//                   child: Text(widget.isLoginMode ? 'Login' : 'Sign Up'),
//                 ),
//           const SizedBox(height: 12),
//           // Button to toggle between Login and Sign Up modes
//           TextButton(
//             onPressed: _isLoadingInsideForm ? null : widget.onToggleMode, // Disable while form is submitting
//             child: Text(
//               widget.isLoginMode
//                   ? "Don't have an account? Sign Up"
//                   : 'Already have an account? Login',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





















import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class LoginForm extends StatefulWidget {
  final bool isLoginMode;
  final Future<void> Function(String email, String password, bool isLoginAttempt) onSubmitAttempt;
  final VoidCallback onToggleMode;

  const LoginForm({
    super.key,
    required this.isLoginMode,
    required this.onSubmitAttempt,
    required this.onToggleMode,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoadingInsideForm = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _trySubmit() async {
    dev.log('LoginForm: _trySubmit called. isLoginMode: ${widget.isLoginMode}');
    if (!_formKey.currentState!.validate()) {
      dev.log('LoginForm: Form validation failed.');
      return;
    }
    setState(() => _isLoadingInsideForm = true);
    try {
      await widget.onSubmitAttempt(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        widget.isLoginMode,
      );
    } catch (e) {
      dev.log('LoginForm: Error propagated from onSubmitAttempt: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingInsideForm = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    dev.log('LoginForm: Build. isLoginMode: ${widget.isLoginMode}');
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
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _isLoadingInsideForm ? null : _trySubmit(),
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
          const SizedBox(height: 24),
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
          TextButton(
            onPressed: _isLoadingInsideForm ? null : widget.onToggleMode,
            child: Text(
              widget.isLoginMode
                  ? "Don't have an account? Sign Up"
                  : 'Already have an account? Login',
            ),
          ),
        ],
      ),
    );
  }
}