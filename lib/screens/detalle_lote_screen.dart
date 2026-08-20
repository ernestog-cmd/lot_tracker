import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/lote.dart';
import '../models/usuario.dart';
import '../services/lote_service.dart';
import '../services/usuario_service.dart';
import '../utils/estatus_colores.dart';

class DetalleLoteScreen extends StatelessWidget {
  final String loteId;
  const DetalleLoteScreen({super.key, required this.loteId});

  @override
  Widget build(BuildContext context) {
    final loteService = LoteService();
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del lote')),
      body: StreamBuilder<Lote>(
        stream: loteService.obtenerLotePorId(loteId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lote = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lote.numeroLote,
                    style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: EstatusColores.fondo(lote.estatus),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(lote.estatus,
                      style: TextStyle(color: EstatusColores.texto(lote.estatus))),
                ),
                if (lote.comentario.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text('Comentario: ${lote.comentario}',
                      style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
                const SizedBox(height: 20),
                const Text('Historial', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: lote.historial.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('• ${lote.historial[i]}'),
                    ),
                  ),
                ),
                StreamBuilder<Usuario?>(
                  stream: UsuarioService()
                      .obtenerUsuario(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, usnap) {
                    final usuario = usnap.data;
                    if (usuario == null) return const SizedBox.shrink();
                    final liberado = lote.estatus == 'liberado';
                    return Row(
                      children: [
                        if (usuario.puedeActualizarEstatus && !liberado)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  _mostrarDialogoActualizar(context, loteService, lote),
                              child: const Text('Actualizar estatus'),
                            ),
                          ),
                        if (usuario.puedeActualizarEstatus && liberado)
                          const Expanded(
                            child: Text('Lote liberado, no se puede modificar.',
                                style: TextStyle(
                                    color: Colors.grey, fontStyle: FontStyle.italic)),
                          ),
                        if (usuario.puedeEliminar) ...[
                          const SizedBox(width: 10),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            onPressed: () => _confirmarEliminar(context, loteService, lote),
                            child: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, LoteService service, Lote lote) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar lote'),
        content: Text('¿Seguro que quieres eliminar el lote ${lote.numeroLote}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await service.eliminarLote(lote.id);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoActualizar(BuildContext context, LoteService service, Lote lote) {
    String nuevoEstatus = lote.estatus;
    String? areaSeleccionada =
    departamentosDisponibles.contains(lote.areaResponsable) ? lote.areaResponsable : null;
    final comentarioController = TextEditingController(text: lote.comentario);
    String? errorComentario;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Actualizar estatus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: nuevoEstatus,
                items: estatusDisponibles.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setStateDialog(() => nuevoEstatus = v ?? nuevoEstatus),
                decoration: const InputDecoration(labelText: 'Nuevo estatus'),
              ),
              DropdownButtonFormField<String>(
                value: areaSeleccionada,
                items: departamentosDisponibles.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                onChanged: (v) => setStateDialog(() => areaSeleccionada = v),
                decoration: const InputDecoration(labelText: 'Area responsable'),
              ),
              TextField(
                controller: comentarioController,
                decoration: InputDecoration(
                  labelText: nuevoEstatus == 'detenido'
                      ? 'Motivo del detenimiento (obligatorio)'
                      : 'Comentario (opcional)',
                  errorText: errorComentario,
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                if (nuevoEstatus == 'detenido' && comentarioController.text.trim().isEmpty) {
                  setStateDialog(() => errorComentario = 'Debes indicar el motivo');
                  return;
                }
                if (areaSeleccionada == null) return;
                await service.actualizarEstatus(
                  id: lote.id,
                  nuevoEstatus: nuevoEstatus,
                  areaResponsable: areaSeleccionada!,
                  comentario: comentarioController.text.trim(),
                  historialActual: lote.historial,
                );
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}