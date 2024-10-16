import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Ендолов Артур Юрьевич';
  String group = 'ЭФБО-03-22';
  String phone = '+7 987 568-**-**';
  String email = 'endolov.artur@mail.ru';


  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: name,
          currentGroup: group,
          currentPhone: phone,
          currentEmail: email,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        name = result['name'];
        group = result['group'];
        phone = result['phone'];
        email = result['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ФИО: $name', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Группа: $group', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Телефон: $phone', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Почта: $email', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
