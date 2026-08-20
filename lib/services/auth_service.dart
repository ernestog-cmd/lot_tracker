import 'package:firebase_auth/firebase_auth.dart';

/// Servicio que maneja el inicio y cierre de sesion con correo y
/// contraseña. Las cuentas las crea un administrador desde la consola
/// de Firebase, no se registran usuarios dentro de la app.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get usuarioActual => _auth.authStateChanges();

  User? get usuario => _auth.currentUser;

  Future<User?> iniciarSesionConCorreo(String correo, String contrasena) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: correo,
      password: contrasena,
    );
    return credential.user;
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }
}