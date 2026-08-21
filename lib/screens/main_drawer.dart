import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import 'crear_lote_screen.dart';
import 'perfil_screen.dart';

class MainDrawer extends StatelessWidget {
  final Usuario? usuario;
  const MainDrawer({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF0057B8)),
              accountName: Text(usuario?.nombre ?? ''),
              accountEmail: Text(usuario?.puesto ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(usuario?.iniciales ?? '',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0057B8))),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Ver lotes'),
              onTap: () => Navigator.pop(context),
            ),
            if (usuario?.puedeCrearLote ?? false)
              ListTile(
                leading: const Icon(Icons.add_box_outlined),
                title: const Text('Agregar lote'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CrearLoteScreen()));
                },
              ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Mi perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PerfilScreen()));
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesion', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await AuthService().cerrarSesion();
                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}