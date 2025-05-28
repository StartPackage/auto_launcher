Here is the **completed `README.md`** with the added sections you requested: **Guide**, **Attributes**, and **Example**, all based on your `auto_launcher` package:

---

# ✨ Auto Launcher

A command-line utility to automate updates to your Flutter app's **name**, **version**, **bundle identifiers**, and **launcher icon**. Designed for use in manual setups or CI/CD pipelines, this tool removes the repetitive overhead of configuring these values across Android and iOS projects.

---

## ✅ Platform Support

| Android | iOS |
|---------|-----|
| ✅      | ✅  |

---

## 🛠 Features

- 🔧 Update app **name** via native project files
- 📦 Automatically set **version** in `pubspec.yaml` and native files
- 🏷 Modify app **bundle ID** (package name) for Android and iOS
- 🖼 Swap out **launcher icons** for platform-specific formats
- 🤖 Suitable for integration into **CI/CD pipelines**

---

## 📘 Guide

### 1. Setup the config file

You can define your launcher configuration directly inside `pubspec.yaml`:

```yaml
auto_launcher:
  app_name:
    build: BIDC Internal Appss
    enable: true
  version:
    build: 1.0.0+2
    enable: true
  bundle_id:
    platforms:
      android:
        build: com.bidc.internal_appss
        enable: true
      ios:
        build: com.bidc.internal.app
        enable: true
  app_icon:
    image_path: "assets/icons/app_logo.png"
    platform:
      android: true
      ios: true
```
---

### 2. Run the package

Install dependencies and run the tool:

```bash
flutter pub get
dart run auto_launcher
```

---

## 🔤 Attributes

| Key         | Type   | Description                                 |
| ----------- | ------ | ------------------------------------------- |
| `app_name`  | Object | Set a new launcher name                     |
| `version`   | Object | Define app version and build number         |
| `bundle_id` | Object | Update package/bundle ID per platform       |
| `app_icon`  | Object | Replace launcher icons using a source image |

### `app_name`

| Key    | Type   | Description         |
| ------ | ------ | ------------------- |
| build  | String | The new app name    |
| enable | Bool   | Whether to apply it |

### `version`

| Key    | Type   | Description         |
| ------ | ------ | ------------------- |
| build  | String | e.g., `1.0.0+2`     |
| enable | Bool   | Whether to apply it |

### `bundle_id`

| Platform | Key    | Type   | Description                  |
| -------- | ------ | ------ | ---------------------------- |
| android  | build  | String | Android application ID       |
| android  | enable | Bool   | Whether to update Android ID |
| ios      | build  | String | iOS bundle identifier        |
| ios      | enable | Bool   | Whether to update iOS ID     |

### `app_icon`

| Key         | Type   | Description                     |
| ----------- | ------ | ------------------------------- |
| image\_path | String | Path to the icon image          |
| platform    | Object | Toggle icon update per platform |

---

## 🧾 Example

```yaml
auto_launcher:
  app_name:
    build: BIDC Internal Appss
    enable: true
  version:
    build: 1.0.0+2
    enable: true
  bundle_id:
    platforms:
      android:
        build: com.bidc.internal_appss
        enable: true
      ios:
        build: com.bidc.internal.app
        enable: true
  app_icon:
    image_path: "assets/icons/app_logo.png"
    platform:
      android: true
      ios: true
```

---

## 🧪 Testing

```bash
flutter test
```

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## 🔗 Links

* [GitHub Repository](https://github.com/StartPackage/auto_launcher)
* [Pub.dev Package](https://pub.dev/packages/auto_launcher) *(coming soon)*

```

---

Would you like me to generate this file and update your current project with it so you can commit and publish it right away?
```
