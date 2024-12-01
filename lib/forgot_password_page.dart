import 'package:flutter/material.dart';
import 'auth_service.dart'; // Asegúrate de que el import sea correcto

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  String? _responseMessage;

  // Instancia del AuthService
  final AuthService _authService = AuthService();

  // Método para restablecer la contraseña
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = null;  // Limpiar el mensaje previo
    });

    // Obtener los valores del formulario
    String usuario = _usuarioController.text;
    String email = _emailController.text;

    try {
      // Usar el servicio AuthService para hacer el reset de la contraseña
      Map<String, String> data = {
        'usuario': usuario,
        'email': email,
      };

      var response = await _authService.resetPassword(data);

      setState(() {
        _responseMessage = response['message'];
      });
    } catch (e) {
      setState(() {
        _responseMessage = 'Error al conectar con el servidor. Intenta de nuevo.';
      });
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
        title: Text('Restablecer Contraseña'),
        backgroundColor: Color(0xFF003366), // Azul UASD
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Campo para el usuario
                TextFormField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.white.withOpacity(0.7),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su usuario';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 16),
                
                // Campo para el correo electrónico
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.white.withOpacity(0.7),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo electrónico';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
                
                // Botón de restablecer contraseña
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF003366), // Azul UASD
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Restablecer Contraseña',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                
                // Mensaje de respuesta
                if (_responseMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _responseMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
