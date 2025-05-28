# 🛠️ auto_launcher

A Flutter utility to automatically update your app’s **name**, **version**, **bundle identifiers**, and **app icon** for both **Android** and **iOS** platforms.

Designed for automation in **CI/CD pipelines** and ideal for managing multi-flavor or branded Flutter apps.

---

## 🚀 Features

- ✅ Update `pubspec.yaml` version number easily
- ✅ Rename app display name across Android and iOS
- ✅ Change app bundle identifiers
- ✅ Replace app icons with a single source image
- ✅ Designed for automation and scriptable workflows

---

## 📦 Installation

Add `auto_launcher` to your project:

```bash
dart pub global activate auto_launcher
```

---

## ⚙️ Usage

### 1. Update App Name

```bash
auto_launcher update-name "My Cool App"
```

### 2. Update App Version

```bash
auto_launcher update-version 1.2.3
```

### 3. Update Bundle ID

```bash
auto_launcher update-bundle-id com.example.myapp
```

### 4. Update App Icon

Place your new icon in:

```
assets/icon_source.png
```

Then run:

```bash
auto_launcher update-icon
```

---

## 📁 Project Structure

- `bin/`: CLI entry point
- `lib/src/`: Core logic for updating name, version, bundle ID, and icon
- `assets/`: App icon source and generated icons
- `test/`: Unit tests for each updater

---

## 🧪 Testing

Run tests with:

```bash
flutter test
```

---

## 🛠️ Roadmap

- [ ] Add support for Windows/macOS icons
- [ ] Integrate with Git hooks or CI tools like GitHub Actions
- [ ] Add configuration via JSON or YAML

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🔗 Links

- [Repository](https://github.com/StartPackage/auto_launcher)
- [Pub.dev Package](https://pub.dev/packages/auto_launcher) *(after publishing)*
