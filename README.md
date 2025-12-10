# 💰 Expense Tracker App (Ordinario)

Una aplicación móvil moderna desarrollada en Flutter para la gestión y seguimiento de gastos personales. Permite a los usuarios registrar, visualizar y analizar sus finanzas de manera intuitiva y segura.

## ✨ Características Principales

*   **Autenticación Segura**:
    *   Registro e inicio de sesión con correo electrónico.
    *   **Verificación por código OTP** (One-Time Password) para mayor seguridad al registrarse.
    *   Gestión de sesiones con Supabase Auth.

*   **Gestión de Gastos**:
    *   Agregar nuevos gastos con monto, descripción, categoría, fecha y método de pago (Efectivo, Tarjeta, Transferencia).
    *   **Edición y Eliminación** de gastos existentes.
    *   Listado de gastos con paginación y carga eficiente.

*   **Dashboard y Análisis**:
    *   **Resumen Financiero**: Visualización rápida del gasto total mensual y diario.
    *   **Desglose Diario**: Lista detallada de gastos agrupados por día con subtotales.
    *   **Filtros Avanzados**: Filtrado por rango de fechas, categorías múltiples y búsqueda textual.

*   **Diseño UI/UX Profesional**:
    *   Interfaz limpia y moderna basada en Material 3.
    *   Animaciones fluidas (Lottie) para estados de carga y listas vacías.
    *   Feedback visual mediante Snackbars y diálogos de confirmación.

## 🛠️ Tecnologías Utilizadas

*   **Frontend**: [Flutter](https://flutter.dev/) (Dart)
*   **Backend & Base de Datos**: [Supabase](https://supabase.com/) (PostgreSQL + Auth)
*   **Gestión de Estado**: `provider`
*   **Navegación**: `go_router`
*   **Gráficos y Animaciones**: `lottie`
*   **Formato de Fecha y Moneda**: `intl`

## 📂 Estructura del Proyecto

El proyecto sigue una arquitectura basada en **Features** (Características) para mantener el código organizado y escalable:

```
lib/
├── core/                   # Componentes compartidos y configuración
│   ├── constants/          # Constantes (ej. Categorías, Iconos)
│   ├── models/             # Modelos de datos (Expense)
│   └── providers/          # Lógica de negocio y estado (AuthProvider, ExpenseProvider)
├── features/               # Módulos principales de la app
│   ├── auth/               # Pantallas y lógica de autenticación (Login, Registro, Verificación, Perfil)
│   ├── expenses/           # Pantallas de lista, detalle y formulario de gastos
│   └── summary/            # Pantalla de resumen y estadísticas
├── routes/                 # Configuración de rutas (GoRouter)
└── main.dart               # Punto de entrada de la aplicación
```

## 🚀 Configuración e Instalación

### Prerrequisitos
*   Flutter SDK instalado (versión estable reciente).
*   Cuenta en Supabase y proyecto configurado.

### Pasos
1.  **Clonar el repositorio** (o descargar el código fuente).
2.  **Instalar dependencias**:
    ```bash
    flutter pub get
    ```
3.  **Configurar Variables de Entorno**:
    Asegúrate de tener configuradas las credenciales de Supabase en `lib/main.dart` (URL y Anon Key).

4.  **Ejecutar la aplicación**:
    ```bash
    flutter run
    ```

## 🔐 Configuración de Supabase (Backend)

Para que el envío de códigos OTP funcione correctamente:
1.  Ir al Dashboard de Supabase -> **Authentication** -> **Email Templates**.
2.  En la plantilla **"Confirm Signup"**, utilizar el siguiente cuerpo para enviar el código numérico:
    ```html
    <h2>Confirma tu cuenta</h2>
    <p>Tu código de seguridad es:</p>
    <h1>{{ .Token }}</h1>
    ```

## 📱 Capturas de Pantalla (Referencia)

*   **Login/Registro**: Acceso seguro con validación.
*   **Mis Gastos**: Listado con filtros horizontales tipo "pill".
*   **Resumen**: Dashboard con tarjetas de totales y desglose histórico.

---
Desarrollado para el proyecto Ordinario.
