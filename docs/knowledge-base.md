# Base de Conocimiento — SGS Golf

## Visión y Objetivo

SGS Golf es una aplicación móvil para Android (Flutter) que digitaliza y optimiza el registro y análisis de sesiones de práctica de juego corto en golf, enfocándose en distancias y métricas clave por tipo de palo (PW, GW, SW, LW). Busca ofrecer una experiencia moderna, intuitiva y divertida, facilitando el control, seguimiento y mejora del desempeño de golfistas avanzados.

---

## Estructura del Proyecto

```
sgs_golf/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/           # Configuración, utilidades, constantes, temas
│   ├── data/           # Modelos, fuentes de datos (Hive), repositorios
│   ├── features/       # Un subdirectorio por feature principal
│   │   ├── auth/       # Registro, login, autenticación local
│   │   ├── practice/   # Lógica y UI de sesiones de práctica
│   │   ├── dashboard/  # Visualización de sesiones previas
│   │   ├── analysis/   # Análisis y comparativas
│   │   └── export/     # Exportación de datos (CSV)
│   ├── shared/         # Widgets y utilidades reutilizables
│   └── l10n/           # Internacionalización (opcional)
├── test/               # Pruebas unitarias y de widgets
├── .github/workflows/  # GitHub Actions (CI, formateo, pruebas)
├── pubspec.yaml        # Dependencias y configuración Flutter
├── docs/               # Documentación central y PRD
└── README.md
```

---

## Módulos y Responsabilidades

- **core/**: Configuración global, temas, utilidades, constantes.
- **data/**: Modelos de dominio (`user`, `golf_club`, `shot`, `practice_session`), adaptadores Hive, repositorios.
- **features/**
  - **auth/**: Registro, login, autenticación local, gestión de usuario.
  - **practice/**: Flujo de registro de tiros, selección de palo, finalización de sesión.
  - **dashboard/**: Listado y detalle de sesiones previas.
  - **analysis/**: Gráficas, comparativas, métricas de consistencia y progreso.
  - **export/**: Exportación de datos a CSV/PDF.
- **shared/**: Widgets reutilizables (inputs, botones, cards, selectores), utilidades UI.
- **l10n/**: Internacionalización (si aplica).

---

## Flujos Clave de Usuario

1. **Registro y autenticación**
   - Crear cuenta y autenticarse con usuario/contraseña.
2. **Sesión de práctica**
   - Selección de palo (PW, GW, SW, LW).
   - Registro de distancia de cada tiro.
   - Cambio de palo durante la sesión.
   - Finalización y guardado de sesión.
3. **Consulta y análisis**
   - Acceso a historial de sesiones previas.
   - Visualización de promedios y consistencia por palo y sesión.
   - Gráficas comparativas y análisis de progreso.
4. **Exportación**
   - Exportar datos en formatos estándar (CSV, PDF).

---

## Dependencias Clave

- `flutter`, `hive`, `hive_flutter`, `provider` o `flutter_riverpod`
- `fl_chart` (gráficas), `csv`, `file_picker`, `path_provider`
- `flutter_lints`, `mocktail`, `flutter_test`, `intl` (opcional)

> **Nota:** Todas las referencias a dependencias, librerías y APIs deben ser validadas y actualizadas usando context7 para asegurar que la información y ejemplos sean actuales y confiables.

---

## Reglas de Trabajo y Colaboración

- Desarrollo exclusivo en `sgs_golf/`.
- Uso solo de librerías estables y actualizadas (no RC/deprecated).
- **Es obligatorio validar y actualizar referencias técnicas, dependencias y ejemplos usando context7 antes de documentar o implementar.**
- Flujo Git: ramas `main`, `develop` y una rama por tarea.
- Issues y PRs deben incluir contexto, dependencias y ejemplos.
- Automatización de pruebas y análisis estático con GitHub Actions.
- Documentar cada módulo, función pública y ejemplo de uso.
- Archivos `.dart` ≤ 300 líneas (excepto modelos/configuración).
- Separar lógica de negocio de la presentación (no lógica en widgets).
- Pruebas y documentación replican la estructura de `lib/` en `test/` y `docs/`.

- Los mensajes en los commit no pueden contener mayúsculas.
- seguir reglas de conevtional commits.
---

## Criterios de Calidad

- Interfaz intuitiva, moderna y ágil (paleta: naranja, azul, verde, gris).
- Experiencia divertida y fácil de usar.
- Seguridad básica: almacenamiento seguro de credenciales, opción de eliminar cuenta y datos.
- Modularidad y código documentado.
- Facilidad para agregar nuevas métricas y features.
- Cobertura de pruebas y validación automática en CI.
- Facilidad de onboarding para nuevos colaboradores y agentes IA.

---

## Puntos de Extensión Futuros

- Soporte para nuevas métricas: `spinrate`, `angleofattack`.
- Internacionalización (`l10n/`).
- Exportación a más formatos y reportes avanzados.
- Refuerzo de seguridad y privacidad si se expande el alcance.
- Escalabilidad para más usuarios y datos.

---

## Archivos y Componentes Relevantes

- **Configuración y core:**  
  - `pubspec.yaml`, `main.dart`, `app.dart`, `core/constants/app_constants.dart`, `core/theme/app_theme.dart`, `core/navigation/app_router.dart`, `core/errors/error_handler.dart`
- **Modelos y repositorios:**  
  - `data/models/user.dart`, `data/models/golf_club.dart`, `data/models/shot.dart`, `data/models/practice_session.dart`
  - `data/repositories/auth_repository.dart`, `practice_repository.dart`, `analytics_repository.dart`
  - `data/services/hive_service.dart`, `export_service.dart`
- **Features:**  
  - `features/auth/`, `features/practice/`, `features/dashboard/`, `features/analysis/`, `features/export/`
- **Pruebas:**  
  - Estructura en `test/` replicando `lib/`
- **CI/CD:**  
  - `.github/workflows/ci.yml`, `analysis_options.yaml`
- **Documentación:**  
  - `docs/prd-sgs-golf.md`, `docs/prd-context-sgs-golf.md`, `docs/tasks-prd-sgs-golf.md`

---

## Recomendaciones para Onboarding y Colaboración

- Leer primero este documento y los PRD en `docs/`.
- Seguir la estructura modular y las convenciones de ramas y PRs.
- Usar issues y plantillas para tareas, siempre con contexto y dependencias.
- Mantener la documentación y ejemplos actualizados.
- **Antes de implementar o documentar cualquier dependencia, librería o API, consulta y valida la información con context7 para asegurar que sea la más reciente y relevante.**
- Ejecutar `flutter test` y validar CI antes de cada PR.
- Consultar los archivos de ejemplo y pruebas para entender flujos y patrones.

---

## Roadmap y Futuras Etapas

- **Etapa 2:** Incluir métricas avanzadas (`spinrate`, `angleofattack`).
- Mejorar exportación y reportes.
- Internacionalización y soporte multilenguaje.
- Refuerzo de seguridad y privacidad.
- Optimización de rendimiento y escalabilidad.

---

## Referencias

- [`prd-context-sgs-golf.md`](prd-context-sgs-golf.md)
- [`prd-sgs-golf.md`](prd-sgs-golf.md)
- [`tasks-prd-sgs-golf.md`](tasks-prd-sgs-golf.md)
- [Documentación técnica y ejemplos actualizados deben obtenerse y validarse usando context7](https://context7.upstash.io/)

---

Este documento es la referencia central para el equipo y agentes IA. Actualízalo ante cualquier cambio relevante en el proyecto.