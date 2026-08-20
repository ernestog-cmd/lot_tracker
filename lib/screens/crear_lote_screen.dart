import 'package:flutter/material.dart';
import '../models/lote.dart';
import '../services/lote_service.dart';

class CrearLoteScreen extends StatefulWidget {
  const CrearLoteScreen({super.key});
  @override
  State<CrearLoteScreen> createState() => _CrearLoteScreenState();
}

class _CrearLoteScreenState extends State<CrearLoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numeroController = TextEditingController();
  String? _areaSeleccionada;
  final _loteService = LoteService();
  bool _guardando = false;

  Future<void> _guardarLote() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    await _loteService.crearLote(
      numeroLote: _numeroController.text.trim(),
      areaResponsable: _areaSeleccionada!,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar lote')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(labelText: 'Numero de lote'),
                validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _areaSeleccionada,
                items: departamentosDisponibles
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => _areaSeleccionada = v),
                decoration: const InputDecoration(labelText: 'Area responsable'),
                validator: (v) => v == null ? 'Selecciona un area' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardando ? null : _guardarLote,
                child: _guardando
                    ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Guardar lote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}