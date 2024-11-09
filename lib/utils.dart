import 'package:proyecto/Student.dart';
import 'package:proyecto/bd.dart';

String user = 'admin';
String password = 'admin';

bool loginAdmin(String user, String password){
  return user == 'admin' && password == 'admin';
}

Future<bool> loginStudent(String user, String password) async{
	return await ColegioDatabase.instance.loginStudent(user, password);
}

Future<bool> login(String user, String password) async{
  if(user == "admin"){
    return loginAdmin(user, password);
  }
  else {
    return await loginStudent(user, password);
  }
}

Future<bool> registerStudent(String user, name, String surname, String password, 
  String image, String typePassword, int interfaceIMG,
	int interfacePIC, int interfaceTXT) async{

  if (user == "admin") {
    return false;
  }
  
	Student student = Student(password: password, name: name, user: user, surname:surname, 
    image: image, typePassword: typePassword, interfaceIMG: interfaceIMG,
		interfacePIC: interfacePIC, interfaceTXT: interfaceTXT);

	return await ColegioDatabase.instance.registerStudent(student);

}

Future<bool> asignLoginType(String user, String typePassword) async {
	return await ColegioDatabase.instance.asignLoginType(user, typePassword);;
}


Future<bool> modifyNameStudent(String user, String newName) async{
	return await ColegioDatabase.instance.modifyStudent(user, "name", newName);
}

Future<bool> modifyPasswordStudent(String user, String newPassword) async{
	return await ColegioDatabase.instance.modifyStudent(user, "password", newPassword);
}

Future<bool> modifyCompleteStudent(String user, String name, String? surname, String password, 
  String photo, String typePassword, int interfaceIMG, int interfacePIC, int interfaceTXT) async{
  return await ColegioDatabase.instance.modifyCompleteStudent(user, name, surname, password, photo, typePassword, interfaceIMG, interfacePIC, interfaceTXT);
}