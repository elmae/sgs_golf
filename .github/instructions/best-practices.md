# Mejores Prácticas de Codificación para SGS Golf

Este documento describe las mejores prácticas a seguir cuando se desarrolla código para el proyecto SGS Golf, asegurando consistencia, mantenibilidad y calidad del código.

## Estructura del Proyecto

- Todo el código fuente debe vivir en `lib/`.
- Seguir estrictamente la estructura modular establecida:
  ```
  lib/
  ├── core/           # Configuración, constantes, temas, navegación
  ├── data/           # Modelos Hive, repositorios, servicios
  ├── features/       # Funcionalidades organizadas por dominio
  │   ├── auth/       # Autenticación local
  │   ├── practice/   # Registro de sesiones de práctica
  │   ├── dashboard/  # Visualización de historial
  │   ├── analysis/   # Gráficos y estadísticas
  │   └── export/     # Exportación de datos
  └── shared/         # Widgets y utilidades comunes
  ```

## Convenciones de Nomenclatura

1. **Archivos**: Usar `snake_case` para nombres de archivos (ej: `auth_repository.dart`).
2. **Clases**: Usar `PascalCase` para clases y enums (ej: `PracticeSession`, `GolfClubType`).
3. **Variables y Métodos**: Usar `camelCase` para variables y métodos (ej: `averageDistance`, `createSession()`).
4. **Constantes**: Usar `snake_case` para constantes y `k` como prefijo para constantes globales (ej: `kPrimaryColor`).
5. **Nombres Descriptivos**: Evitar abreviaciones y usar nombres que describan claramente el propósito del elemento.

## Modelos y Persistencia

1. **Adaptadores Hive**:
   - Usar decoradores `@HiveType` y `@HiveField` para todos los modelos.
   - Asignar IDs de tipo consistentes y documentados para evitar colisiones.
   - Ejemplo:
     ```dart
     @HiveType(typeId: 2)
     class Shot extends HiveObject {
       @HiveField(0)
       GolfClubType clubType;
     
       @HiveField(1)
       double distance;
     }
     ```

2. **Inicialización**:
   - Registrar todos los adaptadores en `main.dart` antes de abrir las cajas Hive.

## Gestión de Estado

1. **Patrón Provider**:
   - Usar exclusivamente Provider (no Riverpod).
   - Mantener archivos de providers en cada feature: `features/*/providers/*.dart`.
   - Hacer que los providers sean responsables de la lógica de negocio, no los widgets.

2. **Separación de Responsabilidades**:
   - Los widgets solo deben mostrar UI y manejar interacciones básicas.
   - La lógica debe estar en los providers o repositorios.
   - Los repositorios deben manejar operaciones CRUD y consultas.

## Diseño de UI

1. **Componentes**:
   - Usar componentes de la carpeta `shared/widgets` para mantener consistencia.
   - Preferir `AppButton`, `AppCard` y `AppChip` sobre widgets nativos cuando sea posible.

2. **Temas**:
   - Utilizar siempre `AppTheme` para colores y estilos.
   - Seguir la paleta oficial de SGS Golf (naranja, azul, verde, gris).
   - No utilizar colores hard-coded en los widgets.

3. **Textos y Estilos**:
   - Definir estilos de texto consistentes:
     ```dart
     // Título
     Text('Mi Título', style: theme.textTheme.titleLarge)
     
     // Cuerpo
     Text('Contenido', style: theme.textTheme.bodyMedium)
     
     // Pie
     Text('Información adicional', style: theme.textTheme.labelSmall)
     ```

## Optimización de Rendimiento

1. **Construcción de widgets**:
   - Usar `const` siempre que sea posible.
   - Extraer widgets frecuentemente reconstruidos a clases separadas.
   - Evitar cálculos pesados dentro de métodos `build()`.

2. **Listas**:
   - Usar `ListView.builder()` para listas largas.
   - Siempre incluir `itemCount` y `key` en los widgets de lista.

## Documentación

1. **Clases y métodos públicos**:
   - Documentar todas las clases y métodos públicos con comentarios de documentación `///`.
   - Incluir descripción, parámetros y ejemplo de uso cuando sea relevante.
   - Ejemplo:
     ```dart
     /// Widget que muestra estadísticas en tiempo real de la sesión de práctica.
     ///
     /// Toma un objeto [statistics] y renderiza una visualización
     /// de métricas relevantes para el usuario.
     ///
     /// Ejemplo:
     /// ```dart
     /// StatisticsWidget(statistics: sessionStatistics)
     /// ```
     class StatisticsWidget extends StatelessWidget {
       // ...
     }
     ```

2. **TODOs**:
   - Marcar código pendiente con `// TODO: descripción específica`.
   - Incluir identificador de issue cuando sea posible: `// TODO(#123): implementar exportación`.

## Manejo de Errores

1. **Excepciones**:
   - Crear clases de excepción específicas para el dominio.
   - Ejemplo: `InvalidUserException`, `SessionCreationException`.

2. **Validaciones**:
   - Validar datos de entrada en métodos públicos.
   - Usar assertions para invariantes internos.
   - Lanzar excepciones con mensajes claros para errores recuperables.

## Pruebas

1. **Estructura**:
   - La estructura de tests debe replicar la estructura de `lib/`.
   - Nombrar archivos de prueba con sufijo `_test.dart`.

2. **Cobertura**:
   - Todo modelo y repositorio debe tener pruebas unitarias.
   - Las pantallas principales deben tener pruebas de widgets.
   - Apuntar a 80%+ de cobertura de código.

3. **Mocks**:
   - Usar `mocktail` para mocks en pruebas unitarias.
   - Crear mocks en archivos separados para reutilización.

## Estilo y Formateo

1. **Longitud de línea**:
   - Mantener líneas bajo 80 caracteres.
   - Para cadenas largas, usar concatenación con `+` o cadenas multilínea.

2. **Formateo de código**:
   - Ejecutar `dart format .` antes de cada commit.
   - Seguir la [guía de estilo oficial de Dart](https://dart.dev/guides/language/effective-dart/style).

3. **Organización de imports**:
   - Ordenar imports en bloques:
     1. Paquetes de Dart
     2. Paquetes externos
     3. Paquetes del proyecto

## Control de Versiones

1. **Mensajes de Commit**:
   - Formato: `tipo(módulo): descripción breve` (todo en minúsculas)
   - Tipos: `feat`, `fix`, `docs`, `refactor`, `test`, `ci`
   - Ejemplo: `feat(practice): implementa selector de palo interactivo`

2. **Ramas**:
   - Trabajar siempre en rama `develop`
   - Hacer merge a `develop`, no directamente a `main`
   

## Recursos y Herramientas Externas

- Solo usar librerías estables y documentadas.
- Documentar el propósito de cada paquete añadido a `pubspec.yaml`.
- Verificar compatibilidad con la versión actual de Flutter.

## Prácticas a Evitar

1. No incluir lógica de negocio en widgets.
2. No modificar archivos generados (con sufijo `.g.dart`).
3. No utilizar `print()` para debugging en código de producción.
4. No crear archivos `.dart` con más de 300 líneas (excepto modelos/configuración).
5. No usar `Navigator.push()` directamente, utilizar el sistema de rutas definido.
