import 'package:flutter/material.dart';
import 'package:proyecto/bd_utils.dart';
import 'package:proyecto/interfaces/login.dart' as loginPage;
import 'package:proyecto/interfaces/adminInterface.dart' as adminInterface;

/// LOGIN ADMINISTRADOR ///
/// HU1: Como administrador quiero poder acceder a la aplicación con mi usuario y mi contraseña

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Admin Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginAdminPage(),
    );
  }
}

class LoginAdminPage extends StatefulWidget {
  @override
  _LoginAdminPageState createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  // CONTROLADORES PARA TRABAJAR CON LOS CAMPOS
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true; // Controla si el texto está oculto o visible

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Row(
          children: [
            // Parte izquierda con la imagen de fondo
            Expanded(
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/colegio.jpg'), // Imagen de fondo
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Parte derecha con el formulario
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(52.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo en la parte superior
                    Center(
                      child: Image.asset(
                        'assets/logo.png', // Logo de San Juan de Dios
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        '¡Hola de nuevo!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Por favor, ingresa tus credenciales',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    // Campo de usuario
                    TextField(
                      controller: userController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Campo de contraseña
                    TextField(
                      obscureText: _isObscure,
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            }); 
                          },
                        ),  
                      ),
                    ),
                    SizedBox(height: 10),
                    // Olvido de contraseña
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Acción de recuperar contraseña
                        },
                        child: Text(
                          '¿Has olvidado la contraseña?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    // Botón de iniciar sesión
                    Center(
                      child: SizedBox(
                        width: 350,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (userController.text.isEmpty || passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('El campo de usuario y contraseña no pueden ser vacíos.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (await loginAdmin(userController.text, passwordController.text) == false) { // Si del check de la BD se recupera false
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Usuario o contraseña incorrectos.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Inicio de sesión correcto.'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => adminInterface.adminInterface(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                          ),
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Botón de atrás
                    Center(
                      child: SizedBox(
                        width: 350,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => loginPage.StudentListPage(),
                                ),
                              );
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
              ),
            ),
          ],
        ),
      ),
    );
  }
  
 
}