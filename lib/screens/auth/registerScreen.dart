import 'package:basic_store_app/model/extension.dart';
import 'package:basic_store_app/model/registerModel.dart';
import 'package:basic_store_app/remote/apiService.dart';
import 'package:basic_store_app/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!formKey.currentState!.validate()) return;

    //التجهيز (قفل الكيبورد وتشغيل التحميل)
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.api.registerUser(
        RegisterModel(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );
      if (!mounted) return;
      context.showSnackBar(message: response.message ?? 'Success');
      _clearFeilds();
    } catch (e) {
      if (!mounted) return;
      context.showSnackBar(message: e.toString(), color: Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearFeilds() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
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
          const SizedBox(height: 30), // مسافة علوية بسيطة
          Text(
            'Sign Up Now!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // لون أساسي للأبلكيشن
            ),
          ),
          const Text("Sign Up to create an account"),
          const SizedBox(height: 15),
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
          const SizedBox(height: 10),
          customText(
            textHint: 'Enter your Name',
            textLabel: 'Name',
            controller: nameController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.person),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Name Required' : null,
          ),
          customText(
            textHint: 'Enter your email',
            textLabel: 'Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email),
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
            obsecureText: obscureText,
            prefixIcon: Icon(Icons.password),
            suffixIcon: IconButton(
              onPressed: () => setState(() => obscureText = !obscureText),
              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            ),
            validator: (value) =>
                (value != null && value.length < 6) ? 'Too short' : null,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity, // الزرار يأخذ العرض بالكامل شكله أفضل
            child: ElevatedButton(
              // if loading, disable the button to prevent multiple submissions
              onPressed: _isLoading ? null : _register,

              child: const Text('Sign Up'),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
