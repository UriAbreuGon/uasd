import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreseleccionScreen extends StatefulWidget {
  @override
  _PreseleccionScreenState createState() => _PreseleccionScreenState();
}

class _PreseleccionScreenState extends State<PreseleccionScreen> {
  List materiasDisponibles = [];
  List seleccionadas = [];
  bool confirmado = false;

  @override
  void initState() {
    super.initState();
    obtenerMateriasDisponibles();
  }

  Future<void> obtenerMateriasDisponibles() async {
    final url = 'https://uasdapi.ia3x.com/materias_disponibles';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjM2IiwibmJmIjoxNzMyODM2MzY0LCJleHAiOjE3MzI4Mzk5NjQsImlhdCI6MTczMjgzNjM2NH0.mjO8rinkc68gEmmzA9uDXCqGJLUKWKHu70dswuf0sG0'},
    );

    if (response.statusCode == 200) {
      setState(() {
        materiasDisponibles = json.decode(response.body);
      });
    } else {
      print('Error al obtener materias: ${response.statusCode}');
    }
  }

  Future<void> confirmarSeleccion() async {
    final url = 'https://uasdapi.ia3x.com/preseleccionar_materia';

    for (var materia in seleccionadas) {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjM2IiwibmJmIjoxNzMyODM2MzY0LCJleHAiOjE3MzI4Mzk5NjQsImlhdCI6MTczMjgzNjM2NH0.mjO8rinkc68gEmmzA9uDXCqGJLUKWKHu70dswuf0sG0',
          'Content-Type': 'application/json',
        },
        body: json.encode(materia),
      );

      if (response.statusCode != 200) {
        print('Error al confirmar: ${response.statusCode}');
      }
    }

    setState(() {
      confirmado = true;
    });
  }

  void cancelarSeleccion() {
    setState(() {
      seleccionadas.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (confirmado) {

      return Scaffold(
        backgroundColor: Color(0xFF012169),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/uasd_logo.png',
                width: 120,
              ),
              SizedBox(height: 20),
              Text(
                'Gracias por seleccionar materia,',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Bienvenido a la UASD',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Preselección de Materias'),
        backgroundColor: Color(0xFF012169),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: materiasDisponibles.length,
              itemBuilder: (context, index) {
                final materia = materiasDisponibles[index];
                return ListTile(
                  title: Text(materia['nombre']),
                  subtitle: Text('Código: ${materia['codigo']}'),
                  trailing: seleccionadas.contains(materia)
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      if (seleccionadas.contains(materia)) {
                        seleccionadas.remove(materia);
                      } else {
                        seleccionadas.add(materia);
                      }
                    });
                  },
                );
              },
            ),
          ),
          if (seleccionadas.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Materias Seleccionadas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: seleccionadas.map((materia) {
                return ListTile(
                  title: Text(materia['nombre']),
                  subtitle: Text('Código: ${materia['codigo']}'),
                );
              }).toList(),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: confirmarSeleccion,
                child: Text('Confirmar Selección'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF013369),
                ),
              ),
              ElevatedButton(
                onPressed: cancelarSeleccion,
                child: Text('Cancelar Selección'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
