import 'package:flutter/material.dart';
import 'services/ponto_service.dart'; // Importa a função de serviço
import 'detalhes_ponto_page.dart'; // Importa a página de detalhes

class TurismoPage extends StatefulWidget {
  @override
  _TurismoPageState createState() => _TurismoPageState();
}

class _TurismoPageState extends State<TurismoPage> {
  late Future<List<dynamic>> pontosTuristicos;

  @override
  void initState() {
    super.initState();
    pontosTuristicos = fetchPontosTuristicos(); // Chama a função aqui
  }

  Future<void> _refreshPontos() async {
    setState(() {
      pontosTuristicos = fetchPontosTuristicos(); // Atualiza a lista ao arrastar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pontos Turísticos'),
        backgroundColor: Colors.teal,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPontos, // Define a função de atualização
        child: FutureBuilder<List<dynamic>>(
          future: pontosTuristicos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Nenhum ponto turístico encontrado.'));
            } else {
              final pontos = snapshot.data!;
              return ListView.builder(
                itemCount: pontos.length,
                itemBuilder: (context, index) {
                  final ponto = pontos[index];
                  final List<dynamic> imagens = ponto['fotos_adicionais'] ?? []; // Lista de imagens

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesPontoPage(ponto: ponto),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: [
                            // Mini-carousel para as imagens do ponto turístico
                            Container(
                              height: 180, // Altura do carousel
                              child: PageView.builder(
                                itemCount: imagens.length,
                                itemBuilder: (context, imgIndex) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                    child: Image.network(
                                      imagens[imgIndex] ?? 'https://via.placeholder.com/150',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(child: Text('Imagem não disponível'));
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ponto['nome'] ?? 'Nome não disponível', 
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal[800],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    ponto['descricao'] ?? 'Descrição não disponível', 
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
