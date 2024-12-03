import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AuthService {
  // URLs de los endpoints
  final String _loginUrl = 'https://uasdapi.ia3x.com/login';
  final String _registerUrl = 'https://uasdapi.ia3x.com/crear_usuario';
  final String _forgotPasswordUrl = 'https://uasdapi.ia3x.com/reset_password';
  final String _userInfoUrl = 'https://uasdapi.ia3x.com/info_usuario';
  final String _changePasswordUrl = 'https://uasdapi.ia3x.com/cambiar_password';

  // Cache Manager para guardar el token
  final CacheManager _cacheManager = DefaultCacheManager();

  /// Obtener el authToken desde el cache
  Future<String?> getAuthToken() async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache('authToken');
      if (fileInfo != null) {
        return utf8.decode(await fileInfo.file.readAsBytes());
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener el token: $e');
    }
  }

  /// Realizar el login y guardar el authToken
  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          String authToken = responseData['data']['authToken'];

          // Guardar el token en el cache
          await _cacheManager.putFile(
            'authToken',
            utf8.encode(authToken),
          );
        } else {
          throw Exception('Login fallido: ${responseData['message']}');
        }
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en el login: $e');
    }
  }

  /// Registro de nuevo usuario
  Future<void> register(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse(_registerUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (!responseData['success']) {
          throw Exception('Registro fallido: ${responseData['message']}');
        }
      } else {
        throw Exception('Error en la solicitud de registro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en el registro: $e');
    }
  }

  /// Restablecer contraseña
  Future<Map<String, dynamic>> resetPassword(Map<String, String> data) async {
    try {
      Map<String, String> requestBody = {
        'usuario': data['usuario'] ?? '',
        'email': data['email'] ?? '',
      };

      final response = await http.post(
        Uri.parse(_forgotPasswordUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          return {'message': responseData['message']};
        } else {
          throw Exception('Restablecimiento fallido: ${responseData['message']}');
        }
      } else {
        throw Exception('Error en la solicitud de restablecimiento: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en el restablecimiento de la contraseña: $e');
    }
  }

  /// Cambiar la contraseña
  Future<void> changePassword(String oldPassword, String newPassword, String confirmPassword) async {
    try {
      final authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception("No authToken encontrado. Por favor, inicie sesión.");
      }

      Map<String, String> requestBody = {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };

      final response = await http.post(
        Uri.parse(_changePasswordUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (!responseData['success']) {
          throw Exception('Cambio de contraseña fallido: ${responseData['message']}');
        }
        print("Contraseña cambiada con éxito");
      } else {
        throw Exception('Error en la solicitud de cambio de contraseña: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en el cambio de contraseña: $e');
    }
  }

  /// Cerrar sesión eliminando el authToken del cache
  Future<void> logout() async {
    try {
      await _cacheManager.removeFile('authToken');
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  /// Obtener datos del usuario usando el authToken
  Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception("No authToken encontrado. Por favor, inicie sesión.");
      }

      final response = await http.get(
        Uri.parse(_userInfoUrl),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data'];
        } else {
          throw Exception('Error al obtener los datos del usuario: ${responseData['message']}');
        }
      } else {
        throw Exception('Error al conectar con la API de usuario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener los datos del usuario: $e');
    }
  }

  /// Obtener datos protegidos usando authToken
  Future<List<dynamic>> fetchData(String url) async {
    try {
      final authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception("No authToken encontrado. Por favor, inicie sesión.");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al cargar los datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al cargar los datos: $e');
    }
  }
}
