import 'package:flutter/material.dart';

class EstatusColores {
  static Color fondo(String estatus) {
    switch (estatus) {
      case 'listo para auditoria de calidad':
        return const Color(0xFFE6F1FB);
      case 'en revision de calidad':
        return const Color(0xFFFAEEDA);
      case 'liberado':
        return const Color(0xFFEAF3DE);
      case 'detenido':
        return const Color(0xFFFCEBEB);
      default:
        return const Color(0xFFE9E9E9);
    }
  }

  static Color texto(String estatus) {
    switch (estatus) {
      case 'listo para auditoria de calidad':
        return const Color(0xFF185FA5);
      case 'en revision de calidad':
        return const Color(0xFF854F0B);
      case 'liberado':
        return const Color(0xFF3B6D11);
      case 'detenido':
        return const Color(0xFFA32D2D);
      default:
        return const Color(0xFF555555);
    }
  }
}