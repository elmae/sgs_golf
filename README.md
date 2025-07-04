# sgs_golf

A new Flutter project.

## Arquitectura del Proyecto

SGS Golf está estructurado de manera modular para facilitar la escalabilidad y el mantenimiento. A continuación se describen los principales directorios y su propósito:

- **lib/core/**: Contiene la lógica central y utilidades compartidas, como temas, navegación y constantes.
- **lib/data/**: Incluye modelos de datos, servicios y repositorios para la gestión y persistencia de la información.
- **lib/features/**: Cada subdirectorio representa un módulo funcional independiente (por ejemplo, análisis, autenticación, práctica), siguiendo el enfoque de feature-modules.
- **lib/shared/**: Componentes reutilizables, utilidades y widgets compartidos entre diferentes módulos.
- **android/**, **ios/**, **linux/**, **macos/**, **windows/**, **web/**: Carpetas específicas para cada plataforma soportada por Flutter, contienen la configuración y código nativo necesario para cada sistema operativo.
- **docs/**: Documentación del proyecto, incluyendo especificaciones y tareas.

### Interacción entre módulos

Los módulos en `lib/features/` consumen servicios y modelos definidos en `lib/data/` y utilizan utilidades y componentes de `lib/core/` y `lib/shared/`. Esto promueve una separación clara de responsabilidades y facilita la colaboración y el crecimiento del proyecto.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Flujo de datos: Providers y Repositorios

En SGS Golf, el flujo de datos sigue una arquitectura desacoplada basada en providers y repositorios:

- **Repositorios**: Encapsulan la lógica de acceso y persistencia de datos (por ejemplo, almacenamiento local, bases de datos o servicios remotos). Se ubican en `lib/data/repositories/`.
- **Providers**: Actúan como intermediarios entre la UI y los repositorios, exponiendo los datos y operaciones a los widgets mediante patrones como Provider, Riverpod o similares.

**Flujo típico:**
1. La UI solicita datos o acciones a través de un provider.
2. El provider delega la operación al repositorio correspondiente.
3. El repositorio obtiene, actualiza o persiste la información (local o remotamente).
4. El resultado fluye de regreso al provider, que notifica a la UI para actualizar el estado.

Este enfoque promueve la separación de responsabilidades, facilita el testing y permite intercambiar implementaciones de repositorios sin afectar la lógica de presentación.

---

## Comandos útiles para agentes IA

A continuación se listan comandos frecuentes para desarrollo, pruebas y CI en este proyecto Flutter:

### Desarrollo

```bash
flutter pub get
flutter run
flutter analyze
```

### Pruebas

```bash
flutter test
```

### Cobertura

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Integración continua (CI)

- Ejecutar análisis y pruebas en CI:

```bash
flutter analyze
flutter test --coverage
```

- Validar convenciones de commits (si aplica):

```bash
npx commitlint --from=HEAD~10
```

Consulta la documentación interna y los workflows en `.github/workflows/` para más detalles sobre automatizaciones y buenas prácticas.
