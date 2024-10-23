import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DetalhesPontoPage extends StatefulWidget {
  final Map<String, dynamic> ponto;

  DetalhesPontoPage({required this.ponto});

  @override
  _DetalhesPontoPageState createState() => _DetalhesPontoPageState();
}

class _DetalhesPontoPageState extends State<DetalhesPontoPage> {
  Map<String, dynamic>? previsao;
  List<dynamic>? previsaoSemanal;
  final String apiKey = 'f17865598eca1cd4447324f7a52a77d1';

  @override
  void initState() {
    super.initState();
    String cidade = widget.ponto['cidade'] ?? 'Cidade não disponível';
    buscarPrevisaoTempo(cidade);
  }

  Future<void> buscarPrevisaoTempo(String cidade) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cidade&appid=$apiKey&lang=pt&units=metric'));

    if (response.statusCode == 200) {
      setState(() {
        previsao = json.decode(response.body);
      });
    } else {
      print('Erro ao buscar previsão do tempo: ${response.statusCode}');
    }
  }

  Future<void> buscarPrevisaoSemanal(String cidade) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cidade&appid=$apiKey&lang=pt&units=metric'));

    if (response.statusCode == 200) {
      setState(() {
        previsaoSemanal = json.decode(response.body)['list'].take(7).toList();
      });
    } else {
      print('Erro ao buscar previsão semanal: ${response.statusCode}');
    }
  }

  void _abrirModalPrevisaoSemanal() {
    String cidade = widget.ponto['cidade'] ?? 'Cidade não disponível';
    buscarPrevisaoSemanal(cidade);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 400,
          color: isDark ? Colors.black : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Previsão Semanal para $cidade',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
              ),
              SizedBox(height: 10),
              previsaoSemanal == null
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: ListView(
                        children: previsaoSemanal!.map<Widget>((day) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            color: isDark ? Colors.red[800] : Colors.red[50], // Cor de fundo do card
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000)
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
                                        style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${day['main']['temp_min']}°C - ${day['main']['temp_max']}°C',
                                        style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Image.network(
                                            'http://openweathermap.org/img/wn/${day['weather'][0]['icon']}@2x.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            day['weather'][0]['description'],
                                            style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fechar', style: TextStyle(color: isDark ? Colors.teal : Colors.blue)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = (widget.ponto['fotos_adicionais'] as List<dynamic>?)?.map((url) => url.toString()).toList() ?? [];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: PageView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrls[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.teal),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.52,
            minChildSize: 0.52,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.ponto['nome'] ?? 'Nome não disponível',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          GestureDetector(
                            onTap: _abrirModalPrevisaoSemanal,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.teal[50],
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Previsão',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  previsao != null
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              'http://openweathermap.org/img/wn/${previsao!['weather'][0]['icon']}@2x.png',
                                              width: 20,
                                              height: 20,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${previsao?['main']?['temp']?.toString() ?? 'N/A'}°C',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        )
                                      : CircularProgressIndicator(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.ponto['descricao'] ?? 'Descrição não disponível',
                        style: TextStyle(fontSize: 16, color: isDark ? Colors.grey[300] : Colors.black),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Implementar ação como visualizar no mapa, etc.
                        },
                        child: Text('Ver no Mapa'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Links Úteis:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                      SizedBox(height: 10),
                      ...List<Widget>.generate(widget.ponto['links_uteis']?.length ?? 0, (index) {
                        var link = widget.ponto['links_uteis'][index];
                        return GestureDetector(
                          onTap: () async {
                            final url = Uri.parse(link['url']);
                            if (await canLaunch(url.toString())) {
                              await launch(url.toString());
                            } else {
                              throw 'Não foi possível abrir $url';
                            }
                          },
                          child: Text(
                            '${link['tipo']}: ${link['url']}',
                            style: TextStyle(fontSize: 16, color: Colors.teal),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
