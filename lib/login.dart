import 'package:flutter/material.dart';
import 'package:emartsystem/home.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text("Welcome Back",style: TextStyle(fontSize: 24,
              fontWeight: FontWeight.bold,),),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      // Handle login logic here
                      // Navigate to the HomePage on successful login
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Homepage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 18,color: Colors.white
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Add your "Forgot Password" logic here
                      },
                      child: const Text("Forgot Password?"),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add your "Create Account" logic here
                      },
                      child: const Text("Create Account"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
