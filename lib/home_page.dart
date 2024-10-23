import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'detalhes_ponto_page.dart';
import 'bottom_nav_bar.dart';
import 'turismo_page.dart';
import 'perfil_page.dart';
import 'quest_page.dart';
import 'calendario_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  HomePage({required this.themeNotifier});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<dynamic> lugaresVisitados = [];
  List<dynamic> noticias = [];
  List<String> bannerImages = [];
  PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchLugaresVisitados();
    fetchNoticias();
    fetchCarouselImages();
    _loadThemePreference();
    _startCarouselTimer(); // Inicia o timer do carousel
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel(); // Cancela o timer ao descartar o widget
    super.dispose();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('theme');
    widget.themeNotifier.value = (theme == 'dark') ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> fetchLugaresVisitados() async {
    final response = await http.get(Uri.parse('http://192.168.1.77:3000/api/pontos'));

    if (response.statusCode == 200) {
      final allLugares = json.decode(response.body);
      setState(() {
        lugaresVisitados = allLugares.where((lugar) => lugar['maisVisitado'] == true).toList();
      });
    } else {
      throw Exception('Falha ao carregar os pontos turísticos');
    }
  }

  Future<void> fetchNoticias() async {
    final response = await http.get(Uri.parse('http://192.168.1.77:3000/api/noticias'));

    if (response.statusCode == 200) {
      setState(() {
        noticias = json.decode(response.body);
      });
    } else {
      throw Exception('Falha ao carregar as notícias');
    }
  }

  Future<void> fetchCarouselImages() async {
    final response = await http.get(Uri.parse('http://192.168.1.77:3000/api/carousel'));

    if (response.statusCode == 200) {
      setState(() {
        bannerImages = List<String>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Falha ao carregar as imagens do carousel');
    }
  }

  void _startCarouselTimer() {
  _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    // Se a página atual for nula, consideramos como 0
    int currentPage = (_pageController.page?.round() ?? 0);
    if (currentPage < bannerImages.length - 1) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      _pageController.jumpToPage(0);
    }
  });
}


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showModal(BuildContext context, dynamic noticia) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                noticia['titulo'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                noticia['descricao'],
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Data: ${noticia['data']}',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Você escolheu participar!')),
                  );
                },
                child: Text('Escolher participar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildBanner() {
  return Stack(
    children: [
      Container(
        height: 250, // Aumentar a altura para as imagens
        child: PageView.builder(
          controller: _pageController,
          itemCount: bannerImages.length,
          itemBuilder: (context, index) {
            return Image.network(
              bannerImages[index],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://via.placeholder.com/600x250?text=Imagem+não+disponível',
                  fit: BoxFit.cover,
                );
              },
            );
          },
        ),
      ),
      Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black54,
        ),
      ),
      Positioned(
        top: 70, // Ajustar a posição para centralizar
        left: 0,
        right: 0,
        child: Column(
          children: [
            Center( // Centraliza o título
              child: Text(
                'Rota de Turismo',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Center( // Centraliza o subtítulo
              child: Text(
                'Explore os melhores destinos!',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeNotifier.value == ThemeMode.light ? Colors.white : Colors.black,
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text(
                'Rota de Turismo',
                style: TextStyle(
                  color: widget.themeNotifier.value == ThemeMode.light ? Colors.black : Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(themeNotifier: widget.themeNotifier),
                      ),
                    );
                  },
                ),
              ],
            )
          : null,
      body: _selectedIndex == 0 ? buildHomeContent() : _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
      ),
    );
  }

  Widget buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildBanner(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Notícias Recentes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];
                return GestureDetector(
                  onTap: () => _showModal(context, noticia),
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              noticia['imagem'] ?? 'https://via.placeholder.com/150',
                              height: 180,
                              width: 150,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://via.placeholder.com/150?text=Imagem+não+disponível',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                noticia['titulo'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Lugares Mais Visitados',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lugaresVisitados.length,
              itemBuilder: (context, index) {
                final lugar = lugaresVisitados[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesPontoPage(ponto: lugar),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                          child: Image.network(
                            lugar['imagem'],
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Text('Imagem não disponível'));
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              lugar['nome'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static List<Widget> _pages = <Widget>[
    Container(),
    TurismoPage(),
    QuestPage(),
    CalendarioPage(),
    PerfilPage(),
  ];
}
