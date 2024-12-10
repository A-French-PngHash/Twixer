import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/actions.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataModel/user_model.dart';
import 'package:twixer/Views/auth.dart';
import 'package:twixer/Widgets/buttons/twixer_button.dart';
import 'package:twixer/Widgets/other/color_dialog.dart';
import 'package:twixer/Widgets/other/error_handler.dart';
import 'package:twixer/Widgets/other/profile_picture.dart';
import 'package:twixer/main.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:twixer/utils.dart';

/// Builds the top color panel that is displayed  when viewing a profile.
class ProfileColorPanel extends StatefulWidget {
  final UserModel userModel;

  final bool showReturnArrow;

  /// Edit button for the color and the profile picture.
  final bool showEditButtons;

  final bool showLogoutButton;

  /// Show a button that leads to the edit profile page. If this is true, the
  /// button will automatically display the page when pressed.
  final bool showEditProfileButton;

  /// Called when the user changed the profile pannel color.
  ///
  /// The given parameter is the hex code of the new color.
  final void Function(String)? colorChanged;

  /// Called if an edit has been made to the profile picture.
  ///
  /// The given parameter is the path of the image.
  final void Function(Uint8List)? profilePictureChanged;

  final void Function()? editProfilePressed;

  final String username;

  final Connection connection;

  final double profilePictureSize = 90;

  final ErrorHandler errorHandler;

  const ProfileColorPanel({
    super.key,
    required this.showReturnArrow,
    required this.showEditButtons,
    required this.showEditProfileButton,
    required this.username,
    required this.connection,
    required this.userModel,
    required this.errorHandler,
    required this.showLogoutButton,
    this.editProfilePressed,
    this.colorChanged,
    this.profilePictureChanged,
  });

  @override
  State<ProfileColorPanel> createState() => _ProfileColorPanelState(this.userModel);
}

class _ProfileColorPanelState extends State<ProfileColorPanel> {
  UserModel userModel;

  _ProfileColorPanelState(this.userModel);

  @override
  Widget build(BuildContext context) {
    final children = [
      Container(
        height: 200,
        width: double.infinity,
        color: Colors.transparent,
      ),
      Positioned(
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
              color: HexColor.fromHex(userModel.profileBannerColor),
              border: Border(bottom: BorderSide(color: Colors.white, width: 0))),
        ),
      ),
      Positioned(
        child: buildProfilePictureStack(context),
        top: 110,
        left: 30,
      ),
    ];

    ///
    /// PROFILE BUTTON
    ///
    if (widget.showEditProfileButton) {
      children.add(
        Positioned(
          child: TextButton(
            onPressed: widget.editProfilePressed,
            child: Container(
              child: Container(
                padding: EdgeInsets.all(3),
                child: Text(
                  "Editer le profil",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Color.fromARGB(255, 85, 99, 110)),
              ),
            ),
          ),
          right: 30,
          top: 170,
        ),
      );
    }

    ///
    /// RETURN ARROW
    ///
    if (widget.showReturnArrow) {
      children.add(
        Positioned(
          top: 10,
          left: 10,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            style: twixerIconButtonStyle,
          ),
        ),
      );
    }

    if (widget.showLogoutButton) {
      children.add(Positioned(
        top: 10,
        right: 10,
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return AuthView(
                logout: true,
              );
            }));
          },
          icon: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          style: twixerIconButtonStyle,
        ),
      ));
    }

    if (widget.showEditButtons) {
      children.add(Positioned(
        top: 50,
        right: 100,
        child: IconButton(
          onPressed: () async {
            final controller = TextEditingController();
            final bool changeColor = (await showDialog<bool>(
                context: context, builder: (context) => buildColorDialog(context, controller)))!;
            if (changeColor && widget.colorChanged != null) {
              final text = controller.text.toLowerCase();
              RegExp exp = RegExp(r'^[0-9,a-f]{6}$');
              if (exp.firstMatch(text) != null) {
                widget.colorChanged!(text);
              }
            }
          },
          iconSize: 40,
          icon: Icon(Icons.edit),
          style: twixerIconButtonStyle,
        ),
      ));
    }

    final following = this.userModel.isFollowing;
    if (following != null && (widget.connection.username != this.userModel.username)) {
      children.add(
        Positioned(
          right: 30,
          top: 170,
          child: TwixerButton(
            following ? "Followed" : "Follow",
            style: following ? TwixerButtonStyle.outlined : TwixerButtonStyle.filled,
            onPressed: () async {
              final result = await follow(widget.connection, widget.username);
              await widget.errorHandler.handle(result);
              if (result.$1 && this.userModel.isFollowing != null) {
                setState(() {
                  this.userModel.isFollowing = !this.userModel.isFollowing!;
                });
              }
            },
          ),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: children,
    );
  }

  Widget buildProfilePictureStack(BuildContext context) {
    final List<Widget> children = [
      Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 0),
        ),
      ),
      Container(
        child: ProfilePicture(
          username: widget.username,
          handler: ErrorHandler(context),
          connection: widget.connection,
          size: widget.profilePictureSize,
          clickable: false,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0),
          shape: BoxShape.circle,
        ),
      ),
    ];
    if (widget.showEditButtons) {
      children.add(IconButton(
        onPressed: () async {
          Uint8List? bytes = null;
          if (kIsWeb) {
            bytes = null;
          } else {
            /*final image = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image != null) {
              bytes = await image.readAsBytes();
            }
            */
          }
          if (bytes != null && widget.profilePictureChanged != null) {
            widget.profilePictureChanged!(bytes);
          }
        },
        iconSize: 40,
        icon: Icon(Icons.add_a_photo_outlined),
        style: twixerIconButtonStyle.copyWith(padding: WidgetStatePropertyAll(EdgeInsets.all(25.8))),
      ));
    }

    return Stack(
      alignment: AlignmentDirectional.center,
      children: children,
      clipBehavior: Clip.none,
    );
  }
}
