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

- Seguir las instrucciones detalladas en:
[best-practices.md](instructions/best-practices.md)

## 🧭 Instrucciones para Resolucion Issues en GitHub

- Sigue este procedimiento para resolución de issues, cuando el usuario te solicite resolver un issue.
[issues-resolution.instructions.md](instructions/issues-resolution.instructions.md)



