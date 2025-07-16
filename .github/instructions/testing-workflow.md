# Flujo de Trabajo para Pruebas en SGS Golf

Este documento describe el proceso detallado para ejecutar pruebas, validar el código y resolver errores en el proyecto SGS Golf.

## 📋 Proceso de Validación

### 1. Preparación del Entorno

Antes de comenzar cualquier proceso de prueba, asegúrate de tener actualizado el proyecto:

```bash
flutter pub get
```

### 2. Formateo de Código

El formateo del código es el primer paso para mantener la consistencia:

```bash
dart format .
```

Esto formateará automáticamente todo el código según las convenciones de Dart, facilitando la lectura y mantenimiento.

### 3. Análisis Estático

Ejecuta el análisis estático para detectar problemas potenciales:

```bash
flutter analyze
```

### 4. Ejecución de Pruebas Unitarias

Ejecuta las pruebas unitarias para verificar la funcionalidad correcta:

```bash
flutter test
```

Para obtener métricas de cobertura:

```bash
flutter test --coverage
```

Visualiza el informe de cobertura:

```bash
genhtml coverage/lcov.info -o coverage/html
```

### 5. Validación Completa

El script `run_checks.sh` realiza todas estas validaciones en secuencia:

```bash
./run_checks.sh
```

## 🔍 Resolución de Problemas Comunes

### Errores de Formato

Si `dart format` reporta problemas:

1. Revisa los archivos indicados.
2. Corrige manualmente la indentación y espaciado si es necesario.
3. Ejecuta nuevamente `dart format .` para verificar.

### Problemas de Análisis

Si `flutter analyze` detecta problemas:

1. **Errores de tipo**:
   - Verifica que los tipos de variables y parámetros sean correctos.
   - Asegúrate de manejar correctamente los valores nulos con `?` y `!`.

2. **Importaciones no utilizadas**:
   - Elimina las importaciones no utilizadas.
   - Usa herramientas como "Organize Imports" en VS Code.

3. **Parámetros requeridos**:
   - Asegúrate de proporcionar todos los parámetros requeridos en constructores y métodos.

4. **Código muerto**:
   - Elimina variables o métodos no utilizados.

5. **Problemas con `const`**:
   - Añade `const` a constructores de widgets cuando sea posible.

### Fallos en las Pruebas

Si `flutter test` falla:

1. **Examina el resultado**:
   - Identifica qué pruebas están fallando y en qué archivo.
   - Lee los mensajes de error para entender la causa raíz.

2. **Problemas comunes**:
   - **Valores nulos inesperados**: Verifica que todos los objetos estén inicializados correctamente.
   - **Aserciones fallidas**: Revisa las expectativas y asegúrate que coincidan con los resultados actuales.
   - **Tiempo de espera**: Revisa operaciones asíncronas que puedan estar bloqueadas.

3. **Pruebas de widgets**:
   - Asegúrate de llamar a `await tester.pumpAndSettle()` después de acciones que desencadenan animaciones.
   - Verifica que los mocks estén configurados correctamente.

4. **Solución paso a paso**:
   - Ejecuta pruebas individuales para aislar el problema: `flutter test test/ruta/al/archivo_test.dart`
   - Añade `print` temporales para depurar valores problemáticos.
   - Corrige los problemas y vuelve a ejecutar las pruebas hasta que pasen.

## 🔄 Ciclo de Trabajo Completo

Para garantizar código de alta calidad, sigue este ciclo cada vez que realices cambios significativos:

1. Desarrolla tus cambios.
2. Ejecuta `dart format .` para formatear el código.
3. Ejecuta `flutter analyze` y corrige todos los problemas.
4. Escribe o actualiza pruebas para los cambios realizados.
5. Ejecuta `flutter test` y corrige cualquier fallo.
6. Ejecuta `flutter test --coverage` para verificar la cobertura.
7. Repite los pasos 3-6 hasta obtener una salida limpia sin errores.

## 📊 Objetivos de Calidad

- **Análisis**: Cero errores o advertencias en `flutter analyze`.
- **Pruebas**: 100% de las pruebas deben pasar.
- **Cobertura**: Mínimo 80% de cobertura para código crítico.
- **Formato**: Todo el código debe cumplir con las reglas de formato de Dart.

## 🚫 Errores Críticos que Bloquean los Commits

Los siguientes errores impedirán que el código sea aceptado:

1. Errores de compilación o análisis estático.
2. Pruebas unitarias o de widgets fallidas.
3. Cobertura por debajo del mínimo establecido.
4. Formato de código no estándar.
5. Violaciones a los principios de arquitectura establecidos.

## ✅ Lista de Verificación Final

Antes de crear una solicitud de pull request, verifica:

- [ ] El código está formateado según los estándares (`dart format .`)
- [ ] No hay errores ni advertencias de análisis (`flutter analyze`)
- [ ] Todas las pruebas pasan (`flutter test`)
- [ ] La cobertura de código es adecuada (`flutter test --coverage`)
- [ ] El código sigue las prácticas y arquitectura del proyecto
- [ ] Se han documentado todas las clases y métodos públicos
- [ ] El mensaje de commit sigue el formato convencional

Siguiendo este flujo de trabajo garantizarás que tu código mantenga la alta calidad esperada en el proyecto SGS Golf.
