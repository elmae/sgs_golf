---
applyTo: '*'
description: 'Instrucciones para Copilot en proyectos Flutter - SGS Golf'
---

# 🧠 Instrucciones para Copilot

## 🌍 Idioma preferido
Todas las respuestas deben generarse en idioma español, incluyendo explicaciones técnicas, sugerencias de código, pruebas y mensajes de commit.

## 📋 Contexto del Proyecto
SGS Golf es una aplicación para registrar y analizar sesiones de práctica de juego corto en golf. La aplicación permite:
- Registro de sesiones por tipo de palo (PW, GW, SW, LW)
- Medición de distancias por tiro
- Análisis estadístico con gráficas
- Exportación de datos para análisis externo

### 🏗️ Arquitectura Modular
- `core/`: Configuración global, temas, navegación y manejo de errores
- `data/`: Modelos Hive, repositorios y servicios para persistencia
- `features/`: Funcionalidades específicas organizadas por dominio
- `shared/`: Widgets y utilidades reutilizables entre módulos

## 🧱 Estándares de Codificación Flutter

### 📁 Estructura del Proyecto
- Todo el código fuente debe vivir en `lib/`.
- Seguir la estructura modular establecida:
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

### 🔄 Persistencia y Modelos
- Usar adaptadores Hive para todos los modelos (`@HiveType`, `@HiveField`)
- Registrar adaptadores en `main.dart` antes de abrir las cajas
- Estructura de modelos clave:
  - `User`: Información de usuario para autenticación local
  - `GolfClubType`: Enum con tipos de palos (PW, GW, SW, LW)
  - `Shot`: Registro individual de un tiro (palo, distancia, timestamp)
  - `PracticeSession`: Sesión completa con lista de tiros y estadísticas

### 🎨 UI y Composición
- Usar `const` siempre que sea posible.
- Preferir `ConsumerWidget` para componentes con acceso a `ref`.
- Seguir la paleta de colores (naranja, azul, verde, gris) definida en `core/theme/app_theme.dart`
- Definir estilos de texto consistentes:
  - Título: `TextStyle(fontSize: 24, fontWeight: FontWeight.bold)`
  - Cuerpo: `TextStyle(fontSize: 16)`
  - Pie: `TextStyle(fontSize: 12, color: Colors.grey)`

### ⚙️ Gestión de Estado
- Utilizar Provider como sistema de gestión (no Riverpod).
- Mantener archivos de providers en cada feature: `features/*/providers/*.dart`.
- Evitar lógica de negocio directamente en los widgets.
- Usar repositorios para aislar la lógica de datos.

### 📐 Estilo y convenciones
- Seguir la [guía de estilo oficial de Dart](https://dart.dev/guides/language/effective-dart/style).
- Mantener líneas bajo 80 caracteres.
- Usar parámetros con nombre para mayor claridad.
- Evitar nombres ambiguos. Utilizar nombres descriptivos en inglés técnico.
- Documentar todas las clases y métodos públicos con comentarios de documentación `///`.

### 🧪 Pruebas
- Escribir pruebas unitarias y de widgets para cada nueva funcionalidad.
- Usar `flutter_test` y `mocktail` para tests y mocks.
- Estructura de tests debe replicar la estructura de `lib/`.
- Ejecutar validaciones con `./run_checks.sh` antes de commits.

### 📝 Flujo de trabajo y CI/CD
- Formato de commit: `tipo(modulo): descripción breve` (todo en minúsculas)
- Tipos: `feat`, `fix`, `docs`, `refactor`, `test`, `ci`.
- Trabajar siempre sobre la rama `develop`, no `main`.
- Validar código con `flutter test`, `flutter analyze` y `dart format .` antes de commit.
- El CI ejecuta estas verificaciones automáticamente en GitHub Actions.

### 🚀 Buenas prácticas adicionales
- Evitar el uso innecesario de lógica imperativa dentro de los widgets.
- Documentar el propósito de cada paquete en `pubspec.yaml`.
- Estructura futura para soportar métricas adicionales como `spinrate` y `angleofattack`.

## 🧭 Instrucciones para Issues en GitHub

Para resolución de issues, sigue las instrucciones detalladas en:
[issues-resolution.instructions.md](instructions/issues-resolution.instructions.md)

## 📚 Recursos y documentación
- Estructura y archivos clave: ver [`tasks-prd-sgs-golf.md`](../docs/tasks-prd-sgs-golf.md)
- Visión general y criterios de calidad: ver [`knowledge-base.md`](../docs/knowledge-base.md)
- Para validar dependencias y APIs, consultar context7 antes de implementar

