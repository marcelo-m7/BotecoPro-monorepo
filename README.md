# Boteco PRO  – Flutter Bar Management App

[![Flutter 3](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev) [![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

---



## 📦 Aviso importante antes de se perder (Português 🇧🇷) 

> **Este repositório é basicamente uma acervo dos repositórios sobreviventes do meu hiperfoco do Boteco PRO (rsrs)… cheio de rascunhos, ideias e decisões que mudaram no caminho.** 

Aqui mora o **arquivo histórico das propostas de execução do Boteco PRO**.
Tem ideia boa, ideia exagerada, ideia que parecia genial às 3h da manhã e até umas arquiteturas que hoje eu olho e penso: *“ok, ainda bem que evoluiu”* 😅

Este repo existe pra **contar a história do projeto**, não pra representar o estado atual em produção.

⚠️ **Resumo honesto:**
👉 se você está procurando **o Boteco PRO rodando de verdade**, este **não é** o lugar certo.
👉 se você quer entender **como o projeto pensou, testou, errou e amadureceu**, então senta que a história é boa.

### 🍻 Onde o Boteco PRO está vivo hoje

O projeto cresceu, ganhou corpo e hoje está dividido assim:

* **Website atual (institucional + produto):**
  [https://boteco.pt](https://boteco.pt)
  Código: [https://github.com/marcelo-m7/BotecoPRO-website](https://github.com/marcelo-m7/BotecoPRO-website)

* **App atual (o Boteco PRO de verdade):**
  [https://app.boteco.pt](https://app.boteco.pt)
  Código: [https://github.com/marcelo-m7/BotecoPro-app](https://github.com/marcelo-m7/BotecoPro-app)

* **Proposta original do monorepo (a ideia raiz):**
  [https://github.com/marcelo-m7/BotecoPro-monorepo/tree/monorepo-base](https://github.com/marcelo-m7/BotecoPro-monorepo/tree/monorepo-base)

💡 **Dica de ouro:** explore também as **outras branches deste repositório**.
Elas mostram diferentes tentativas de arquitetura, refactors ambiciosos e caminhos que quase viraram realidade.

Este repositório é tipo aquele caderno antigo de engenharia:
bagunçado às vezes, mas cheio de aprendizado.


[Marcelo Santos](https://github.com/marcelo-m7)

[Monynha Softwares](https://monynha.com) 🐒💻

---

## 📦 Read this before you get excited (English 🇺🇸)

> **This repository is basically a survivors santuary for my repositories… full of drafts, experiments and “this looked like a good idea at the time” moments.** 

This is the **historical archive of Boteco PRO execution proposals** and hyperfocus on Boteco PRO idea (rsrs). 
You’ll find early concepts, ambitious monorepo ideas, architectural experiments and a few decisions that made perfect sense… until they didn’t 😄

This repo exists to **tell the story of the project**, not to represent its current production state.

⚠️ **Honest summary:**
👉 if you’re looking for **the real, running Boteco PRO**, this is **not** the right place.
👉 if you want to understand **how the project evolved, pivoted and matured**, welcome aboard.

### 🍻 Where Boteco PRO actually lives today

The project evolved and is currently active here:

* **Current website:**
  [https://boteco.pt](https://boteco.pt)
  Source code: [https://github.com/marcelo-m7/BotecoPRO-website](https://github.com/marcelo-m7/BotecoPRO-website)

* **Current application (the real deal):**
  [https://app.boteco.pt](https://app.boteco.pt)
  Source code: [https://github.com/marcelo-m7/BotecoPro-app](https://github.com/marcelo-m7/BotecoPro-app)

* **Original monorepo proposal (the root idea):**
  [https://github.com/marcelo-m7/BotecoPro-monorepo/tree/monorepo-base](https://github.com/marcelo-m7/BotecoPro-monorepo/tree/monorepo-base)

💡 **Pro tip:** check out the **other branches in this repository**.
They showcase alternative architectures, ambitious refactors and paths that almost became production.

Think of this repo as an old engineering notebook:
not always pretty, but packed with lessons.


[Marcelo Santos](https://github.com/marcelo-m7)

[Monynha Softwares](https://monynha.com) 🐒💻

---

## ✨ What is Boteco PRO?

Boteco PRO is a **cross-platform management system for small Brazilian bars (“botecos”)**.
It helps owners keep tables, orders, stock, recipes and in-house production under control – whether the app is installed on Android, iOS or opened as a PWA in the browser.

> **Author:** [Marcelo Santos](https://github.com/marcelo-m7)
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
