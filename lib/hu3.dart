import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Estudiantes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListPage(),
    );
  }
}

// Tipo estudiante (definida en una clase aparte del frontend cuando se junte)
class Student {
  final String name;
  final String surname;
  final String dni;

  Student({required this.name, required this.surname, required this.dni});
}

// Página de lista de estudiantes
class StudentListPage extends StatelessWidget {
  final List<Student> students = List.generate(20, (index) => Student(name: 'Estudiante $index', surname: 'Apellido $index', dni: '${10000000 + index}'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 625,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lista de Estudiantes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Selecciona un estudiante para modificar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 30),
              // Lista de estudiantes en un Expanded para que sea scrollable
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text('${student.name} ${student.surname}'),
                        subtitle: Text('DNI: ${student.dni}'),
                        onTap: () {
                          // Navegar a la página de modificación del estudiante
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentModificationPage(student: student),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página de modificación de estudiante
class StudentModificationPage extends StatefulWidget {
  final Student student; // Recibimos el estudiante seleccionado

  StudentModificationPage({required this.student});

  @override
  _StudentModificationPageState createState() =>
      _StudentModificationPageState();
}

class _StudentModificationPageState extends State<StudentModificationPage> {
  // Valores iniciales según los que tuviese el estudiante
  bool pictogramsView = false;
  bool imagesView = false;
  bool textView = false;
  bool audiovisualContentView = false;

  String passwordType = "alphanumeric"; // Valor anterior para la selección de contraseña

  // Controladores para los campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController dniController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicializar los campos con los datos del estudiante
    nameController.text = widget.student.name;
    surnameController.text = widget.student.surname;
    dniController.text = widget.student.dni;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 625,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Modificación de estudiante',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Ingresa los datos del estudiante',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 30),
              // Formulario
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campos de texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: surnameController,
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: dniController,
                          decoration: InputDecoration(
                            labelText: 'DNI',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        // Imagen de perfil
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Imagen de perfil',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Sube una imagen',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 40),
                  // Opciones de selección
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Opciones de visualización
                        Text(
                          'Selecciona cómo ve la aplicación el estudiante',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        CheckboxListTile(
                          title: Text('Pictogramas'),
                          value: pictogramsView,
                          onChanged: (bool? value) {
                            setState(() {
                              pictogramsView = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Imágenes'),
                          value: imagesView,
                          onChanged: (bool? value) {
                            setState(() {
                              imagesView = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Texto'),
                          value: textView,
                          onChanged: (bool? value) {
                            setState(() {
                              textView = value ?? false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Contenido Audiovisual'),
                          value: audiovisualContentView,
                          onChanged: (bool? value) {
                            setState(() {
                              audiovisualContentView = value ?? false;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        // Opciones de tipo de contraseña
                        Text(
                          'Selecciona el tipo de contraseña del estudiante',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        RadioListTile(
                          title: Text('Pictogramas'),
                          value: 'pictograms',
                          groupValue: passwordType,
                          onChanged: (String? value) {
                            setState(() {
                              passwordType = value!;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Imágenes'),
                          value: 'images',
                          groupValue: passwordType,
                          onChanged: (String? value) {
                            setState(() {
                              passwordType = value!;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text('Alfanumérica'),
                          value: 'alphanumeric',
                          groupValue: passwordType,
                          onChanged: (String? value) {
                            setState(() {
                              passwordType = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (passwordType == 'images') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ImagePasswordPage()),
                            );
                          } else if (passwordType == 'alphanumeric') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AlphanumericPasswordPage()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange[400],
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Atrás',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página para la contraseña con imágenes
class ImagePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 625,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 70.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alta de estudiante',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Creación de contraseña de imágenes',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              // Área para subir y seleccionar imágenes
              // En caso de no haber modificado el tipo de contraseña aparece por defecto la anterior
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 40,
                        color: Colors.grey,
                      ),
                      Text(
                        'Sube las imágenes',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Selecciona las imágenes que formarán parte de la contraseña en el orden correcto:',
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              // Grid de imágenes
              SizedBox(
                height: 275, // Altura total
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: List.generate(6, (index) {
                    return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          'URL_DE_EJEMPLO_IMAGEN',
                          fit: BoxFit.cover,
                        ),
                      );
                  }),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          // Lógica para guardar al estudiante en la BD
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange[400],
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Atrás',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página para la contraseña alfanumérica
class AlphanumericPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: Center(
        child: Container(
          width: 740,
          height: 625,
          padding: EdgeInsets.all(70.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Alta de estudiante',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Creación de contraseña alfanumérica',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              Spacer(),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Repetir contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () {
                          // Lógica para guardar al estudiante en la BD
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Guardar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange[400],
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                        ),
                        child: Text(
                          'Atrás',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
