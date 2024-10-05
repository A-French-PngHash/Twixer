import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/profile_picture.dart';
import 'package:twixer/Widgets/cards/profile_card.dart';
import 'package:twixer/Widgets/error_handler.dart';

/// Automatically fetches the profile picture for the given user.
class ProfilePicture extends StatefulWidget {
  final String username;
  final ErrorHandler handler;
  final double size;

  ProfilePicture({required this.username, required this.handler, this.size = 60});

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
      print("then");
      final result = widget.handler.handle<Image>(value);
      if (result != null) {
        setState(() {
          image = result;
          _isLoaded = true;
        });
      }
    });
    print("after");
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(child: child, opacity: animation);
      },
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
    );
  }
}
