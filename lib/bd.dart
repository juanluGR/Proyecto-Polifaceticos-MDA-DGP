import 'dart:io';

import 'package:proyecto/Admin.dart';
import 'package:proyecto/Student.dart';
import 'package:proyecto/imgClave.dart';
import 'package:proyecto/Decrypt.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ColegioDatabase{

	static final ColegioDatabase instance = ColegioDatabase._init();

	static Database? _database;
	
	ColegioDatabase._init();


	final String tablaAdmin = 'admin';
	final String tablaStudents = 'students';
	final String tablaImgClave = 'imgClave';
	final String tablaDecrypt = 'decrypt';

	Future<Database> get database async {
		if(_database != null) return _database!;

		_database = await _initDB('colegio.db');
		return _database!;	
	}
	
	Future<Database> _initDB(String filePath) async {

		if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
			sqfliteFfiInit();
			databaseFactory = databaseFactoryFfi;
		}

		final dbPath = await getDatabasesPath();
		final path = join(dbPath, filePath);

		return await openDatabase(path, version: 1, onCreate: _onCreateDB);
	}

	Future _onCreateDB(Database db, int version) async{
		await db.execute('''
		CREATE TABLE $tablaAdmin(
		DNI VARCHAR(9) PRIMARY KEY,
		name VARCHAR(25) NOT NULL,
		surname1 VARCHAR(25) NOT NULL,
		surname2 VARCHAR(25) NOT NULL,
		photo VARCHAR(25) NOT NULL,
		password varchar(25) NOT NULL
		)
		
		''');

		await db.execute('''
			CREATE TABLE $tablaStudents(
			DNI VARCHAR(9) PRIMARY KEY,
			name VARCHAR(25) NOT NULL,
			surname1 VARCHAR(25) NOT NULL,
			surname2 VARCHAR(25) NOT NULL,
			photo VARCHAR(25) NOT NULL,
			password varchar(25) NOT NULL,
			typePassword VARCHAR(25) NOT NULL,
			interfaceIMG TINYINT(1) NOT NULL,
			interfacePIC TINYINT(1) NOT NULL,
			interfaceTXT TINYINT(1) NOT NULL
			)
			
		''');

		await db.execute('''
			CREATE TABLE $tablaImgClave(
			path VARCHAR(25) PRIMARY KEY,
			imgCode VARCHAR(25) NOT NULL
			)
		''');

		await db.execute('''
			CREATE TABLE $tablaDecrypt(
			DNI VARCHAR(9),
			path VARCHAR(25),
			FOREIGN KEY (DNI) REFERENCES $tablaStudents(DNI)
			FOREIGN KEY (path) REFERENCES $tablaImgClave(path)
			PRIMARY KEY (DNI, path)
			)
		''');

		// Inserta un administrador inicial
		await db.insert(tablaAdmin, {
			'DNI': "00000000A",
			'name': "Administrador",
			'surname1': 'admin',
			'surname2': 'admin',
			'password': "admin",
			'photo': 'img/default'
			});
	}

	Future<void> insertAdmin(Admin admin) async{
		final db = await instance.database;
		await db.insert(tablaAdmin, admin.toMap());
	}


	Future<bool> loginAdmin(String dni, String password) async {
		final db = await instance.database;

		final result = await db.query(
			tablaAdmin,
			where: 'DNI = ? AND password = ?',
			whereArgs: [dni, password],
		);

		return result.isNotEmpty;
	}


	Future<bool> loginStudent(String dni, String password) async {
		final db = await instance.database;

		final result = await db.query(
			tablaStudents,
			where: 'DNI = ? AND password = ?',
			whereArgs: [dni, password],
		);

		return result.isNotEmpty;
	}

	Future<bool> registerStudent(Student student) async {
		final db = await instance.database;

		try {
			await db.insert(tablaStudents, student.toMap());
			return true;
		} catch (e) {
			print("Error al insertar el estudiante: $e");
			return false;
		}
	}

	Future<bool> asignLoginType(String dni, String typePassword) async {
		final db = await instance.database;

		try {
			int count = await db.update(
				tablaStudents,
				{'typePassword': typePassword},
				where: 'DNI = ?',
				whereArgs: [dni],
			);

			return count > 0;
		} catch (e) {
			print("Error al asignar loginType: $e");
			return false;
		}
	}

	Future<bool> modifyStudent(String dni, String data, String newData) async{
		final db = await instance.database;

		try {
			int count = await db.update(
				tablaStudents,
				{data: newData},
				where: 'DNI = ?',
				whereArgs: [dni],
			);

			return count > 0;
		} catch (e) {
			print("Error al modificar el dato: $e");
			return false;
		}
	}

	// Obtener datos de un administrador específico por DNI
	Future<Admin?> getAdmin(String dni) async {
		final db = await instance.database;
		final result = await db.query(
			tablaAdmin,
			where: 'DNI = ?',
			whereArgs: [dni],
		);
		if (result.isNotEmpty) {
			return Admin.fromMap(result.first);
		} else {
			return null;
		}
	}

	// Obtener todos los administradores
	Future<List<Student>> getAllStudents() async {
		final db = await instance.database;
		final result = await db.query(tablaStudents);
		return result.map((map) => Student.fromMap(map)).toList();
	}

	// Obtener datos de un estudiante específico por DNI
	Future<Student?> getStudent(String dni) async {
		final db = await instance.database;
		final result = await db.query(
			tablaStudents,
			where: 'DNI = ?',
			whereArgs: [dni],
		);
		if (result.isNotEmpty) {
			return Student.fromMap(result.first);
		} else {
			return null;
		}
	}
	// Obtener lista de fotos de perfil de estudiantes
	Future<List<String>> getStudentPhotos() async {
		final db = await instance.database;
		final result = await db.query(tablaStudents, columns: ['photo']);
		return result.map((map) => map['photo'].toString()).toList();
	}

	// Obtener datos de ImgClave específico por path
	Future<ImgClave?> getImgClave(String path) async {
		final db = await instance.database;
		final result = await db.query(
			tablaImgClave,
			where: 'path = ?',
			whereArgs: [path],
		);
		if (result.isNotEmpty) {
			return ImgClave.fromMap(result.first);
		} else {
			return null;
		}
	}

	// Obtener todas las ImgClave
	Future<List<ImgClave>> getAllImgClaves() async {
		final db = await instance.database;
		final result = await db.query(tablaImgClave);
		return result.map((map) => ImgClave.fromMap(map)).toList();
	}

	// Obtener todos los registros de la tabla Decrypt asociados a un estudiante específico
	Future<List<Decrypt>> getDecryptsByStudentDNI(String dni) async {
		final db = await instance.database;
		final result = await db.query(
			tablaDecrypt,
			where: 'DNI = ?',
			whereArgs: [dni],
		);
		return result.map((map) => Decrypt.fromMap(map)).toList();
	}

	// Obtener todos los registros de la tabla Decrypt
	Future<List<Decrypt>> getAllDecrypts() async {
		final db = await instance.database;
		final result = await db.query(tablaDecrypt);
		return result.map((map) => Decrypt.fromMap(map)).toList();
	}

}