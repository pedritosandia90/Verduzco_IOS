import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggedIn = false;
  String _loggedInUsername = '';
  String? _errorText;

  Map<String, String> _userCredentials = {};

  // Método para mostrar el formulario de registro
  void _showRegistrationForm() {
    setState(() {
      _errorText = null;
      _isLoggedIn = false;
      _usernameController.clear();
      _passwordController.clear();
    });
  }

  // Método para realizar el inicio de sesión
  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (_userCredentials.containsKey(username) &&
        _userCredentials[username] == password) {
      setState(() {
        _isLoggedIn = true;
        _loggedInUsername = username;
        _errorText = null;
      });
    } else {
      setState(() {
        _errorText = 'Credenciales incorrectas. Por favor, inténtalo de nuevo.';
      });
    }
  }

  // Método para registrar un nuevo usuario
  void _register() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (!_userCredentials.containsKey(username)) {
      setState(() {
        _userCredentials[username] = password;
        _isLoggedIn = true;
        _loggedInUsername = username;
        _errorText = null;
      });
    } else {
      setState(() {
        _errorText = 'El usuario ya existe. Por favor, inicia sesión.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login App'),
      ),
      body: _isLoggedIn
          ? WelcomePage(
              username: _loggedInUsername,
              onLogout: () {
                // Cerrar sesión y volver al formulario de inicio de sesión
                setState(() {
                  _isLoggedIn = false;
                });
              },
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Iniciar sesión'),
                    ),
                    ElevatedButton(
                      onPressed: _register,
                      child: Text('Registrarse'),
                    ),
                    if (_errorText != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorText!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final String username;
  final VoidCallback onLogout;

  WelcomePage({required this.username, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('¡Bienvenido, $username!'),
            ElevatedButton(
              onPressed: onLogout,
              child: Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
