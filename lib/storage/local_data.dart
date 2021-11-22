import 'package:myapp/custom_widgets/chats.dart';
import 'package:myapp/custom_widgets/contacts.dart';
import 'package:myapp/custom_widgets/profile.dart';

class LocalData {
  static const List<Map<String, String>> pagerList = [
    {
      'image': 'assets/images/main.jpg',
      'title': 'Send &receive message',
    },
    {
      'image': 'assets/images/login.jpg',
      'title': 'Be Connected',
    },
    {
      'image': 'assets/images/signup.jpg',
      'title': 'Register Yourself',
    },
  ];
  static List<Map<String, dynamic>> bottomNavList = [
    {
      'screen': Chats(),
      'title': 'Chat List',
    },
    {
      'screen': Contacts(),
      'title': 'Contacts List',
    },
    {
      'screen': Profile(),
      'title': 'Profile',
    },
  ];
}
