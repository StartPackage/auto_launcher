# ✨ Auto Launcher

A command-line utility to automate updates to your Flutter app's **name**, **version**, **bundle identifiers**, and **launcher icon**. Designed for use in manual setups or CI/CD pipelines, this tool removes the repetitive overhead of configuring these values across Android and iOS projects.

---

## ✅ Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
|---------|-----|-------|-----|--------|---------|
| ✅      | ✅  | ✖️     | ✖️  | ✖️      | ✖️       |

---

## 🛠 Features

- 🔧 Update app **name** via native project files
- 📦 Automatically set **version** in `pubspec.yaml` and native files
- 🏷 Modify app **bundle ID** (package name) for Android and iOS
- 🖼 Swap out **launcher icons** for platform-specific formats
- 🤖 Suitable for integration into **CI/CD pipelines**

---

## ⚙ Setup

### 1. Add Icon Asset

Place your source image file here:

```bash
assets/icon_source.png
