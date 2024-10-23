import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  PageController _pageController = PageController();

  void onTabChange(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: [
          Center(child: Text('Início')),
          Center(child: Text('Turismo')),
          Center(child: Text('Quest')),
          Center(child: Text('Calendário')),
          Center(child: Text('Perfil')),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  BottomNavBar({
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      items: [
        _buildNavItem(Icons.nature_people, 'Início', 0),
        _buildNavItem(Icons.explore, 'Turismo', 1),
        _buildNavItem(Icons.assignment_turned_in, 'Quest', 2),
        _buildNavItem(Icons.calendar_today, 'Calendário', 3),
        _buildNavItem(Icons.account_circle, 'Perfil', 4),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: isDarkMode ? Colors.greenAccent : Colors.green,
      unselectedItemColor: Colors.grey,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      onTap: onTabChange,
      type: BottomNavigationBarType.fixed,
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: isSelected ? 1.2 : 1.0,
        duration: Duration(milliseconds: 150),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
