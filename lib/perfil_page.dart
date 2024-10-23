import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Perfil',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Adicione a funcionalidade de edição de perfil aqui
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://scontent.fsod5-1.fna.fbcdn.net/v/t39.30808-6/414440323_3639041939758561_2109187370528332037_n.jpg?_nc_cat=106&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=xirDnbIULFwQ7kNvgG4H2Ml&_nc_ht=scontent.fsod5-1.fna&_nc_gid=AFkdOpMQVNMP8OnJSePSXkL&oh=00_AYAwoFlpSsvFl1CIZpnamW-IK61g4hMlj1pd42pemxeUQA&oe=670C4499',
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Rafael Batista',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 18.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn('Posts', '0'),
                  _buildStatColumn('Seguindo', '50'),
                  _buildStatColumn('Seguidores', '100k'),
                ],
              ),
              SizedBox(height: 16.0),
              Divider(),
              Text(
                'Posts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 7,
                itemBuilder: (context, index) {
                  List<String> imageUrls = [
                    'https://images.pexels.com/photos/1735675/pexels-photo-1735675.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    'https://images.pexels.com/photos/1761279/pexels-photo-1761279.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    'https://images.pexels.com/photos/1583207/pexels-photo-1583207.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    'https://images.pexels.com/photos/1236906/pexels-photo-1236906.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    'https://images.pexels.com/photos/1005472/pexels-photo-1005472.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    'https://images.pexels.com/photos/1761282/pexels-photo-1761282.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    'https://images.pexels.com/photos/1047051/pexels-photo-1047051.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                  ];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            imageUrls: imageUrls,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrls[index]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
              Divider(),
              Text(
                'Compartilhar em:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.blue),
                    onPressed: () {
                      // Lógica para compartilhar no Facebook
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.lightBlue),
                    onPressed: () {
                      // Lógica para compartilhar no Twitter
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share, color: Colors.pink),
                    onPressed: () {
                      // Lógica para compartilhar no Instagram
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.0),
        Text(title),
      ],
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImage({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context); // Fecha a tela cheia ao tocar na imagem
            },
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.contain,
            ),
          );
        },
        controller: PageController(initialPage: initialIndex),
      ),
    );
  }
}
