import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  SettingsPage({required this.themeNotifier});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool('darkTheme') ?? false;
    widget.themeNotifier.value = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _saveThemePreference(bool isDarkTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', isDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = widget.themeNotifier.value == ThemeMode.light;

    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        backgroundColor: isLightTheme ? Colors.white : Colors.black,
        iconTheme: IconThemeData(color: isLightTheme ? Colors.black : Colors.white),
      ),
      body: Container(
        color: isLightTheme ? Colors.white : Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Seção de tema
              Text(
                'Selecione o Tema',
                style: TextStyle(
                  fontSize: 24,
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
              ),
              SwitchListTile(
                title: Text(
                  'Tema Escuro',
                  style: TextStyle(color: isLightTheme ? Colors.black : Colors.white),
                ),
                value: widget.themeNotifier.value == ThemeMode.dark,
                onChanged: (value) {
                  widget.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                  _saveThemePreference(value);

                  // Feedback visual
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Tema Escuro Ativado' : 'Tema Claro Ativado',
                      ),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                activeColor: Colors.white,
                inactiveThumbColor: isLightTheme ? Colors.grey : Colors.grey[700],
                inactiveTrackColor: isLightTheme ? Colors.grey[300] : Colors.grey[600],
              ),
              SizedBox(height: 20),
              Divider(),
              // Seção de notificações
              SwitchListTile(
                title: Text(
                  'Notificações',
                  style: TextStyle(color: isLightTheme ? Colors.black : Colors.white),
                ),
                value: true, // Lógica para determinar se está ativado
                onChanged: (value) {
                  // Adicione sua lógica para habilitar/desabilitar notificações
                },
                activeColor: Colors.green,
              ),
              Divider(),
              // Seção de ajuda e suporte
              ListTile(
                title: Text(
                  'Ajuda e Suporte',
                  style: TextStyle(color: isLightTheme ? Colors.black : Colors.white),
                ),
                trailing: Icon(Icons.help, color: isLightTheme ? Colors.black : Colors.white),
                onTap: () {
                  _showHelpDialog(context);
                },
              ),
              Divider(),
              // Seção de gerenciamento de conta
              ListTile(
                title: Text(
                  'Gerenciar Conta',
                  style: TextStyle(color: isLightTheme ? Colors.black : Colors.white),
                ),
                trailing: Icon(Icons.person, color: isLightTheme ? Colors.black : Colors.white),
                onTap: () {
                  // Lógica para navegar para a tela de gerenciamento de conta
                },
              ),
              Divider(),
              // Seção de privacidade
              ListTile(
                title: Text(
                  'Configurações de Privacidade',
                  style: TextStyle(color: isLightTheme ? Colors.black : Colors.white),
                ),
                trailing: Icon(Icons.privacy_tip, color: isLightTheme ? Colors.black : Colors.white),
                onTap: () {
                  // Lógica para mostrar informações sobre privacidade
                },
              ),
              Divider(),
              // Ícone grande no meio
              SizedBox(height: 40),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Icon(
                  isLightTheme ? Icons.wb_sunny : Icons.nights_stay,
                  key: ValueKey<bool>(isLightTheme),
                  size: 100,
                  color: isLightTheme ? Colors.yellow : Colors.blueGrey,
                ),
              ),
              SizedBox(height: 20),
              Spacer(), // Empurra a seção de créditos para baixo
              // Seção de créditos
              Text(
                'Desenvolvido por: Rafael Batista',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Versão 1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajuda e Suporte'),
          content: Text(
            'Para suporte, entre em contato com:\n\n'
            'Email: rafa.bat@gmail.com\n'
            'Telefone: (15) 99643-1526',
          ),
          actions: [
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
