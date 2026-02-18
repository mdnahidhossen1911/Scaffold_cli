# 🛠 scaffold_cli

A Dart CLI tool to scaffold Flutter projects with popular architecture patterns and state management solutions.

---

## 📋 Requirements

- Dart SDK `>=3.0.0`
- Flutter installed globally **or** [FVM](https://fvm.app/) installed

---

## 🚀 Installation

```bash
# Clone / extract the package
cd scaffold_cli

# Install dependencies
dart pub get

# Activate globally
dart pub global activate --source path .
```

Add pub-cache bin to your PATH (if not already):

```bash
# ~/.bashrc or ~/.zshrc
export PATH="$PATH:$HOME/.pub-cache/bin"
```

---

## 📖 Command Reference

| Command | Description |
|---------|-------------|
| `scaffold create <name>` | Create a new Flutter project |
| `scaffold list` | List all available folder structures |
| `scaffold info <1-6>` | Show detailed info about a structure |
| `scaffold doctor` | Check environment compatibility |
| `scaffold version` | Show CLI version |
| `scaffold help` | Show general help |
| `scaffold help <command>` | Show help for a specific command |

---

## 🎯 scaffold create

```bash
scaffold create <project_name> [options]

Options:
  --structure, -s <1-6>   Skip the menu — pick structure by number
  --org <com.example>     Set the org/bundle prefix (default: com.example)
  --help, -h              Show help for this command

Examples:
  scaffold create my_app
  scaffold create my_app --structure 1
  scaffold create my_app -s 5 --org com.mycompany
  scaffold create shop_app --structure 6 --org io.mystore
```

### Shorthand (no subcommand needed):

```bash
# These are equivalent:
scaffold my_app
scaffold create my_app
```

### Flutter / FVM integration:

```bash
# Works with global Flutter
flutter pub global run scaffold_cli create my_app

# Works with FVM
fvm flutter pub global run scaffold_cli create my_app
```

**What happens after `create`:**
1. Detects Flutter version (FVM or global)
2. Prompts for structure (or uses `--structure` flag)
3. Runs `flutter create --org <org> <name>`
4. Generates folders and starter Dart files
5. Updates `pubspec.yaml` with curated dependencies
6. Runs `flutter pub get`

---

## 📋 scaffold list

```bash
scaffold list [options]

Options:
  --detail, -d    Show the full folder tree for every structure
  --help, -h      Show help

Examples:
  scaffold list             # Summary view
  scaffold list --detail    # Full folder trees
  scaffold list -d
```

---

## 🔍 scaffold info

```bash
scaffold info <1-6>

Examples:
  scaffold info 1    # MVVM + GetX details
  scaffold info 5    # Feature-First + GetX details
```

Shows for each structure:
- Architecture pattern
- State management approach
- Best-for use cases
- Pros and cons
- Included packages
- Full folder tree

---

## 🩺 scaffold doctor

```bash
scaffold doctor
```

Checks:
- ✓ Dart SDK version
- ✓ Flutter (global) installation
- ✓ FVM installation
- ✓ `~/.pub-cache/bin` in PATH
- ✓ Git installation

---

## 🔢 scaffold version

```bash
scaffold version
scaffold --version
scaffold -v
```

---

## ❓ scaffold help

```bash
scaffold help              # General help + command list
scaffold help create       # Help for the create command
scaffold help list
scaffold help info
scaffold help doctor
scaffold -h
scaffold --help
```

---

## 📁 Available Folder Structures

| # | Name | State Management | Best For |
|---|------|-----------------|----------|
| 1 | MVVM + GetX | GetX `.obs` | Medium–large, reactive, low boilerplate |
| 2 | MVVM + Provider | ChangeNotifier | Flutter-native, testable ViewModels |
| 3 | MVC + GetX | GetX `.obs` | Simple apps, quick prototypes |
| 4 | MVC + Provider | ChangeNotifier | Simple apps, Flutter-standard |
| 5 | Feature-First + GetX | GetX `.obs` | Large apps, scalable, team-friendly |
| 6 | Feature-First + Provider | ChangeNotifier | Large apps, clean architecture, testable |

---

## 📦 Auto-included Dependencies

| Package | Version | Used in |
|---------|---------|---------|
| get | ^4.6.6 | GetX structures |
| provider | ^6.1.2 | Provider structures |
| equatable | ^2.0.5 | All |
| dio | ^5.4.3 | All |
| get_it | ^7.6.7 | All |
| go_router | ^14.2.7 | All |
| flutter_svg | ^2.0.10 | All |
| cached_network_image | ^3.3.1 | All |
| shared_preferences | ^2.2.3 | All |
| logger | ^2.4.0 | All |

---

## 📄 License

MIT
