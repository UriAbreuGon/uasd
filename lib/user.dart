import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'change_password.dart'; // Importar la página de cambio de contraseña

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final AuthService _authService = AuthService();
  late Future<Map<String, dynamic>> _userData;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  /// Método para obtener los datos del usuario
  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      final userData = await _authService.fetchUserData(); // Llamada a AuthService
      return userData;
    } catch (error) {
      throw Exception('Error al obtener los datos del usuario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Usuario'),
        backgroundColor: Colors.blueAccent, // Color de la AppBar
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No se encontró información del usuario.'));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfo('Nombre', user['nombre']),
                _buildUserInfo('Apellido', user['apellido']),
                _buildUserInfo('Correo', user['email']),
                _buildUserInfo('Nombre de usuario', user['username']),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la página de cambio de contraseña
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(),
                      ),
                    );
                  },
                  child: Text('Cambiar Contraseña'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Método auxiliar para construir las secciones de información
  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.black87),
              overflow: TextOverflow.ellipsis, // Si el texto es largo, se recorta
            ),
          ),
        ],
      ),
    );
  }
}
