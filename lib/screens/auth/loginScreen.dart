import 'package:basic_store_app/model/extension.dart';
import 'package:basic_store_app/model/loginModel.dart';
import 'package:basic_store_app/remote/apiService.dart';
import 'package:basic_store_app/screens/auth/registerScreen.dart';
import 'package:basic_store_app/screens/home.dart';
import 'package:basic_store_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool obscureText = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await ApiService.api.login(
        LoginModel(
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      if (!mounted) return;
      context.showSnackBar(message: e.toString(), color: Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 40), // مسافة من فوق
          Text(
            'Welcome Back!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // لون أساسي للأبلكيشن
            ),
          ),
          const SizedBox(height: 10),
          const Text("Sign in to continue shopping"),
          const SizedBox(height: 30),
          // شكل الـ Avatar مع ظل خفيف
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 50,
                color: Colors.blueAccent,
              ),
            ),
          ),
          const SizedBox(height: 20),
          customText(
            textHint: 'Enter your email',
            textLabel: 'Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.person),
            validator: (value) {
              if (value == null || !value.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          customText(
            textHint: 'Enter your password',
            textLabel: 'Password',
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            prefixIcon: Icon(Icons.password),
            obsecureText: obscureText,
            suffixIcon: IconButton(
              onPressed: () => setState(() => obscureText = !obscureText),
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            ),
            validator: (value) =>
                (value != null && value.length < 6) ? 'Too short' : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, // الزرار يأخذ العرض بالكامل شكله أفضل
            child: ElevatedButton(
              // if loading, disable the button to prevent multiple submissions
              onPressed: () {
                _isLoading ? null : _login();
              },
              child: const Text('Login'),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
