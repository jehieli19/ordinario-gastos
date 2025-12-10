# Estructura del Proyecto: Ordinario

Este archivo detalla la organización de carpetas y archivos del código fuente de la aplicación.

```text
c:/Ordinario/
│
├── lib/
│   │
│   ├── core/                           # NÚCLEO: Lógica y configuraciones compartidas
│   │   ├── constants/
│   │   │   └── categories.dart         # Definición de categorías (iconos, colores, nombres)
│   │   │
│   │   ├── models/                     # MODELOS DE DATOS
│   │   │   └── expense.dart            # Estructura de un Gasto (id, monto, fecha, etc.)
│   │   │
│   │   └── providers/                  # ESTADO GLOBAL (Provider)
│   │       ├── auth_provider.dart      # Lógica de Login, Registro y OTP
│   │       └── expense_provider.dart   # Lógica CRUD de Gastos y filtros
│   │
│   ├── features/                       # CARACTERÍSTICAS (Pantallas agrupadas por funcionalidad)
│   │   │
│   │   ├── auth/                       # Módulo de Autenticación
│   │   │   └── screens/
│   │   │       ├── login_screen.dart       # Pantalla de Login
│   │   │       ├── register_screen.dart    # Pantalla de Registro
│   │   │       ├── verify_email_screen.dart# Pantalla de PIN (Código de 6 dígitos)
│   │   │       ├── profile_screen.dart     # Pantalla de Perfil
│   │   │       └── splash_screen.dart      # Pantalla de carga inicial
│   │   │
│   │   ├── expenses/                   # Módulo de Gastos
│   │   │   ├── screens/
│   │   │   │   ├── expenses_list_screen.dart # Lista principal de gastos
│   │   │   │   ├── expense_detail_screen.dart# Vista de detalle de un gasto
│   │   │   │   └── expense_form_screen.dart  # Formulario (Crear/Editar)
│   │   │   └── widgets/
│   │   │       └── expenses_filters.dart     # Widget de filtros horizontales
│   │   │
│   │   └── summary/                    # Módulo de Resumen
│   │       └── screens/
│   │           └── summary_screen.dart     # Dashboard financiero
│   │
│   ├── routes/                         # NAVEGACIÓN
│   │   └── app_router.dart             # Configuración de rutas (GoRouter)
│   │
│   └── main.dart                       # PUNTO DE ENTRADA (Inicialización)
│
├── pubspec.yaml                        # Dependencias del proyecto (Librerías)
└── README.md                           # Documentación general
```
