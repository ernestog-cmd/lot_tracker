import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

/// Servicio para leer el perfil (rol, area, puesto) del usuario
/// autenticado, guardado en la coleccion "usuarios".
class UsuarioService {
  final CollectionReference _usuariosRef =
  FirebaseFirestore.instance.collection('usuarios');

  /// Transmite en tiempo real los datos del usuario segun su uid
  /// (el mismo uid que genera Firebase Authentication al iniciar sesion).
  Stream<Usuario?> obtenerUsuario(String uid) {
    return _usuariosRef.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Usuario.fromFirestore(doc);
    });
  }
}