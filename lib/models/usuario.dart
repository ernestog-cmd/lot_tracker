import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa un documento de la coleccion "usuarios" en Firestore.
/// "rol" es el codigo fijo que usa el sistema para decidir permisos.
/// "puesto" es el titulo real de la persona, solo para mostrarlo en pantalla.
class Usuario {
  final String uid;
  final String nombre;
  final String rol;
  final String puesto;
  final String area;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.rol,
    required this.puesto,
    required this.area,
  });

  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Usuario(
      uid: doc.id,
      nombre: data['nombre'] ?? '',
      rol: data['rol'] ?? 'operator',
      puesto: data['puesto'] ?? '',
      area: data['area'] ?? '',
    );
  }

  bool get puedeCrearLote => rol == 'operator' || rol == 'admin';
  bool get puedeActualizarEstatus => rol == 'quality' || rol == 'admin';
  bool get puedeEliminar => rol == 'quality' || rol == 'admin';
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty) return '';
    final p1 = partes[0].isNotEmpty ? partes[0][0] : '';
    final p2 = partes.length > 1 && partes[1].isNotEmpty ? partes[1][0] : '';
    return (p1 + p2).toUpperCase();
  }
}