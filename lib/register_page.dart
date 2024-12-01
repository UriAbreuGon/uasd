import 'package:flutter/material.dart';
import 'auth_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Validación de los campos de entrada
  bool _validateInputs() {
    return _nameController.text.isNotEmpty &&
           _lastNameController.text.isNotEmpty &&
           _usernameController.text.isNotEmpty &&
           _passwordController.text.isNotEmpty &&
           _emailController.text.isNotEmpty;
  }

  // Función para registrar al usuario
  Future<void> _register() async {
    if (!_validateInputs()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.register({
        'nombre': _nameController.text,
        'apellido': _lastNameController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'email': _emailController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro exitoso')),
      );

      // Después del registro exitoso, redirige al login o página principal
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Color(0xFF003366), // Azul UASD
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campos de entrada con diseño estilizado
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white.withOpacity(0.7),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.black), // Color del texto negro
            ),
            SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Apellido',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white.withOpacity(0.7),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.black), // Color del texto negro
            ),
            SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white.withOpacity(0.7),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.black), // Color del texto negro
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white.withOpacity(0.7),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              obscureText: true,
              style: TextStyle(color: Colors.black), // Color del texto negro
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white.withOpacity(0.7),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.black), // Color del texto negro
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF003366), // Azul UASD
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Registrarse',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
