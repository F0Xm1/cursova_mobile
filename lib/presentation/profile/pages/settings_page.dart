import 'package:cours_work/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    setState(() => _darkMode = value);
  }

  Future<void> _saveNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() => _notificationsEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: SwitchListTile(
            title: const Text('Темний режим'),
            subtitle: const Text('Увімкнути темну тему'),
            value: _darkMode,
            onChanged: _saveDarkMode,
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: SwitchListTile(
            title: const Text('Сповіщення'),
            subtitle: const Text('Отримувати сповіщення про нові статті'),
            value: _notificationsEnabled,
            onChanged: _saveNotifications,
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: ListTile(
            title: const Text('Преміум підписка'),
            subtitle: const Text('Отримати доступ до всіх статей'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.subscription);
            },
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: ListTile(
            title: const Text('Про додаток'),
            subtitle: const Text('Версія 1.0.0'),
            trailing: const Icon(Icons.info_outline),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Про додаток'),
                  content: const Text('Тематичний онлайн-журнал\nВерсія 1.0.0'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
