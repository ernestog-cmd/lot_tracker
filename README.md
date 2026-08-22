# Sterile Lot Tracker

Aplicacion movil para el seguimiento del proceso de liberacion de lotes en un entorno de manufactura regulada. Permite consultar el estatus de cada lote en tiempo real y notificar a las areas responsables cuando se requiere su intervencion, sustituyendo el seguimiento manual por correo y hojas de calculo.

## Tecnologia

- Flutter / Dart: desarrollo de la app movil (Android e iOS)
- Firebase Firestore: base de datos en la nube
- Firebase Authentication: inicio de sesion con correo y contrasena
- Android Studio: entorno de desarrollo

## Roles y permisos

| Rol      | Crear lote | Ver tablero/detalle | Actualizar estatus | Eliminar lote |
|----------|:----------:|:--------------------:|:-------------------:|:--------------:|
| Operator | Si         | Si                    | No                   | No              |
| Quality  | No         | Si                    | Si                   | Si              |
| Manager  | No         | Si                    | No                   | No              |
| Admin    | Si         | Si                    | Si                   | Si              |

Las cuentas de usuario se crean desde la consola de Firebase (Authentication) y su rol se define en la coleccion `usuarios` de Firestore, no dentro de la app.

## Funcionalidad

- Registro de lotes nuevos con su estatus inicial
- Tablero con el estatus de todos los lotes en tiempo real
- Detalle de cada lote con su historial de transiciones
- Actualizacion de estatus con comentario obligatorio al detener un lote
- Bloqueo de edicion para lotes ya liberados
- Eliminacion de lotes (solo calidad/admin)
- Perfil de usuario y cierre de sesion

## Estructura del proyecto

- lib/models: Lote, Usuario
- lib/services: comunicacion con Firestore y Auth
- lib/utils: colores por estatus
- lib/screens: interfaces de la app
- lib/main.dart: punto de entrada

## Configuracion

1. Clona el repositorio y corre `flutter pub get`.
2. Conecta tu propio proyecto de Firebase con `flutterfire configure`.
3. Activa Authentication (correo/contrasena) y crea usuarios de prueba en la consola de Firebase.
4. Agrega los documentos correspondientes en la coleccion `usuarios` de Firestore, con los campos `nombre`, `rol`, `puesto` y `area`.
5. Corre la app con `flutter run`.

## Seguridad

Se realizo un analisis estatico y pruebas dinamicas manuales con MobSF. El detalle de los hallazgos y las acciones pendientes antes de un despliegue en produccion se documentan en el reporte de la etapa 3 del proyecto integrador.
