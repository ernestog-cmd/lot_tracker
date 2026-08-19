import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa un documento de la coleccion "lotes" en Firestore.
class Lote {
  final String id;
  final String numeroLote;
  final String estatus;
  final String areaResponsable;
  final String comentario;
  final List<String> historial;
  final DateTime fechaActualizacion;

  Lote({
    required this.id,
    required this.numeroLote,
    required this.estatus,
    required this.areaResponsable,
    required this.comentario,
    required this.historial,
    required this.fechaActualizacion,
  });

  factory Lote.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lote(
      id: doc.id,
      numeroLote: data['numero_lote'] ?? '',
      estatus: data['estatus'] ?? 'listo para auditoria de calidad',
      areaResponsable: data['area_responsable'] ?? '',
      comentario: data['comentario'] ?? '',
      historial: List<String>.from(data['historial'] ?? []),
      fechaActualizacion:
      (data['fecha_actualizacion'] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numero_lote': numeroLote,
      'estatus': estatus,
      'area_responsable': areaResponsable,
      'comentario': comentario,
      'historial': historial,
      'fecha_actualizacion': Timestamp.fromDate(fechaActualizacion),
    };
  }
}

/// Estados reales del flujo de liberacion.
const List<String> estatusDisponibles = [
  'listo para auditoria de calidad',
  'en revision de calidad',
  'detenido',
  'liberado',
];