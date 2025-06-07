# Boteco PRO  – Flutter Bar Management App

[![Flutter 3](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev) [![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

---

## ✨ What is Boteco PRO?

Boteco PRO is a **cross-platform management system for small Brazilian bars (“botecos”)**.
It helps owners keep tables, orders, stock, recipes and in-house production under control – whether the app is installed on Android, iOS or opened as a PWA in the browser.

> **Author:** Marcelo Santos – [a79433@ualg.pt](mailto:a79433@ualg.pt)
> **Course:** *LESTI* – Universidade do Algarve
> **Semester:** 2024/2025 (Trabalho Final)

---

## 📦 Current Feature Set

| Module                | Status | Key Screens / Functions                        |
| --------------------- | :----: | ---------------------------------------------- |
| Dashboard             |    ✅   | Sales today, active tables, low-stock alert    |
| Tables                |    ✅   | Grid with live status, open/close orders       |
| Products              |    ✅   | CRUD, category filter, manual stock adjustment |
| Suppliers             |    ✅   | Simple register + list                         |
| Recipes & Ingredients |    ✅   | Technical sheet, selling price, prep time      |
| In-house Production   |    ✅   | Track batches *in progress* vs *finished*      |
| Local Persistence     |    ✅   | Offline-first via **SharedPreferences**        |
| Themes & Animations   |    ✅   | Light / Dark (Material 3), *flutter\_animate*  |

---

## 🗺️ Road-map (next milestones)

| Goal                    | Planned work                                                                                                                      |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| **Backend integration** | Plug every view / stored-procedure in the MS SQL & ApiFlow gateway into the `ApiService` layer; move from demo JSON to real data. |
| **Authentication**      | Google Sign-In (Authenticator) → REST endpoint `sp_register_or_update_user`; role-based UI (garçom vs gerente).                   |
| **Data layer upgrade**  | Migrate offline cache from SharedPreferences to **Isar** for larger, indexed datasets.                                            |
| **Reports & Exports**   | PDF / CSV for sales, stock movements, recipe cost.                                                                                |
| **Print / KDS**         | Optional Bluetooth/ESC-POS tickets or kitchen-display over WebSocket.                                                             |

---

## 🚀 Getting Started

### 1. Prerequisites

* Flutter 3.19 + (channel *stable*)
* Dart 3
* A recent Chrome / Edge (for web) or Android/iOS device / emulator

```bash
flutter --version
```

### 2. Clone

```bash
git clone https://github.com/marcelo-m7/Boteco_PRO.git
cd boteco_pro
```

### 3. Run as Web App

```bash
flutter run -d chrome        # or edge
```

### 4. Run on Android/iOS

```bash
flutter run                  # picks a connected phone/emulator
```

> **Quick test:** An already-built **`boteco_pro.apk`** sits in the project root – just sideload it on Android (`adb install boteco_pro.apk`).

---

## 🗃️ Project Structure `/lib`

```
lib/
 ├─ models/         domain DTOs & enums
 ├─ services/       ApiService + DatabaseService (offline cache)
 ├─ pages/          UI for each module
 └─ widgets/        reusable components (AppBar, Badge, QuantitySelector…)
```

Platform wrappers live in `android/`, `ios/` and `web/`.
Everything business-related stays in Dart under `lib/`.

---

## 📝 Tech Highlights

* **Material 3** theming with adaptive light/dark palettes inspired by Brazilian “boteco” colours (yellow, burgundy, beige).
* **flutter\_animate** for smooth card & FAB transitions.
* **SharedPreferences** seed data on first launch → instant demo.
* **Intl** fully configured (`initializeDateFormatting('pt_BR')`) for currency and dates in Portuguese (Brazil).

---

## 🤝 Contributing & License

This is an academic project but pull-requests are welcome for educational purposes.
Code released under the **MIT License** – see [LICENSE](LICENSE).

---

### 🙌 Acknowledgements

* Open-source Flutter community for awesome packages

---

> *“Gestão simples, cerveja gelada e boteco lotado.”* – **Boteco PRO**
