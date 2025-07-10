// import 'package:flutter/material.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:praktikum/view/home.dart';
// import 'package:praktikum/view/productivity_page.dart';
// import 'package:praktikum/view/settings.dart';

// class CustomNavigationBar extends StatefulWidget {
//   final int selectedIndex;

//   const CustomNavigationBar({
//     super.key,
//     required this.selectedIndex,
//   });

//   @override
//   State<CustomNavigationBar> createState() => _CustomNavigationBarState();
// }

// class _CustomNavigationBarState extends State<CustomNavigationBar> {
//   void _onItemTapped(int index) {
//     if (index == widget.selectedIndex) return;

//     Widget nextPage;
//     switch (index) {
//       case 0:
//         nextPage = const MyHomePage();
//         break;
//       case 1:
//         nextPage = const ProductivityPage();
//         break;
//       case 2:
//         nextPage = const Settings();
//         break;
//       default:
//         return;
//     }

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => nextPage),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       elevation: 12,
//       color: Colors.grey[200],
//       child: SizedBox(
//         height: 60,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(FontAwesome.note_sticky_solid, 'Notes', 0),
//             _buildNavItem(Bootstrap.bar_chart_line, 'Progress', 1),
//             _buildNavItem(FontAwesome.user_solid, 'My Account', 2),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String label, int index) {
//     final isSelected = widget.selectedIndex == index;

//     return GestureDetector(
//       onTap: () => _onItemTapped(index),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: isSelected ? const Color(0xFF881FFF) : Colors.grey),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: isSelected ? const Color(0xFF881FFF) : Colors.grey,
//               fontSize: 13,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProductivityPage extends StatelessWidget {
//   const ProductivityPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Progress Produktivitas')),
//       body: const Center(child: Text('Ini halaman progress!')),
//       bottomNavigationBar: const CustomNavigationBar(selectedIndex: 1),
//     );
//   }
// }
