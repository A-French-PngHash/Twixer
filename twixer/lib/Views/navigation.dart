import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/Views/homepage.dart';
import 'package:twixer/Views/profile.dart';
import 'package:twixer/Views/search.dart';
import 'package:twixer/Widgets/error_handler.dart';

class Navigation extends StatefulWidget {
  final Connection connection;
  late final List<Widget> _screens;

  Navigation({required this.connection}) {
    _screens = [
      Homepage(connection: this.connection),
      SearchView(connection: this.connection),
    ];
  }

  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<Navigation> {
  int index = 2;

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      body: index != 2
          ? widget._screens[index]
          : ProfileView(
              username: widget.connection.username!,
              errorHandler: ErrorHandler(context),
              connection: widget.connection,
            ),

      /// TODO : When implementing GUEST MODE, prevent user from accessing the profile page.
      bottomNavigationBar: Theme(
        data: ThemeData(splashColor: Colors.transparent),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(
                Icons.home,
              ),
              label: "Feed",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
          enableFeedback: false,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
        ),
      ),
    );
  }
}
