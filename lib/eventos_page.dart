import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:intl/intl.dart';  // Para el formato de fecha

class EventosPage extends StatefulWidget {
  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final AuthService _authService = AuthService();
  late Future<List<dynamic>> _eventos;

  @override
  void initState() {
    super.initState();
    _eventos = _authService.fetchData('https://uasdapi.ia3x.com/eventos');
  }

  // Método para formatear la fecha
  String _formatearFecha(String fecha) {
    final DateTime parsedDate = DateTime.parse(fecha);
    final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
        backgroundColor: Colors.blueAccent, // Estilo de AppBar
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _eventos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay eventos disponibles.'));
          }

          final eventos = snapshot.data!;
          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];

              // Formatear la fecha
              String fechaFormateada = _formatearFecha(evento['fechaEvento']);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(
                    evento['titulo'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lugar: ${evento['lugar']}',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Fecha: $fechaFormateada',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Coordenadas: ${evento['coordenadas']}',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(evento['titulo']),
                        content: SingleChildScrollView(
                          child: Text(evento['descripcion']),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cerrar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
