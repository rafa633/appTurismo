import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CalendarioPage extends StatefulWidget {
  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  List<Map<String, dynamic>> eventos = [];

  @override
  void initState() {
    super.initState();
    _loadEventos();
  }

  Future<void> _loadEventos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? eventosSalvos = prefs.getString('eventos');

    if (eventosSalvos != null) {
      // Carregar eventos do armazenamento local
      List<dynamic> data = json.decode(eventosSalvos);
      setState(() {
        eventos = data.map((evento) {
          return {
            'title': evento['nome'],
            'description': evento['descricao'],
            'date': evento['data'],
          };
        }).toList();
      });
    }

    // Tentar buscar da API
    _fetchEventos();
  }

  Future<void> _fetchEventos() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.77:3000/api/calendario'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          eventos = data.map((evento) {
            return {
              'title': evento['nome'],
              'description': evento['descricao'],
              'date': evento['data'],
            };
          }).toList();
        });

        // Salvar eventos no armazenamento local
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('eventos', json.encode(data));
      } else {
        throw Exception('Falha ao carregar eventos');
      }
    } catch (e) {
      // Caso a API não responda, você já terá os dados do cache
      print('Erro ao carregar eventos da API: $e');
    }
  }

  void _showEventoModal(BuildContext context, String title, String description, String date) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(description),
              SizedBox(height: 10),
              Text('Data: $date', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o modal
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para participar do evento
                Navigator.of(context).pop(); // Fecha o modal
              },
              child: Text('Participar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário'),
        backgroundColor: Colors.blueAccent,
      ),
      body: eventos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: eventos.length,
              itemBuilder: (context, index) {
                final evento = eventos[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: Icon(Icons.event, color: Colors.blueAccent, size: 40),
                    title: Text(
                      evento['title']!,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evento['description']!,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            evento['date']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _showEventoModal(context, evento['title']!, evento['description']!, evento['date']!);
                    },
                  ),
                );
              },
            ),
    );
  }
}
