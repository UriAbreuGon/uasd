
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(UASDApp());
}

class UASDApp extends StatelessWidget {
  const UASDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UASD App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'), // Ruta de la imagen
              fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
            ),
           ),
            child: Center(
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
             SizedBox(height: 40),
               ElevatedButton(
                onPressed: () {
                 Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => EstadoDeudaScreen()), // Actualizado a la nueva clase
                
                  );
                 },
                   
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Color del botón
                  ),
                  child: Text('Acceder'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 }
 
 
class EstadoDeudaScreen extends StatefulWidget {
  @override
  _EstadoDeudaScreenState createState() => _EstadoDeudaScreenState();
}

class _EstadoDeudaScreenState extends State<EstadoDeudaScreen> {
  double totalPagar = 10000.00; // Monto inicial de la deuda
  double porcentajeSeleccionado = 25.0; // Porcentaje inicial
  double pagoMensual = 0; // Monto mensual calculado

  @override
  void initState() {
    super.initState();
    _calcularPagoMensual(); // Calcular el pago inicial
  }

  void _calcularPagoMensual() {
    setState(() {
      pagoMensual = (totalPagar * porcentajeSeleccionado) / 100; // Cálculo dinámico
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estado de Deuda'),
        backgroundColor: const Color.fromARGB(255, 65, 131, 206),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Tu Estado de Cuenta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 13, 13, 14),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),

            // Mostrar el monto total sin permitir su edición
            Row(
              children: [
                Text(
                  'Total a Pagar (RD\$):',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Text(
                  'RD\$ ${totalPagar.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Selección de porcentaje
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Porcentaje a pagar por mes:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                DropdownButton<double>(
                  value: porcentajeSeleccionado,
                  items: [25.0, 30.0]
                      .map((porcentaje) => DropdownMenuItem<double>(
                            value: porcentaje,
                            child: Text('$porcentaje%'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      porcentajeSeleccionado = value!;
                      _calcularPagoMensual();
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Tabla de montos mensuales
            Table(
              border: TableBorder.all(color: Colors.black, width: 1),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Mes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Monto',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ...['Enero', 'Febrero', 'Marzo'].map((mes) {
                  return TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text(mes)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text('RD\$ ${pagoMensual.toStringAsFixed(2)}'),
                      ),
                    ),
                  ]);
                }).toList(),
              ],
            ),
            SizedBox(height: 20),

            // Botón para pagar ahora
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PagoPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Botón rojo
              ),
              child: Text(
                'Pagar Ahora',
                style: TextStyle(color: Colors.white), // Texto blanco
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class PagoPage extends StatefulWidget {
  const PagoPage({super.key});

  @override
  _PagoPageState createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numeroTarjetaController = TextEditingController();
  final TextEditingController _fechaExpiracionController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  
  // Controladores para datos modificables
  final TextEditingController _nombreController = TextEditingController(text: '');
  final TextEditingController _cedulaController = TextEditingController(text: '');
  final TextEditingController _montoController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Procesar Pago'),
        backgroundColor: const Color.fromARGB(255, 69, 147, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Información editable del usuario
              _buildTextField(
                controller: _nombreController,
                label: 'Nombre',
                hint: 'Ingrese su nombre',
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _cedulaController,
                label: 'Cédula',
                hint: 'Ingrese su cédula',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _montoController,
                label: 'Monto a Pagar (RD\$)',
                hint: 'Ingrese el monto',
                keyboardType: TextInputType.number,
              ),
              Divider(color: Colors.grey),

              // Información fija del servicio
              _buildInfoText('Servicio: Pago Inscripción'),
              Divider(color: Colors.grey),

              // Campos de pago
              _buildTextField(
                controller: _numeroTarjetaController,
                label: 'Número de Tarjeta',
                hint: '1234 5678 9012 3456',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 16) {
                    return 'Por favor ingrese un número de tarjeta válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _fechaExpiracionController,
                      label: 'Fecha Expiración (MM/AA)',
                      hint: 'MM/AA',
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la fecha de expiración';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: _cvcController,
                      label: 'CVC / CVV',
                      hint: '123',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length != 3) {
                          return 'Por favor ingrese un código CVC válido';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Botón de pago
              _buildStyledButton(
               label: 'Pagar Servicio',
               onPressed: () {
                 if (_formKey.currentState?.validate() ?? false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                  builder: (context) => BauchePage(
                   nombre: _nombreController.text,
                   cedula: _cedulaController.text,
                   monto: _montoController.text,
          ),
        ),
      );
    }
  },
  color: const Color.fromARGB(255, 57, 236, 87),
),

              // Botón para regresar
              _buildStyledButton(
                label: 'Retornar',
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para textos informativos
  Widget _buildInfoText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Widget para campos de texto
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: const Color.fromARGB(255, 64, 162, 241), width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  // Widget para botones estilizados
  Widget _buildStyledButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
class BauchePage extends StatelessWidget {
  final String nombre;
  final String cedula;
  final String monto;

  const BauchePage({
    super.key,
    required this.nombre,
    required this.cedula,
    required this.monto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comprobante de Pago'),
        backgroundColor: const Color.fromARGB(255, 69, 147, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Comprobante de Pago',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              'Nombre: $nombre',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Cédula: $cedula',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Monto Pagado: RD\$ $monto',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
             Icon(Icons.check_circle, color: Colors.green, size: 80),
             SizedBox(height: 20),
            Text(
              '¡Pago realizado con éxito!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volver a la página anterior
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

