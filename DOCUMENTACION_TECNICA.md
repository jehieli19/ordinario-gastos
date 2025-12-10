# Documentación Técnica del Proyecto: Expense Tracker App

Este documento detalla la arquitectura, estructura de carpetas y funcionalidades clave de la aplicación de gestión de gastos.

---

## 1. Arquitectura y Estructura del Proyecto

El proyecto sigue una arquitectura modular basada en **Features (Características)**. Esto significa que el código no está agrupado por tipo de archivo (controladores, vistas, modelos), sino por la **funcionalidad** a la que pertenece. Esto hace que el proyecto sea fácil de escalar y mantener.

### Estructura de Directorios (`lib/`)

```
lib/
│
├── core/                           # Núcleo de la aplicación: Código compartido y esencial
│   ├── constants/                  # Valores constantes (Colores, Iconos, Listas estáticas)
│   │   └── categories.dart         # Define las categorías de gastos, sus iconos y colores.
│   │
│   ├── models/                     # Modelos de datos (La estructura de la información)
│   │   └── expense.dart            # Clase 'Expense' que representa un gasto (monto, fecha, id...).
│   │
│   └── providers/                  # Gestión de Estado (Lógica de negocio)
│       ├── auth_provider.dart      # Maneja el Login, Registro, Logout y Verificación OTP.
│       └── expense_provider.dart   # Maneja la lista de gastos, filtros y conexión con Supabase.
│
├── features/                       # Módulos Funcionales (Las pantallas y widgets específicos)
│   ├── auth/                       # Módulo de Autenticación
│   │   └── screens/
│   │       ├── login_screen.dart       # Pantalla de inicio de sesión.
│   │       ├── register_screen.dart    # Pantalla de registro de nuevos usuarios.
│   │       ├── verify_email_screen.dart# Pantalla para ingresar el código PIN de 6 dígitos.
│   │       ├── profile_screen.dart     # Pantalla de perfil y cierre de sesión.
│   │       └── splash_screen.dart      # Pantalla de carga inicial (verifica si hay sesión activa).
│   │
│   ├── expenses/                   # Módulo de Gestión de Gastos
│   │   ├── screens/
│   │   │   ├── expenses_list_screen.dart # Pantalla principal: Lista de gastos.
│   │   │   ├── expense_detail_screen.dart# Ver detalles, editar y eliminar un gasto.
│   │   │   └── expense_form_screen.dart  # Formulario para Agregar o Editar un gasto.
│   │   └── widgets/
│   │       └── expenses_filters.dart     # Widget de filtros (Fechas y Categorías tipo 'pill').
│   │
│   └── summary/                    # Módulo de Resumen/Dashboard
│       └── screens/
│           └── summary_screen.dart     # Dashboard con tarjetas de totales y desglose diario.
│
├── routes/                         # Configuración de Navegación
│   └── app_router.dart             # Define todas las rutas (URLs) de la app usando GoRouter.
│
└── main.dart                       # Punto de entrada. Inicializa Supabase, Providers y Temas.
```

---

## 2. Descripción de Funcionalidades

### A. Autenticación y Seguridad (`features/auth`)
El sistema utiliza **Supabase Auth** para gestionar usuarios de forma segura.
1.  **Splash Screen**: Al abrir la app, verifica automáticamente si el usuario ya inició sesión. Si sí, lo manda a "Mis Gastos"; si no, al Login.
2.  **Registro con OTP**:
    *   El usuario ingresa su correo y contraseña.
    *   La app solicita a Supabase crear el usuario.
    *   Supabase envía un **correo con un código de 6 dígitos**.
    *   La app redirige a la pantalla de **Verificación**, donde el usuario ingresa ese código para activar su cuenta.
3.  **Login/Logout**: Inicio y cierre de sesión estándar.

### B. Gestión de Gastos (`features/expenses`)
Es el corazón de la app. Utiliza `ExpenseProvider` para comunicar la UI con la base de datos.
1.  **Listado de Gastos**:
    *   Muestra una lista con scroll infinito (o paginada).
    *   **Empty State**: Si no hay gastos, muestra una animación Lottie amigable.
2.  **Filtrado Inteligente**:
    *   Barra de búsqueda por texto.
    *   Selector de rango de fechas.
    *   Carrusel horizontal de categorías (Alimentación, Transporte, etc.) para filtrar rápidamente.
3.  **CRUD Completo**:
    *   **Crear**: Formulario validado para ingresar monto, descripción, etc.
    *   **Leer**: Ver detalles en una tarjeta estilizada.
    *   **Actualizar**: El botón "Editar" carga los datos existentes para modificarlos.
    *   **Eliminar**: Borrado lógico o físico del gasto.

### C. Dashboard Financiero (`features/summary`)
Una vista analítica para que el usuario entienda sus finanzas.
1.  **Tarjetas de Resumen**: Dos tarjetas grandes en la parte superior muestran el **Total del Mes** y el **Total del Día** actual.
2.  **Desglose Agrupado**: Debajo, una lista agrupa los gastos por día (ej: "Lunes 10 de Diciembre") y muestra el **subtotal** de ese día específico, permitiendo ver qué días se gastó más.

---

## 3. Flujo de Datos (Cómo funciona por dentro)

1.  **Usuario realiza acción** (ej: Click en "Guardar Gasto").
2.  **UI** llama a un método del **Provider** (`expenseProvider.addExpense(...)`).
3.  **Provider** contacta a **Supabase** (la nube) para guardar el dato real.
4.  **Supabase** responde con éxito.
5.  **Provider** actualiza su lista local y **notifica** (`notifyListeners()`) a la UI.
6.  **UI** se reconstruye automáticamente mostrando el nuevo gasto en la lista.

Este ciclo asegura que la aplicación sea **reactiva**: lo que ves en pantalla siempre está sincronizado con los datos reales.
