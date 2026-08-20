import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/lote.dart';
import '../models/usuario.dart';
import '../services/lote_service.dart';
import '../services/usuario_service.dart';
import '../utils/estatus_colores.dart';
import 'detalle_lote_screen.dart';
import 'crear_lote_screen.dart';
import 'main_drawer.dart';

class TableroScreen extends StatelessWidget {
  TableroScreen({super.key});
  final LoteService _loteService = LoteService();
  final UsuarioService _usuarioService = UsuarioService();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<Usuario?>(
      stream: _usuarioService.obtenerUsuario(uid),
      builder: (context, usuarioSnap) {
        final usuario = usuarioSnap.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tablero de estatus'),
            backgroundColor: const Color(0xFF0057B8),
            foregroundColor: Colors.white,
          ),
          drawer: MainDrawer(usuario: usuario),
          body: StreamBuilder<List<Lote>>(
            stream: _loteService.obtenerLotes(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final lotes = snapshot.data!;
              if (lotes.isEmpty) {
                return const Center(child: Text('Aun no hay lotes registrados.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: lotes.length,
                itemBuilder: (context, index) {
                  final lote = lotes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(lote.numeroLote,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(lote.areaResponsable),
                      trailing: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: EstatusColores.fondo(lote.estatus),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(lote.estatus,
                            style: TextStyle(
                                fontSize: 12,
                                color: EstatusColores.texto(lote.estatus))),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DetalleLoteScreen(loteId: lote.id))),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: (usuario?.puedeCrearLote ?? false)
              ? FloatingActionButton.extended(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CrearLoteScreen())),
            icon: const Icon(Icons.add),
            label: const Text('Agregar lote'),
          )
              : null,
        );
      },
    );
  }
}