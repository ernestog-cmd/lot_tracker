import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import '../services/auth_service.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: StreamBuilder<Usuario?>(
        stream: UsuarioService().obtenerUsuario(uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final usuario = snapshot.data;
          if (usuario == null) {
            return const Center(child: Text('No se encontro el perfil.'));
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(usuario.iniciales,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                ),
                const SizedBox(height: 16),
                Text(usuario.nombre,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                if (usuario.puesto.isNotEmpty)
                  Text(usuario.puesto, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text('Area: ${usuario.area}'),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar sesion'),
                    onPressed: () => AuthService().cerrarSesion(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}