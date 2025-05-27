# Boteco_PRO Flutter App

Aplicativo Flutter completo para o restaurante **Boteco_PRO**, integrando com a API FastAPI + SQL Server.

## 🎯 Funcionalidades

- Tela de Login com autenticação real
- Painel adaptado por perfil de usuário
- Gestão de:
  - Estoque
  - Funcionários
  - Pedidos
  - Pratos
  - Faturamento
- Splash screen + persistência de login (`SharedPreferences`)
- Navegação protegida e controlada por rotas

## 🧰 Tecnologias

- Flutter 3+
- Dart
- Shared Preferences
- HTTP + JWT
- MVC Modular

## 📦 Instalação

```bash
cd boteco_pro_flutter

flutter pub get
flutter run
```

📍 Use `http://10.0.2.2:8000` no Android Emulator para consumir a API local.

## 🧭 Estrutura

```
lib/
├── core/                # Models, services e constantes de API
├── modules/             # Módulos organizados por domínio
├── routes/              # Rotas nomeadas
└── main.dart
```

## ✅ Status atual

✅ Login seguro  
✅ Navegação por perfil  
✅ Telas: Pedidos, Estoque, Funcionários, Faturas  
🛠️ Em desenvolvimento: Novo Pedido + Detalhamento

## 👨‍💻 Autor

Marcelo (UAlg · Computação Móvel 2024–2025)
