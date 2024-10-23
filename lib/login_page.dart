import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'home_page.dart'; // Importar o arquivo correto

class LoginPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  LoginPage({Key? key, required this.themeNotifier}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    // ... (mesmo código do método _login)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(),
          _buildOverlay(),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://registrodiario.com.br/images/noticias/2953/65f7ada85ca0c694ee59c6300ae357d6.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black54,
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(),
              SizedBox(height: 24),
              _buildEmailField(),
              SizedBox(height: 16),
              _buildPasswordField(),
              SizedBox(height: 24),
              _buildLoginButton(),
              SizedBox(height: 16),
              _buildForgotPasswordButton(),
              SizedBox(height: 16),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Login',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Username',
        prefixIcon: Icon(Icons.person, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: true,
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login,
      child: Text('Entrar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        // Navegar para a tela de recuperação de senha
      },
      child: Text(
        'Recuperar Senha',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        // Navegar para a tela de registro
      },
      child: Text('Registrar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
    );
  }
}
