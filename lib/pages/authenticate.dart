import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourismapp/main.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        // Login existing user
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // Register new user
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // AUTO-CREATE user document in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'displayName': _nameController.text.trim(),
          'phone': '',
          'passport': '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Send verification email
        await userCredential.user!.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') message = 'No user found with this email.';
      else if (e.code == 'wrong-password') message = 'Incorrect password.';
      else if (e.code == 'email-already-in-use') message = 'Account already exists.';
      else if (e.code == 'weak-password') message = 'Password is too weak (min 6 characters).';

      setState(() {
        _errorMessage = message;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const NetworkImage(
                    'https://scth.scene7.com/is/image/scth/dunes-of-arabia-banner-1:crop-1920x1080?defaultImage=dunes-of-arabia-banner-1&wid=1920&hei=1080'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken),
              ),
            ),
          ),

          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset('assets/images/logo.png', height: 60),
                    const SizedBox(height: 30),

                    // Heading
                    Text(
                      _isLogin ? 'Welcome Back' : 'Create Account',
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isLogin
                          ? 'Sign in to book your next adventure'
                          : 'Join Dunes of Arabia today',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Error Message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Authentication Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name field (only for registration)
                          if (!_isLogin)
                            Column(
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
                                    labelStyle: const TextStyle(color: Colors.white70),
                                    prefixIcon: const Icon(Icons.person_outline, color: Colors.white70),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white30),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: AppColors.accentOrange),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),

                          // Email field
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            validator: (val) => val == null || !val.contains('@') ? 'Enter a valid email' : null,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.white70),
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.accentOrange),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            validator: (val) => val == null || val.length < 6 ? 'Minimum 6 characters' : null,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: Colors.white70),
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: AppColors.accentOrange),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Submit Button
                          _isLoading
                              ? const CircularProgressIndicator(color: AppColors.accentOrange)
                              : SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentOrange,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              ),
                              child: Text(
                                _isLogin ? 'SIGN IN' : 'REGISTER',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Toggle between Login/Register
                          TextButton(
                            onPressed: () => setState(() => _isLogin = !_isLogin),
                            child: Text(
                              _isLogin ? "DON'T HAVE AN ACCOUNT? REGISTER" : "ALREADY HAVE AN ACCOUNT? LOGIN",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}