import 'package:flutter/material.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const SizedBox(height: 40),
          _buildDrawerItem(context, 'Home', route: '/da'),
          _buildDrawerItem(context, 'My Ponds'),
          _buildDrawerItem(context, 'Devices'),
          _buildDrawerItem(context, 'Notifications', route: '/om'),
          _buildDrawerItem(context, 'Tasks', route: '/tasks'),
          _buildDrawerItem(context, 'Settings'),
          const Divider(),
          _buildDrawerItem(context, 'Log out', isLogout: true, route: '/login'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title,
      {String? route, bool isLogout = false}) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: isLogout ? Colors.red : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            if (route != null) {
              _navigateTo(context, route);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        const Divider(color: Colors.white30),
      ],
    );
  }
}
