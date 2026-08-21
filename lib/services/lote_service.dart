import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lote.dart';

/// Servicio con las cuatro operaciones CRUD sobre la coleccion lotes.
class LoteService {
  final CollectionReference _lotesRef =
  FirebaseFirestore.instance.collection('lotes');

  // CREAR
  Future<void> crearLote({
    required String numeroLote,
    required String areaResponsable,
    required String creadoPor,
  }) async {
    await _lotesRef.add({
      'numero_lote': numeroLote,
      'estatus': 'listo para auditoria de calidad',
      'area_responsable': areaResponsable,
      'comentario': '',
      'historial': ['Lote registrado por $creadoPor, enviado a $areaResponsable'],
      'fecha_actualizacion': Timestamp.now(),
    });
  }

  // LEER (lista para el tablero)
  Stream<List<Lote>> obtenerLotes() {
    return _lotesRef
        .orderBy('fecha_actualizacion', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Lote.fromFirestore(doc)).toList());
  }

  // LEER (un solo lote, para el detalle)
  Stream<Lote> obtenerLotePorId(String id) {
    return _lotesRef
        .doc(id)
        .snapshots()
        .map((doc) => Lote.fromFirestore(doc));
  }

  // ACTUALIZAR: ahora tambien guarda el comentario (obligatorio si el
  // estatus nuevo es "detenido").
  Future<void> actualizarEstatus({
    required String id,
    required String nuevoEstatus,
    required String areaResponsable,
    required String comentario,
    required List<String> historialActual,
  }) async {
    final nuevoHistorial = List<String>.from(historialActual)
      ..add('Cambio a "$nuevoEstatus" registrado por $areaResponsable'
          '${comentario.isNotEmpty ? " ($comentario)" : ""}');

    await _lotesRef.doc(id).update({
      'estatus': nuevoEstatus,
      'area_responsable': areaResponsable,
      'comentario': comentario,
      'historial': nuevoHistorial,
      'fecha_actualizacion': Timestamp.now(),
    });
  }

  // ELIMINAR
  Future<void> eliminarLote(String id) async {
    await _lotesRef.doc(id).delete();
  }
}