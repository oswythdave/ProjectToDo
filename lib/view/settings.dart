import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:praktikum/widget/navigation.dart';
import 'package:praktikum/application/login/view/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praktikum/application/todo/todo_bloc.dart';
import 'package:praktikum/application/todo/todo_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String displayName = "Aure Todo App";
  String selectedGender = "Laki-laki";
  bool isDarkMode = false;
  bool reminderOn = false;
  Color backgroundColor = const Color.fromARGB(255, 237, 241, 235);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName =
          prefs.getString('displayName') ?? "Welcome to Aure Todo List App";
      selectedGender = prefs.getString('gender') ?? "Laki-laki";
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      reminderOn = prefs.getBool('reminderOn') ?? false;
      int colorValue = prefs.getInt('backgroundColor') ?? backgroundColor.value;
      backgroundColor = Color(colorValue);
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayName', displayName);
    await prefs.setString('gender', selectedGender);
    await prefs.setBool('isDarkMode', isDarkMode);
    await prefs.setBool('reminderOn', reminderOn);
    await prefs.setInt('backgroundColor', backgroundColor.value);
  }

  void _showChangeNameDialog() {
    final TextEditingController nameController = TextEditingController(
      text: displayName,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ganti Nama"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Masukkan nama baru"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  displayName = nameController.text.trim();
                });
                _savePreferences();
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempGender = selectedGender;
        return AlertDialog(
          title: const Text("Pilih Gender"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    title: const Text("Laki-laki"),
                    value: "Laki-laki",
                    groupValue: tempGender,
                    onChanged:
                        (value) => setState(() {
                          tempGender = value!;
                        }),
                  ),
                  RadioListTile(
                    title: const Text("Perempuan"),
                    value: "Perempuan",
                    groupValue: tempGender,
                    onChanged:
                        (value) => setState(() {
                          tempGender = value!;
                        }),
                  ),
                  RadioListTile(
                    title: const Text("Lainnya"),
                    value: "Lainnya",
                    groupValue: tempGender,
                    onChanged:
                        (value) => setState(() {
                          tempGender = value!;
                        }),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedGender = tempGender;
                });
                _savePreferences();
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
    _savePreferences();
  }

  void _toggleReminder(bool value) {
    setState(() {
      reminderOn = value;
    });
    _savePreferences();
  }

  void _confirmResetTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reset Todo"),
          content: const Text("Apakah kamu yakin ingin menghapus semua todo?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<TodoBloc>().add(DeleteAllTodo());
                Navigator.pop(context);
              },
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );
  }

  void _showColorPickerDialog() {
    final List<Color> colorOptions = [
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.red,
      Colors.orange,
      Colors.teal,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pilih Warna Background"),
          content: Wrap(
            spacing: 10,
            children:
                colorOptions.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        backgroundColor = color;
                      });
                      _savePreferences();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage(username: '')),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30.0),
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/download.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                GestureDetector(
                  onTap: _showChangeNameDialog,
                  child: _buildSettingItem("Ganti Nama"),
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: _showGenderDialog,
                  child: _buildSettingItem("Gender: $selectedGender"),
                ),
                const SizedBox(height: 10.0),
                _buildSwitchItem("Mode Gelap", isDarkMode, _toggleDarkMode),
                const SizedBox(height: 10.0),
                _buildSwitchItem(
                  "Pengingat Harian",
                  reminderOn,
                  _toggleReminder,
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: _showColorPickerDialog,
                  child: _buildSettingItem("Ubah Warna Background"),
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: _confirmResetTodo,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.orange[100],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Reset Semua Todo",
                          style: TextStyle(color: Colors.orange),
                        ),
                        Icon(Bootstrap.trash, size: 16, color: Colors.orange),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: _logout,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.red[100],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Logout", style: TextStyle(color: Colors.red)),
                        Icon(
                          Bootstrap.box_arrow_right,
                          size: 16,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(
        selectedIndex: 2,
        selectIndex: 0,
      ),
    );
  }

  Widget _buildSettingItem(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), const Icon(Bootstrap.chevron_right, size: 16)],
      ),
    );
  }

  Widget _buildSwitchItem(
    String title,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Switch(value: value, onChanged: onChanged)],
      ),
    );
  }
}
