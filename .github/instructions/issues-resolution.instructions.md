# 🧭 Instrucciones para trabajar con la resolucion de issues en GitHub

Sigue este flujo para abordar cualquier issue en este proyecto en el repositorio`elmae/sgs_golf`:

---

### 1. 🧠 Obtén y comprende el contexto

- Asegúrate de tener acceso al repositorio `elmae/sgs_golf` en GitHub. Usa el MCP server `github-mcp`.
- Lee en elmae/sgs_golf el issue solicitado, en detalle. 
- en caso de ser necesario, Consulta los documentos clave disponibles en `docs/`:
  - [`tasks-prd-sgs-golf.md`](docs/tasks-prd-sgs-golf.md)
  - [`knowledge-base.md`](docs/knowledge-base.md) 
- Si el issue es ambiguo, solicita aclaraciones antes de continuar.
- Antes de documentar o implementar dependencias/APIs, consulta el MCP context7 para validar que sean actuales y recomendadas.
 
--- 

### 2. 🔍 Analiza el problema (issue) y el alcance

- Identifica los archivos y módulos relevantes:
  - Revisa el árbol de directorios en `lib/` para ubicar módulos relacionados.
  - Comprende la estructura modular del proyecto: `core`, `data`, `features`, `shared`.
- Revisa el historial de commits y PRs relacionados para entender cambios previos.
- Consulta el código fuente de módulos relacionados para entender su funcionamiento.
- Si es necesario, revisa la documentación de APIs o dependencias relevantes.
- Si el issue es un bug, reproduce el error localmente para entender su causa.
- Si es una nueva funcionalidad, revisa los requisitos y casos de uso esperados.
- Si es una mejora, revisa el código actual y cómo se relaciona con la funcionalidad existente.
- Si es una tarea de mantenimiento, revisa el código afectado y su impacto en el sistema.
- Si es una tarea de refactorización, identifica áreas del código que necesitan mejoras.
- Si es una tarea de documentación, revisa el contenido actual y qué información falta.
- Si es una tarea de pruebas, revisa los casos de prueba existentes y qué cobertura falta.
- Si es una tarea de optimización, identifica cuellos de botella o áreas de mejora en el rendimiento.
- Si es una tarea de actualización de dependencias, revisa las versiones actuales y
- Evalúa el impacto del cambio (lógica central, UI, rendimiento, etc.). 

---
 
### 3. 🧩 Desglosa la solución en tareas pequeñas

- Divide el trabajo en subtareas manejables.
- Documenta dependencias y orden lógico.
- Prioriza la separación entre lógica de negocio, UI y estructura modular.

---

### 4. 🛠️ Implementa la solución

- Desarrolla cada issue en tu entorno local, trabajando directamente sobre la rama `develop`.
- Sigue la estructura modular del proyecto:
  - `lib/core`, `lib/data`, `lib/features`, `lib/shared`
- Utiliza únicamente librerías estables y validadas. Consulta `context7` si hay dudas.
- Documenta cada módulo, función pública y ejemplo de uso.
- No mezcles lógica de negocio en widgets.

---

### 5. ✅ Flujo de Trabajo para Pruebas en SGS Golf

Proceso detallado para ejecutar pruebas, validar el código y resolver errores en el proyecto SGS Golf, sigue las instrucciones detalladas en:
- [`testing-workflow.md`](testing-workflow.md)


---`

### 6. 📤 Guarda y sube tus cambios

- Detectar cambios con `git status`. 
- Agrega los archivos modificados con `git add .`.
- Realiza un `git commit` siguiendo las convenciones de commits:
  - Usa mensajes descriptivos y claros.
  - Los mensajes no deben exceder los 100 caracteres.
  - Usa el formato de encabezado `tipo(área): descripción breve`.
  - Usa solo letras minusculas.
  - 📌 Ejemplos:
    ```bash
    feat(data): agrega integración con api de disponibilidad
    fix(core): corrige validación de usuario en pantalla de reservas
    ```- 
- Realiza un `git push` a tu rama `develop` en el repositorio remoto.

---

### 7. 🚀 Prepara el Pull Request

- Solicita autorización del responsable técnico antes de solicitar el PR.
- Si todas las validaciones del pipeline de CI son exitosas (`test`, `analyze`), genera un PR desde `develop` hacia `main`.
- Incluye contexto, dependencias y ejemplos en la descripción.
- Relaciona el PR con el issue correspondiente.

---

### 8. ✅ Checklist antes del PR
completa este checklist para asegurarte de que todo está en orden:
- [ ] El código sigue las Flutter Coding Standards
- [ ] Todos los errores de prueba fueron corregidos y `flutter test` muestra salida limpia
- [ ] Todos los errores y advertencias fueron corregidos y `flutter analyze` muestra salida limpia
- [ ] El código está formateado correctamente con `dart format .`
- [ ] Las dependencias están actualizadas en `pubspec.yaml` si aplica
- [ ] Commit realizado con formato convencional
- [ ] PR enlazado con el issue correspondiente y documentado


---
Estas instrucciones son obligatorias y deben ser seguidas en todo momento cuando se trabaja en este repositorio.