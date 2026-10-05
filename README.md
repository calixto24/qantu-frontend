# qantu

## Requisitos Previos y Configuración del Entorno

Sigue estos pasos detallados para configurar la máquina de desarrollo desde cero antes de ejecutar el proyecto **Qantu Frontend**.

### 1. Instalación del SDK de Dart

1. Descarga el SDK oficial de **Dart** desde su sitio web.
2. Descomprime el archivo descargado.
3. En la raíz de tu disco local `C:\`, crea una carpeta llamada `dart`.
4. Copia y pega el contenido descomprimido dentro de `C:\dart`.
5. Agrega la ruta del directorio `bin` a las variables de entorno del sistema:
   - Copia la ruta: `C:\dart\dart-sdk\bin` (o donde se ubique la carpeta `bin`).
   - Abre **Variables de entorno** en Windows
   - Abre **Variables del sistema**
   - Editar **Path**
   - Agregar la ruta copiada.
6. Abre una terminal (CMD o PowerShell) y verifica la instalación ejecutando:
   ```bash
   dart --version
   ```

### 2. Instalación del SDK de Flutter

1. Clona el repositorio oficial de **Flutter** en su rama estable directamente en el disco `C:\` ejecutando en tu terminal:
   ```bash
   git clone [https://github.com/flutter/flutter.git](https://github.com/flutter/flutter.git) -b stable C:\flutter
   ```
2. Copia y pega el contenido del directorio `C:\flutter\bin` a las variables de entorno del sistema:
   - Copia la ruta: `C:\flutter\bin` (o donde se ubique la carpeta `bin`).
   - Abre **Variables de entorno** en Windows
   - Abre **Variables del sistema**
   - Editar **Path**
   - Agregar la ruta copiada.
3. Verifica la correcta instalación y diagnóstico del entorno ejecutando: `flutter doctor`
4. Si llega fallar, asegurate de tener la direccion bin de git en la variable de entorno `PATH`.

### 3. Extensiones de VS Code

1. Instala Dart
2. Instala Code Runner
3. Instala Flutter

### 4. Ejecución del proyecto

Clona este repositorio y entra a la carpeta del proyecto:

```bash
git clone https://github.com/calixto24/qantu-frontend.git
```

Descarga todas las dependencias necesarias:

```bash
flutter pub get
```

Ejecuta el proyecto:

```bash
flutter run -d chrome
```
