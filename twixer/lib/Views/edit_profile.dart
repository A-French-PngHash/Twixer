import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/actions.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataModel/user_model.dart';
import 'package:twixer/Widgets/buttons/twixer_button.dart';
import 'package:twixer/Widgets/other/date_displayer_and_editor.dart';
import 'package:twixer/Widgets/other/error_handler.dart';
import 'package:twixer/Widgets/other/profile_color_panel.dart';

class EditProfile extends StatefulWidget {
  /// The user model when the edit page is opened.
  final UserModel initialUserModel;
  final Connection connection;

  const EditProfile(
    this.initialUserModel,
    this.connection, {
    super.key,
  });

  @override
  State<EditProfile> createState() => _EditProfileState(this.initialUserModel);
}

class _EditProfileState extends State<EditProfile> {
  final UserModel _userModel;
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  String? newImagePath;

  _EditProfileState(this._userModel) {
    print(this._userModel.birthDate);
    this.nameController = TextEditingController(text: this._userModel.name);
    this.descriptionController = TextEditingController(text: this._userModel.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              size: 30,
            )),
        title: Text("Edit profile"),
        actions: [
          TwixerButton(
            "Save",
            style: TwixerButtonStyle.filled,
            onPressed: () async {
              this._userModel.description = this.descriptionController.text;
              this._userModel.name = this.nameController.text;

              // The choice has been made for convenience to update all textual
              // values (name, description...) even when they are left unchanged
              // by the user
              ErrorHandler(context).handle(await updateProfilePictureOrInfo(
                this.widget.connection,
                description: _userModel.description,
                birthDate: _userModel.birthDate,
                name: _userModel.name,
                bannerColor: this._userModel.profileBannerColor,
                imageBytes: null, // Profile picture is updated before
                // as soon as the user selects another photo.
              ));
              Navigator.of(context).pop(this._userModel);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ProfileColorPanel(
            showReturnArrow: false,
            showEditButtons: true,
            showEditProfileButton: false,
            userModel: this._userModel,
            username: this._userModel.username,
            connection: this.widget.connection,
            errorHandler: ErrorHandler(context),
            profilePictureChanged: (bytes) async {
              ErrorHandler(context).handle(await updateProfilePictureOrInfo(this.widget.connection, imageBytes: bytes));
            },
            colorChanged: (val) async {
              setState(() {
                this._userModel.profileBannerColor = val;
              });
            },
          ),
          Padding(padding: EdgeInsets.only(top: 25, left: 7, right: 7), child: buildFieldInput(context))
        ],
      ),
    );
  }

  Widget buildFieldInput(BuildContext context) {
    final children = [
      Text(
        "Name",
        style: Theme.of(context).textTheme.labelMedium,
      ),
      TextField(
        decoration: InputDecoration(border: UnderlineInputBorder()),
        controller: this.nameController,
        onSubmitted: (value) {
          setState(() {
            this._userModel.name = value;
          });
        },
      ),
      Padding(
        padding: EdgeInsets.only(top: 15),
        child: Text(
          "Description",
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
      TextField(
        decoration: InputDecoration(border: UnderlineInputBorder(), counterText: ""),
        maxLines: 3,
        maxLength: 200,
        controller: this.descriptionController,
        onSubmitted: (value) {
          setState(() {
            this._userModel.description = value;
          });
        },
      ),
      Padding(
        padding: EdgeInsets.only(top: 15),
        child: Text(
          "Birthdate",
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
      DateDisplayerAndEditor(
        this._userModel.birthDate,
        onDatePicked: (date) {
          setState(() {
            this._userModel.birthDate = date;
          });
        },
      ),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
