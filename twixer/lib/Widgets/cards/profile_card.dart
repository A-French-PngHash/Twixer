import 'package:flutter/material.dart';
import 'package:twixer/DataModel/profile_card_model.dart';
import 'package:twixer/Widgets/error_handler.dart';
import 'package:twixer/Widgets/profile_picture.dart';

/// Stateful to allow for async loading of the profile picture.
class ProfileCard extends StatefulWidget {
  final ProfileCardModel profileModel;
  final ErrorHandler handler;

  ProfileCard(this.profileModel, this.handler);

  @override
  State<StatefulWidget> createState() {
    return _ProfileCardState();
  }
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;

    print(widget.profileModel.description);
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: ProfilePicture(
              username: widget.profileModel.username,
              handler: widget.handler,
            ),
          ),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@${widget.profileModel.username}",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),
                Container(
                  width: c_width,
                  child: Text(
                    widget.profileModel.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
        ],
      ),
    );
  }
}
