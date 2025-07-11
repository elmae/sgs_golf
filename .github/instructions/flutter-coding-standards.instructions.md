# Flutter Coding Standards y Mejores Prácticas

## 1. Estructura de Proyecto y Arquitectura
Mantener una arquitectura en capas mejora la mantenibilidad, escalabilidad y testabilidad de tu aplicación.

- **Capa de Presentación (UI):** widgets “dumb” que muestran el estado y delegan la lógica a ViewModels.
- **Capa de Dominio (opcional):** casos de uso o interactores para lógica de negocio compleja.
- **Capa de Datos:** repositorios como única fuente de verdad y servicios que envuelven APIs o almacenamiento local.

Flujo unidireccional de datos: eventos de UI → ViewModel → Repository → UI.

**Separación de responsabilidades (MVVM):**

- **Views:** composición de widgets, sin lógica compleja.
- **ViewModels:** exponen estados, comandos y transformaciones de datos.
- **Repositories:** obtienen, cachean y normalizan datos en modelos inmutables.
- **Services:** encapsulan llamadas a APIs externas o plugins de plataforma.

## 2. Convenciones de Nombres y Organización de Archivos
Organizar código por funcionalidad (feature folders) y seguir convenciones claras agiliza la colaboración.

- **Archivos:** `snake_case.dart`
- **Clases, enums y mixins:** PascalCase
- **Variables, parámetros y campos:** lowerCamelCase

**Estructura recomendada:**

```text
lib/
  features/
    auth/
      view/login_view.dart
      view_model/login_view_model.dart
      repository/auth_repository.dart
      service/auth_service.dart
    home/
      ...
  core/
    widgets/
    utils/
    constants/
```

Prefijos/Sufijos según rol: `HomeView`, `HomeViewModel`, `UserRepository`, `ApiService`.

Evitar nombres genéricos que choquen con la SDK de Flutter (por ejemplo, no usar `/widgets/` para widgets compartidos; mejor `/ui/core/`).

## 3. Estilo de Código Dart y Lints
Aplicar un estilo uniforme previene debates de formato y facilita el onboarding de nuevos colaboradores.

- Indentación de 2 espacios; sin tabs.
- Longitud de línea: máximo 80–100 caracteres.
- Trailing commas en parámetros multilínea para un formateo más limpio (`dart format`).
- Habilitar el paquete de lints oficial `flutter_lints` e incluir reglas como:
  - `prefer_const_constructors`
  - `avoid_redundant_argument_values`
  - `use_full_hex_values_for_flutter_colors`
- Ejecutar linters y formateo en pre-commit o CI.

## 4. Widgets y UI
Optimizar la construcción de widgets mejora el rendimiento y claridad del código.

- Usar `const` en constructores siempre que sea posible.
- Preferir `StatelessWidget` para UIs inmutables; extraer lógica a ViewModels.
- Dividir widgets grandes en sub-widgets reutilizables para localizar `setState` y rebuilds.
- Evitar operaciones costosas en `build()` (cálculos complejos, llamadas a `setState` en alto nivel).
- Minimizar uso de `saveLayer()`, `Opacity` y clipping; validar en DevTools si aparecen capas offscreen.
- Para listas y grids grandes, usar `ListView.builder` y `GridView.builder` para construcción perezosa.

## 5. State Management
Seleccionar una solución coherente permite un flujo de datos predecible y fácil de depurar.

- Mantener toda la lógica de estado en ViewModels o providers; las Views solo renderizan.
- Fluir datos de forma unidireccional: Repository → ViewModel → View, y eventos de View al Repository.
- Usar paquetes consolidados: `provider`, `flutter_riverpod`, `bloc`, según preferencias del equipo.
- Exponer comandos (callbacks fuertemente tipados) en ViewModels para manejadores de eventos.
- Modelos inmutables: usar `freezed` o `built_value` para generar `copyWith`, deserialización JSON y comparaciones profundas.

## 6. Rendimiento
Flutter es rápido por defecto, pero estos ajustes previenen jank y rebuilds innecesarios.

- Constructores `const` para widgets y valores constantes.
- Separar árbol de widgets para evitar rebuilds globales.
- Evitar intrinsic passes configurando tamaños fijos o usando un anchor cell en grids.
- Precargar y cachear imágenes (`precacheImage`).
- Medir con DevTools: Performance View, Timeline and Tracing.

## 7. Diseño Adaptable y Multiplataforma
Construir UI que responda a distintos tamaños de pantalla y dispositivos, sin condicionar a tipos de hardware.

- No bloquear orientación; adaptar diseño en tiempo de ejecución.
- Usar `LayoutBuilder` o `MediaQuery.size` para breakpoints adaptativos (Material Design).
- No chequear si es “tablet” o “teléfono”; basarse en espacio disponible.
- Romper vistas grandes en widgets más pequeños (`const`) para mejorar rebuilds.
- Soporte touch, mouse y teclado; shortcuts accesibles.
- Conservar estado de listas y pantallas tras rotaciones: `PageStorageKey`.

## 8. Pruebas y Automatización
Tener una buena batería de tests asegura cambios seguros y evolución rápida.

- Unit tests por cada repositorio, servicio y ViewModel; aislar con fakes/mocks.
- Widget tests para vistas y flujos críticos (navegación, inyección de dependencias).
- Integración/End-to-end para flujos de usuario completos.
- Integrar en CI/CD (GitHub Actions): ejecutar `dart format .`, `flutter test`, `flutter analyze`, `dart format --set-exit-if-changed`.
- Reportar cobertura con Coveralls/GitHub Actions y definir umbrales mínimos.
