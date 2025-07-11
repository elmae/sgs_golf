# Documento de Requerimientos del Producto (PRD)

## Nombre del Proyecto
SGS Golf

## Objetivo
Desarrollar una aplicación móvil para Android (Flutter) que permita a golfistas registrar y analizar sus sesiones de práctica de juego corto, enfocándose en la distancia de tiros realizados con palos específicos (PW, GW, SW, LW). La app debe ser intuitiva, moderna, fácil y divertida de usar.

## Público Objetivo
Golfistas aficionados y avanzados interesados en mejorar la consistencia y precisión de su juego corto.

## Funcionalidades Principales

- **Registro de usuario y autenticación**: Inicio de sesión con usuario y contraseña.
- **Pantalla de práctica**:
  - Selección de palo (PW, GW, SW, LW).
  - Registro de distancia (yardas) de cada tiro.
  - Botón para guardar cada entrada.
  - Contador de tiros realizados por palo.
  - Cálculo y visualización del promedio de distancia por palo.
  - Cambio de palo durante la sesión.
  - Opción para terminar la sesión y guardar todos los datos.
- **Dashboard**:
  - Acceso a sesiones de práctica anteriores.
  - Enlace a sección de análisis.
- **Análisis**:
  - Comparación de promedios de distancia por palo entre sesiones.
  - Visualización de consistencia y progreso.

## Requisitos de Interfaz de Usuario

- Interfaz simple, intuitiva y moderna.
- Paleta de colores sugerida: naranja, azul, verde y gris (tonalidades a definir en diseño).
- Experiencia de usuario divertida y ágil.

## Requisitos Técnicos

- Plataforma: Android (Flutter).
- Uso exclusivo de librerías actualizadas y estables (no RC ni deprecated).
- Estructura modular, código limpio y documentado.
- Flujo de trabajo basado en tareas convertidas a issues de GitHub.
- Integración de GitHub Actions para pruebas, formateo y control de calidad.
- Branches principales: `main` y `develop`. Cada tarea en branch propio.
- Cada tarea debe referenciar dependencias y contexto relevante.
- Al finalizar cada tarea: resumen de contexto, PR, pruebas automáticas y validación de integración.

## Restricciones

- El desarrollo se realizará exclusivamente en la carpeta `devflow/sgs_golf`.
- El equipo de desarrollo es un solo usuario asistido por IA.
- Durante el proceso de desarrollo de esta app solo se deben utilizar librerías y dependencias actualizadas. **Bajo ningún punto se debe utilizar** librerías RC o deprecated.

## Criterios de Aceptación

- El PRD debe cubrir todos los requisitos funcionales y no funcionales.
- Debe servir como base para la descomposición de tareas y planificación.
- Debe estar alineado con el flujo de trabajo y estándares definidos.

## Roadmap / Futuras Etapas

- **Etapa 2**: Se incluirá el registro de las métricas adicionales `spinrate` y `angleofattack` para cada tiro, permitiendo un análisis más avanzado del desempeño.

## Referencias y Contexto

- Este documento será la referencia principal para la siguiente fase de descomposición de tareas y definición de issues.
- Se actualizará conforme se definan detalles adicionales en la planeación.
