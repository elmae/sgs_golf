## Relevant Files

### Configuración y Core
- `devgolf/sgs_golf/pubspec.yaml` - Definición de las dependencias del proyecto (Hive, Provider/Riverpod, fl_chart, etc.).
- `devgolf/sgs_golf/lib/main.dart` - Punto de entrada de la aplicación Flutter, inicialización de Hive y providers.
- `devgolf/sgs_golf/lib/app.dart` - Configuración principal de la app, incluyendo tema, rutas y navegación.
- `devgolf/sgs_golf/lib/core/constants/app_constants.dart` - Constantes globales de la aplicación.
- `devgolf/sgs_golf/lib/core/theme/app_theme.dart` - Definición del tema visual (colores naranja, azul, verde y gris).
- `devgolf/sgs_golf/lib/core/navigation/app_router.dart` - Configuración del enrutador para navegación.
- `devgolf/sgs_golf/lib/core/errors/error_handler.dart` - Manejo centralizado de errores.

### Modelos de Datos y Repositorios
- `devgolf/sgs_golf/lib/data/models/user.dart` - Modelo de datos para el usuario.
- `devgolf/sgs_golf/lib/data/models/golf_club.dart` - Modelo que define los tipos de palos (PW, GW, SW, LW).
- `devgolf/sgs_golf/lib/data/models/shot.dart` - Modelo para un tiro individual.
- `devgolf/sgs_golf/lib/data/models/practice_session.dart` - Modelo para la sesión completa de práctica.
- `devgolf/sgs_golf/lib/data/repositories/auth_repository.dart` - Lógica de autenticación local.
- `devgolf/sgs_golf/lib/data/repositories/practice_repository.dart` - Gestión de sesiones y tiros.
- `devgolf/sgs_golf/lib/data/repositories/analytics_repository.dart` - Cálculo de estadísticas y métricas.
- `devgolf/sgs_golf/lib/data/services/hive_service.dart` - Servicio para manejar la persistencia con Hive.
- `devgolf/sgs_golf/lib/data/services/export_service.dart` - Servicio para exportación de datos.

### Características - Autenticación
- `devgolf/sgs_golf/lib/features/auth/login_screen.dart` - Pantalla de inicio de sesión.
- `devgolf/sgs_golf/lib/features/auth/register_screen.dart` - Pantalla de registro.
- `devgolf/sgs_golf/lib/features/auth/providers/auth_provider.dart` - Provider para gestión del estado de autenticación.
- `devgolf/sgs_golf/test/features/auth/auth_repository_test.dart` - Pruebas para el repositorio de autenticación.
- `devgolf/sgs_golf/test/features/auth/login_screen_test.dart` - Pruebas para la pantalla de inicio de sesión.

### Características - Práctica
- `devgolf/sgs_golf/lib/features/practice/practice_screen.dart` - Pantalla principal para registrar una sesión.
- `devgolf/sgs_golf/lib/features/practice/club_selector_widget.dart` - Selector de palo de golf.
- `devgolf/sgs_golf/lib/features/practice/distance_input_widget.dart` - Input para la distancia del tiro.
- `devgolf/sgs_golf/lib/features/practice/shot_counter_widget.dart` - Contador de tiros por palo.
- `devgolf/sgs_golf/lib/features/practice/providers/practice_provider.dart` - Provider para la sesión activa.
- `devgolf/sgs_golf/test/features/practice/practice_repository_test.dart` - Pruebas para el repositorio.
- `devgolf/sgs_golf/test/features/practice/practice_screen_test.dart` - Pruebas para la pantalla de práctica.

### Características - Dashboard
- `devgolf/sgs_golf/lib/features/dashboard/dashboard_screen.dart` - Pantalla principal con acceso a todas las funciones.
- `devgolf/sgs_golf/lib/features/dashboard/session_list_widget.dart` - Lista de sesiones previas.
- `devgolf/sgs_golf/lib/shared/widgets/session_card.dart` - Card reutilizable para mostrar información de sesión.
- `devgolf/sgs_golf/lib/features/dashboard/providers/dashboard_provider.dart` - Provider para el dashboard.
- `devgolf/sgs_golf/test/features/dashboard/dashboard_screen_test.dart` - Pruebas para el dashboard.

### Características - Análisis
- `devgolf/sgs_golf/lib/features/analysis/analysis_screen.dart` - Pantalla para visualización de estadísticas.
- `devgolf/sgs_golf/lib/features/analysis/charts/distance_chart_widget.dart` - Gráfico de distancias.
- `devgolf/sgs_golf/lib/features/analysis/charts/consistency_chart_widget.dart` - Gráfico de consistencia.
- `devgolf/sgs_golf/lib/features/analysis/providers/analysis_provider.dart` - Provider para análisis de datos.
- `devgolf/sgs_golf/test/features/analysis/analytics_repository_test.dart` - Pruebas para cálculos estadísticos.
- `devgolf/sgs_golf/test/features/analysis/analysis_screen_test.dart` - Pruebas para la pantalla de análisis.

### Características - Exportación
- `devgolf/sgs_golf/lib/features/export/export_screen.dart` - Pantalla para exportación de datos.
- `devgolf/sgs_golf/lib/features/export/providers/export_provider.dart` - Provider para exportación.
- `devgolf/sgs_golf/test/features/export/export_service_test.dart` - Pruebas para el servicio de exportación.
- `devgolf/sgs_golf/test/features/export/export_screen_test.dart` - Pruebas para la pantalla de exportación.

### CI/CD y Configuración
- `devgolf/sgs_golf/.github/workflows/ci.yml` - Workflow de GitHub Actions para integración continua.
- `devgolf/sgs_golf/analysis_options.yaml` - Configuración para análisis estático del código.
- `devgolf/sgs_golf/docs/prd-sgs-golf.md` - Documentación del proyecto. 
- `devgolf/sgs_golf/docs/prd-context-sgs-golf.md` - Instrucciones de instalación y uso.

### Notes

- Los archivos de prueba deben ubicarse en el directorio `test/`, replicando la estructura del directorio `lib/`.
- Los archivos de documentacion deben ubicarse en el directorio `docs/`.
- Utiliza `flutter test` para ejecutar todas las pruebas desde la raíz del proyecto `devgolf/sgs_golf`.
- Para gráficos, se sugiere utilizar `fl_chart` debido a su flexibilidad y documentación.

## Tasks

- [x] 1.0 Configuración Inicial del Proyecto y Estructura de Módulos
  - [x] 1.1 Inicializar el proyecto Flutter en `devgolf/sgs_golf` con `flutter create --org com.sgs --project-name sgs_golf .`.
  - [x] 1.2 Inicializar Repositorio Git y configurar flujo de ramas
    - [x] 1.2.1 Inicializar el repositorio con `git init` en la carpeta `devgolf/sgs_golf`.
    - [x] 1.2.2 Crear un archivo `.gitignore` con las exclusiones típicas para un proyecto Flutter.
    - [x] 1.2.3 ``
    - [x] 1.2.4 Añadir `.gitignore` al stage y realizar el primer commit con `git add .` y `git commit -m "feat: initial commit"`.
    - [x] 1.2.5 Agregar el repositorio remoto con `git remote add origin git@github.com:elmae/sgs_golf.git`.
    - [x] 1.2.6 Crear la rama `main`, y subirla al remoto con `git checkout -b main` y `git push -u origin main`.
    - [x] 1.2.7 Crear la rama `develop`, y subirla al remoto con `git checkout -b develop` y `git push -u origin develop`.
  - [x] 1.3 Configurar `pubspec.yaml` con las dependencias precisas:
    - [x] 1.3.1 Base de datos local: `hive: ^2.2.3`, `hive_flutter: ^1.1.0`, `path_provider: ^2.1.1`
    - [x] 1.3.2 Gestión de estado: `provider: ^6.1.1` (o `flutter_riverpod: ^2.4.9` si se prefiere)
    - [x] 1.3.3 Visualización: `fl_chart: ^0.65.0` para gráficos
    - [x] 1.3.4 Exportación: `csv: ^5.1.1`, `file_picker: ^6.1.1`, `path_provider: ^2.1.1`
    - [x] 1.3.5 Desarrollo: `flutter_lints: ^3.0.1`, `mocktail: ^1.0.2` para pruebas
  - [x] 1.4 Crear la estructura de carpetas siguiendo arquitectura modular:
    - [x] 1.4.1 Carpetas core: `lib/core/constants`, `lib/core/theme`, `lib/core/navigation`, `lib/core/errors`
    - [x] 1.4.2 Carpetas de datos: `lib/data/models`, `lib/data/repositories`, `lib/data/services`
    - [x] 1.4.3 Features principales: `lib/features/auth`, `lib/features/practice`, `lib/features/dashboard`, `lib/features/analysis`, `lib/features/export`
    - [x] 1.4.4 Componentes compartidos: `lib/shared/widgets`, `lib/shared/utils`
  - [x] 1.5 Configurar Hive para persistencia de datos:
    - [x] 1.5.1 Crear adaptadores de Hive para los modelos `@HiveType`
    - [x] 1.5.2 Registrar adaptadores en `main.dart`
    - [x] 1.5.3 Inicializar Hive y abrir las cajas necesarias
  - [x] 1.6 Implementar tema y enrutamiento:
    - [x] 1.6.1 Crear `app_theme.dart` con la paleta naranja, azul, verde y gris
    - [x] 1.6.2 Configurar `app_router.dart` con navegación basada en Navigator 2.0
    - [x] 1.6.3 Implementar esquema de rutas nombradas para todas las pantallas
  - [x] 1.7 Configurar análisis estático y CI:
    - [x] 1.7.1 Personalizar `analysis_options.yaml` para reglas de estilo específicas
  - [x] 1.8 Configurar CI/CD con GitHub Actions
    - [x] 1.8.1 Crear directorio `.github/workflows` con archivo CI para pruebas automatizadas
    - [x] 1.8.2 Configurar reporte de cobertura con flutter test --coverage y Coveralls
    - [x] 1.8.3 Añadir paso de verificación de formato con flutter format .
    - [x] 1.8.4 Configurar validación de lint con flutter analyze
    - [x] 1.8.5 Ejecutar flutter test --coverage para pruebas unitarias y de widgets
    - [x] 1.8.6 Validar cobertura mínima
    - [x] 1.8.7 Enforce commits semánticos
    - [x] 1.8.8 Validar estructura de ramas (feature/, fix/, hotfix/)
  - [x] 1.9 Actualizar README.md
    - [x] 1.9.1 Documentar arquitectura del proyecto
    - [x] 1.9.2 Documentar flujo de datos entre providers y repositorios
    - [x] 1.9.3 Documentar comandos útiles para agentes IA

- [x] 2.0 Implementación del Módulo de Autenticación y Gestión de Usuario
  - [x] 2.1 Modelado de datos del usuario:
    - [x] 2.1.1 Definir el modelo `User` con campos para ID, nombre, correo y contraseña
    - [x] 2.1.2 Crear adaptador Hive para `User`
    - [x] 2.1.3 Implementar validaciones de datos
  - [x] 2.2 Implementación del servicio de autenticación:
    - [x] 2.2.1 Crear `auth_service.dart` para encapsular funciones de hash y validación
    - [x] 2.2.2 Implementar `AuthRepository` con métodos register(), login(), logout(), updateProfile()
    - [x] 2.2.3 Añadir persistencia de sesión para mantener la sesión activa
  - [x] 2.3 Desarrollo de interfaz de usuario:
    - [x] 2.3.1 Diseñar e implementar `login_screen.dart` con campos y validación
    - [x] 2.3.2 Crear `register_screen.dart` con formulario completo y validaciones
    - [x] 2.3.3 Implementar transiciones y mensajes de error
  - [x] 2.4 Gestión de estado para autenticación:
    - [x] 2.4.1 Crear `auth_provider.dart` con estados de carga, error y autenticado
    - [x] 2.4.2 Integrar Provider con widgets para reflejar cambios de estado
    - [x] 2.4.3 Implementar manejo de errores y mensajes al usuario
  - [x] 2.5 Pruebas:
    - [x] 2.5.1 Escribir pruebas unitarias para `AuthRepository`
    - [x] 2.5.2 Escribir pruebas de widget para `login_screen.dart` y `register_screen.dart`
    - [x] 2.5.3 Probar flujos de error y validación

- [x] 3.0 Desarrollo del Módulo de Sesiones de Práctica (Core de la Aplicación)
  - [x] 3.1 Modelado de datos clave:
    - [x] 3.1.1 Definir enum `GolfClubType` para palos (PW, GW, SW, LW)
    - [x] 3.1.2 Crear modelo `Shot` con campos para tipo de palo, distancia y timestamp
    - [x] 3.1.3 Implementar `PracticeSession` con fecha, duración, lista de tiros y resumen
    - [x] 3.1.4 Diseñar adaptadores Hive para todos los modelos
  - [ ] 3.2 Lógica de negocio para sesiones:
    - [ ] 3.2.1 Crear `PracticeRepository` para la gestión CRUD de sesiones
    - [ ] 3.2.2 Implementar métodos para añadir tiros a una sesión activa
    - [ ] 3.2.3 Añadir cálculos de estadísticas por sesión y palo
    - [ ] 3.2.4 Crear métodos para obtener conteos y promedios por palo
  - [ ] 3.3 Interfaz de práctica:
    - [ ] 3.3.1 Diseñar `club_selector_widget.dart` visual e interactivo
    - [ ] 3.3.2 Implementar `distance_input_widget.dart` con validación numérica
    - [ ] 3.3.3 Crear `shot_counter_widget.dart` para mostrar contadores por palo
    - [ ] 3.3.4 Integrar todo en `practice_screen.dart` con flujo intuitivo
  - [ ] 3.4 Gestión de estado para práctica:
    - [ ] 3.4.1 Crear `practice_provider.dart` para mantener estado de sesión activa
    - [ ] 3.4.2 Implementar métodos para cambiar de palo, guardar tiros y finalizar sesión
    - [ ] 3.4.3 Mantener estadísticas en tiempo real durante la sesión
  - [ ] 3.5 Pruebas exhaustivas:
    - [ ] 3.5.1 Probar métodos CRUD en `PracticeRepository`
    - [ ] 3.5.2 Escribir tests para cálculos estadísticos
    - [ ] 3.5.3 Realizar pruebas de integración del flujo completo de práctica

- [ ] 4.0 Creación del Dashboard y Módulo de Análisis de Datos
  - [ ] 4.1 Desarrollo del Dashboard:
    - [ ] 4.1.1 Diseñar `dashboard_screen.dart` como hub central de la aplicación
    - [ ] 4.1.2 Implementar `session_list_widget.dart` con ordenamiento y filtrado
    - [ ] 4.1.3 Crear `session_card.dart` como widget reutilizable con resumen de estadísticas
    - [ ] 4.1.4 Añadir acciones rápidas para iniciar sesión, ver análisis y exportar
  - [ ] 4.2 Componentes visuales compartidos:
    - [ ] 4.2.1 Diseñar tarjetas y botones con la paleta de colores definida
    - [ ] 4.2.2 Implementar animaciones sutiles para mejorar UX
    - [ ] 4.2.3 Crear componentes de carga y estados vacíos
  - [ ] 4.3 Módulo de análisis avanzado:
    - [ ] 4.3.1 Implementar `AnalyticsRepository` para cálculos estadísticos complejos
    - [ ] 4.3.2 Desarrollar funciones para calcular consistencia (desviación estándar)
    - [ ] 4.3.3 Crear métodos para comparar rendimiento entre sesiones
  - [ ] 4.4 Visualización de datos:
    - [ ] 4.4.1 Implementar `distance_chart_widget.dart` para gráficas de distancia por palo
    - [ ] 4.4.2 Crear `consistency_chart_widget.dart` para visualizar consistencia
    - [ ] 4.4.3 Añadir filtros temporales (última semana, mes, trimestre)
    - [ ] 4.4.4 Implementar tabla comparativa entre sesiones
  - [ ] 4.5 Gestión de estado para análisis:
    - [ ] 4.5.1 Crear `analysis_provider.dart` para manejar los filtros y cálculos
    - [ ] 4.5.2 Implementar carga eficiente de datos y caching
  - [ ] 4.6 Pruebas de visualización:
    - [ ] 4.6.1 Probar cálculos estadísticos con datos de muestra
    - [ ] 4.6.2 Verificar renderizado correcto de gráficos
    - [ ] 4.6.3 Probar filtros y comparativas

- [ ] 5.0 Implementación de la Funcionalidad de Exportación de Datos y Finalización
  - [ ] 5.1 Servicio de exportación:
    - [ ] 5.1.1 Crear `export_service.dart` para manejar la conversión de datos
    - [ ] 5.1.2 Implementar exportación a CSV con encabezados descriptivos
    - [ ] 5.1.3 Añadir soporte para múltiples formatos (CSV, PDF básico)
  - [ ] 5.2 Interfaz de exportación:
    - [ ] 5.2.1 Diseñar `export_screen.dart` con opciones de formato y filtros
    - [ ] 5.2.2 Implementar selección de sesiones para exportación
    - [ ] 5.2.3 Añadir previsualización de datos a exportar
  - [ ] 5.3 Acceso al sistema de archivos:
    - [ ] 5.3.1 Integrar con `path_provider` para manejo de directorios
    - [ ] 5.3.2 Implementar selección de ubicación para guardar
    - [ ] 5.3.3 Solicitar permisos necesarios en Android
  - [ ] 5.4 Pruebas de integración:
    - [ ] 5.4.1 Probar flujo completo: Login → Práctica → Dashboard → Análisis → Exportación
    - [ ] 5.4.2 Verificar integridad de los datos exportados
    - [ ] 5.4.3 Realizar pruebas en dispositivos físicos
  - [ ] 5.5 Configuración para producción:
    - [ ] 5.5.1 Configurar CI/CD con GitHub Actions
    - [ ] 5.5.2 Implementar análisis estático y pruebas automatizadas
    - [ ] 5.5.3 Optimizar el rendimiento y tamaño de la aplicación
    - [ ] 5.5.4 Crear documentación de usuario final
  - [ ] 5.6 Preparación para futuras métricas:
    - [ ] 5.6.1 Diseñar la estructura para soportar `spinrate` y `angleofattack` en el futuro
    - [ ] 5.6.2 Documentar los puntos de extensión del código
