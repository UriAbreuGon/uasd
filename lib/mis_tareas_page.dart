import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:url_launcher/url_launcher.dart';  // Importa esta librería

class MisTareasPage extends StatefulWidget {
  @override
  _MisTareasPageState createState() => _MisTareasPageState();
}

class _MisTareasPageState extends State<MisTareasPage> {
  final AuthService _authService = AuthService();
  late Future<List<dynamic>> _tareas;

  @override
  void initState() {
    super.initState();
    _tareas = _authService.fetchData('https://uasdapi.ia3x.com/tareas');
  }

  // Función para abrir el enlace del aula virtual
  _launchURL() async {
    const url = 'https://uasd.edu.do/uasd-virtual/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se puede abrir el enlace $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis Tareas',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: Column(
        children: <Widget>[
          // Botón para acceder al aula virtual
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _launchURL,
              child: Text('Acceder al Aula Virtual UASD'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Cambia el color si lo deseas
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
          // Aquí va el FutureBuilder con la lista de tareas
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _tareas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay tareas disponibles.'));
                }

                final tareas = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: tareas.length,
                  itemBuilder: (context, index) {
                    final tarea = tareas[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          tarea['titulo'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        subtitle: Text(
                          'Vence: ${DateTime.parse(tarea['fechaVencimiento']).toLocal().toString().substring(0, 16)}',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        trailing: Icon(
                          tarea['completada']
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: tarea['completada'] ? Colors.green : Colors.red,
                          size: 30,
                        ),
                        onTap: () {
                          // Navegar a una nueva página de detalles con toda la información de la tarea
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleTareaPage(tarea: tarea),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetalleTareaPage extends StatelessWidget {
  final dynamic tarea;

  DetalleTareaPage({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Tarea'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Título: ${tarea['titulo']}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Descripción: ${tarea['descripcion']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Fecha de vencimiento: ${DateTime.parse(tarea['fechaVencimiento']).toLocal().toString().substring(0, 16)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              'Completada: ${tarea['completada'] ? "Sí" : "No"}',
              style: TextStyle(fontSize: 16, color: tarea['completada'] ? Colors.green : Colors.red),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
