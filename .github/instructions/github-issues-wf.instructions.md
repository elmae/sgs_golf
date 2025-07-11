## 🧭 Instrucciones para trabajar con GitHub Issues en el repositorio`elmae/sgs_golf`

Sigue este flujo para abordar cualquier issue en este proyecto:

---

### 1. 🧠 Obtén y comprende el contexto

- Lee en elmae/sgs_golf el issue en detalle .
- Consulta los documentos clave disponibles en `docs/`:
  - [`tasks-prd-sgs-golf.md`](docs/tasks-prd-sgs-golf.md)
  - [`knowledge-base.md`](docs/knowledge-base.md) 
- Si el issue es ambiguo, solicita aclaraciones antes de continuar.
 
--- 

### 2. 🔍 Analiza el problema y el alcance

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

### 5. ✅ Valida y prueba

- Ejecuta flutter test y asegúrate de que todas las pruebas pasen. Si alguna prueba falla, corrige todos los errores reportados y vuelve a ejecutar los tests hasta que el resultado sea completamente exitoso.
- Corre el análisis estático con flutter analyze. Si se detectan advertencias o errores, repáralos completamente y vuelve a ejecutar el comando hasta obtener una salida limpia.
- Si agregas dependencias, actualiza y documenta los cambios en `pubspec.yaml`.

---

### 6. 📤 Guarda y sube tus cambios

- Guarda todos los archivos modificados.
- Realiza commit con un mensaje descriptivo, en minúsculas, siguiendo [las reglas de conventional commits](https://www.conventionalcommits.org).
  - 📌 Ejemplos:
    ```bash
    feat(data): agrega integración con api de disponibilidad
    fix(core): corrige validación de usuario en pantalla de reservas
    ```
- Realiza `push` a GitHub para activar el pipeline de CI automáticamente.

---

### 7. 🚀 Prepara el Pull Request

- Solicita autorización del responsable técnico antes de solicitar el PR.
- Si todas las validaciones del pipeline de CI son exitosas (`test`, `analyze`, `coverage`), genera un PR desde `develop` hacia `main`.
- Incluye contexto, dependencias y ejemplos en la descripción.
- Relaciona el PR con el issue correspondiente.

---

### ✅ Checklist antes del PR
completa este checklist para asegurarte de que todo está en orden:
- [ ] El código sigue las [Flutter Coding Standards](flutter-coding-standards.instructions.md)
- [ ] Todos los errores de prueba fueron corregidos y `flutter test` muestra salida limpia
- [ ] Todos los errores y advertencias fueron corregidos y `flutter analyze` muestra salida limpia
- [ ] Las dependencias están actualizadas en `pubspec.yaml` si aplica
- [ ] Commit realizado con formato convencional
- [ ] PR enlazado con el issue correspondiente y documentado

--- 

> **Referencia rápida:**
> - Estructura y archivos clave: ver [`tasks-prd-sgs-golf.md`](docs/tasks-prd-sgs-golf.md) y [`knowledge-base.md`](docs/knowledge-base.md)
> - Criterios de calidad y reglas de colaboración: ver [`knowledge-base.md`](docs/knowledge-base.md)
> - Antes de documentar o implementar dependencias/APIs, consulta el MCP context7 para validar que sean actuales y recomendadas.

