import 'package:flutter/material.dart';
import 'auth_service.dart'; // Asegúrate de que el AuthService esté correctamente importado

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  // Función para manejar el cambio de contraseña
  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Resetear el error al intentar cambiar la contraseña
    });

    try {
      // Llamada al servicio de cambio de contraseña
      await AuthService().changePassword(
        _oldPasswordController.text,
        _newPasswordController.text,
        _confirmPasswordController.text,
      );

      // Si el cambio de contraseña es exitoso, mostrar mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contraseña cambiada con éxito')),
      );

      // Limpiar los campos después de un cambio exitoso
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
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
        title: Text('Cambiar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña Actual',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar Nueva Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else ...[
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Cambiar Contraseña'),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
