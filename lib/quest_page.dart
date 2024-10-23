import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestPage extends StatefulWidget {
  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  List<Map<String, dynamic>> quests = [];

  @override
  void initState() {
    super.initState();
    fetchQuests();
  }

  Future<void> fetchQuests() async {
    final response = await http.get(Uri.parse('http://192.168.1.77:3000/api/quests'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        quests = data.map((quest) {
          return {
            'title': quest['nome'],
            'description': quest['descricao'],
            'position': LatLng(quest['pontoTuristicoId']!.toDouble(), quest['pontoTuristicoId']!.toDouble()), // Mude conforme necessário
          };
        }).toList();
      });
    } else {
      throw Exception('Falha ao carregar quests');
    }
  }

  void _showQuestModal(BuildContext context, String title, String description, LatLng position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          content: Container(
            height: 300,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: position,
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(title),
                        position: position,
                        infoWindow: InfoWindow(title: title),
                      ),
                    },
                  ),
                ),
                SizedBox(height: 10),
                Text(description, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para aceitar a quest
                Navigator.of(context).pop();
              },
              child: Text('Aceitar'),
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
        title: Text('Quests'),
        backgroundColor: Colors.deepPurple,
      ),
      body: quests.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: quests.length,
              itemBuilder: (context, index) {
                final quest = quests[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.location_on, color: Colors.deepPurple),
                    title: Text(quest['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(quest['description']),
                    onTap: () {
                      _showQuestModal(
                        context,
                        quest['title'],
                        quest['description'],
                        quest['position'],
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
