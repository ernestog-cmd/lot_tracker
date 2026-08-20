import 'package:flutter/material.dart';

/// Mismos colores usados en los mockups de Canva para cada estatus,
/// para que la app se vea identica al diseño de la etapa 2.
class EstatusColores {
  static Color fondo(String estatus) {
    switch (estatus) {
      case 'en revision de calidad':
        return const Color(0xFFFAEEDA); // ambar
      case 'liberado':
        return const Color(0xFFEAF3DE); // verde
      case 'pendiente de documentacion':
        return const Color(0xFFFCEBEB); // rojo
      default:
        return const Color(0xFFE9E9E9); // gris, "en proceso"
    }
  }

  static Color texto(String estatus) {
    switch (estatus) {
      case 'en revision de calidad':
        return const Color(0xFF854F0B);
      case 'liberado':
        return const Color(0xFF3B6D11);
      case 'pendiente de documentacion':
        return const Color(0xFFA32D2D);
      default:
        return const Color(0xFF555555);
    }
  }
}