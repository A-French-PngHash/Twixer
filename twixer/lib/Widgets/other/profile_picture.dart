import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/profile_picture.dart';
import 'package:twixer/Views/profile.dart';
import 'package:twixer/Widgets/other/error_handler.dart';

/// Automatically fetches the profile picture for the given user.
class ProfilePicture extends StatefulWidget {
  final String username;
  final ErrorHandler handler;
  final double size;
  final Connection connection;
  final bool clickable;

  ProfilePicture(
      {required this.username,
      required this.handler,
      this.size = 60,
      required Connection this.connection,
      this.clickable = true});

  @override
  State<StatefulWidget> createState() {
    return _ProfilePictureState();
  }
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool _isLoaded = false;
  Image? image;

  @override
  void initState() {
    super.initState();
    getProfilePicture(widget.username).then((value) {
      final result = widget.handler.handle<Image>(value);
      if (this.mounted && result != null) {
        setState(() {
          image = result;
          _isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(child: child, opacity: animation);
      },
      child: ElevatedButton(
        onPressed: this.widget.clickable
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileView(
                      username: this.widget.username,
                      errorHandler: ErrorHandler(context),
                      connection: this.widget.connection,
                      provideReturnArrow: true,
                      addScaffold: true,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
        ),
        child: Container(
          key: UniqueKey(),
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
              image: _isLoaded ? image!.image : AssetImage("assets/default.jpg"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
