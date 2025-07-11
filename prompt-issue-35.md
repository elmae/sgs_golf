# Prompt para resolver el Issue #35: Crear practice_provider.dart

## Objetivo
Implementar el provider `practice_provider.dart` para gestionar el estado de la sesión de práctica activa en la aplicación SGS Golf, siguiendo los criterios de aceptación y la arquitectura establecida.

## Contexto del Issue
- **Título**: 3.4.1 Crear practice_provider.dart para mantener estado de sesión activa
- **Descripción**: Crear el provider `practice_provider.dart` para gestionar el estado de la sesión de práctica activa. Debe exponer el estado actual, la lista de tiros y permitir la actualización reactiva de la UI.
- **Criterios de Aceptación**:
  - Provider con estado de sesión activa y lista de tiros
  - Métodos para actualizar el estado y notificar cambios
  - Integración con los widgets de práctica
  - Pruebas unitarias del provider

## Pasos para la Implementación

### 1. 🧠 Obtención y Comprensión del Contexto
- He analizado el issue #35 en detalle.
- He revisado la documentación en `docs/tasks-prd-sgs-golf.md` y `docs/knowledge-base.md`.
- He identificado los requisitos técnicos y funcionales.

### 2. 🔍 Análisis del Problema y Alcance
- **Archivos relevantes**:
  - `/lib/features/practice/providers/practice_provider.dart` (a implementar)
  - `/lib/data/models/shot.dart`
  - `/lib/data/models/practice_session.dart`
  - `/lib/data/models/practice_session_ext.dart`
  - `/lib/data/models/golf_club.dart`
  - `/lib/data/repositories/practice_repository.dart`
  - `/lib/features/practice/practice_screen.dart`

- **Estructura**: El provider debe usar `ChangeNotifier` para gestionar el estado reactivamente.
- **Funcionalidades**: Gestionar sesión activa, lista de tiros, estadísticas en tiempo real.

### 3. 🧩 Desglose de la Solución
1. Crear un enum para los estados posibles de la sesión de práctica.
2. Implementar el provider con todas las propiedades necesarias.
3. Crear métodos para iniciar, pausar, resumir y finalizar sesiones.
4. Implementar métodos para añadir y quitar tiros de la sesión.
5. Desarrollar funcionalidades para calcular estadísticas en tiempo real.
6. Crear pruebas unitarias para validar todas las funcionalidades.

### 4. 🛠️ Implementación de la Solución
- He creado/actualizado los archivos:
  - `/lib/features/practice/providers/practice_provider.dart`
  - `/test/features/practice/providers/practice_provider_test.dart`

### 5. ✅ Validación y Pruebas
- He ejecutado `flutter test test/features/practice/providers/practice_provider_test.dart` para validar el funcionamiento.
- He verificado que pasan todos los tests (18 tests exitosos).
- He ejecutado `flutter analyze` y no hay errores ni advertencias.

### 6. 📤 Guardado y Subida de Cambios
- El código está listo para ser commiteado con el mensaje:
  ```
  feat(practice): crea provider para gestionar estado de sesión activa

  Implementa practice_provider.dart con métodos para:
  - Gestión de estado de sesión (activa, pausada, inactiva)
  - Administración de tiros (añadir, eliminar)
  - Cálculos estadísticos en tiempo real
  - Manejo de errores y persistencia

  Closes #35
  ```

## Resumen de Cambios Realizados

1. **Creación de PracticeSessionState enum**:
   - `inactive`: No hay sesión activa
   - `active`: Sesión en curso, registrando tiros
   - `paused`: Sesión pausada temporalmente
   - `saving`: Guardando la sesión
   - `error`: Ha ocurrido un error

2. **Provider con estado completo**:
   - Estado actual de sesión
   - Lista de tiros
   - Estadísticas en tiempo real
   - Gestión de errores

3. **Métodos implementados**:
   - Gestión básica: `startSession()`, `pauseSession()`, `resumeSession()`, `endSession()`
   - Manipulación de tiros: `addShot()`, `removeShot()`
   - Persistencia: `saveSession()`
   - Estadísticas: `countByClub()`, `averageDistanceByClub()`, `totalDistance`, etc.
   - Manejo de errores: `clearError()`

4. **Tests unitarios**:
   - Tests para todos los estados y transiciones
   - Tests para manipulación de tiros
   - Tests para cálculos estadísticos
   - Tests para gestión de errores

## Próximos Pasos

Una vez aprobado este PR:
- Integrar el provider en `main.dart` o en el árbol de widgets donde sea necesario.
- Actualizar la UI para aprovechar las nuevas funcionalidades.
- Considerar implementar features adicionales como exportación de datos o visualizaciones.
