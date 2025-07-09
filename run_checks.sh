#!/bin/bash
# Script para ejecutar validaciones locales de Flutter/Dart
# Uso: ./run_checks.sh

set -e

echo "\n==> Verificando formato con dart format..."
dart format --set-exit-if-changed .

echo "\n==> Ejecutando análisis estático con flutter analyze..."
flutter analyze

echo "\n==> Ejecutando pruebas con flutter test..."
flutter test

echo "\n✔️ Todas las validaciones pasaron."
