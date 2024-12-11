import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/browsing.dart';
import 'package:twixer/DataModel/enums/order_by.dart';
import 'package:twixer/DataModel/user_model.dart';
import 'package:twixer/Views/edit_profile.dart';
import 'package:twixer/Widgets/buttons/button_with_loading.dart';
import 'package:twixer/Widgets/displayers/profile_displayer.dart';
import 'package:twixer/Widgets/displayers/tweet_displayer.dart';
import 'package:twixer/Widgets/other/error_handler.dart';
import 'package:twixer/Widgets/middle_nav_bar/middle_nav_bar.dart';
import 'package:twixer/Widgets/other/profile_color_panel.dart';
import 'package:twixer/Widgets/other/profile_picture.dart';
import 'package:twixer/config.dart';
import 'package:twixer/utils.dart';

class ProfileView extends StatefulWidget {
  final String username;
  final ErrorHandler errorHandler;
  final Connection connection;
  final bool addScaffold;

  /// Displays a return arrow in the top left corner if this is set to true.
  ///
  /// The profile page can be accessed from the home screen using the bottom
  /// navigation bar in which case such an arrow is unwanted. It can also be
  /// accessed through common navigation (clicking on a profile image, on a
  /// @username...), in that situation we want the arrow to be displayed.
  final bool provideReturnArrow;

  final bool showFollowButton;

  /// Will only be shown if a scaffold is added to the profile.
  final bool showLogoutButton;

  ProfileView(
      {required this.username,
      required this.errorHandler,
      required this.connection,
      this.provideReturnArrow = false,
      this.showFollowButton = false,
      this.addScaffold = false,
      this.showLogoutButton = false});

  @override
  State<StatefulWidget> createState() {
    return _ProfileViewState();
  }
}

class _ProfileViewState extends State<ProfileView> {
  bool _loading = true;
  bool success = false;

  /// WARNING : The userModel takes some time to load (a request is sent to the API).
  UserModel userModel = UserModel(
      0, 0, "Loading...", "Loading...", DateTime.now(), DateTime.now(), "loading", BLUE.value.toRadixString(16), 0);
  OrderBy orderBy = OrderBy.date;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    getProfileDataFor(username: widget.username, connection: widget.connection).then((result) async {
      final userModel = widget.errorHandler.handle(result);
      setState(() {
        _loading = false;
        if (userModel == null) {
          success = false;
        } else {
          this.userModel = userModel;
          success = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading && !success) {
      return Center(
        child: buildRetry(),
      );
    }
    // do something with silver view

    final colum = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 220,
            child: ProfileColorPanel(
              key: UniqueKey(),
              userModel: this.userModel,
              showReturnArrow: this.widget.provideReturnArrow,
              showEditButtons: false,
              showLogoutButton: this.widget.showLogoutButton,
              showEditProfileButton: (this.widget.connection.username == this.widget.username),
              username: this.widget.username,
              errorHandler: this.widget.errorHandler,
              connection: this.widget.connection,
              editProfilePressed: (this._loading || !success)
                  ? null
                  : () async {
                      final newUserModel = await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => EditProfile(this.userModel, this.widget.connection)));
                      if (newUserModel != null) {
                        setState(() {
                          this.userModel = newUserModel;
                        });
                      }
                    },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildUserSummary(),
                Container(
                  color: Colors.white,
                  child: MiddleNavBar(
                      labels: OrderBy.values.map((t) => t.screenDisplay).toList(),
                      onSelect: (number) {
                        setState(() {
                          orderBy = OrderBy.values[number];
                        });
                      }),
                  padding: EdgeInsets.only(top: 5, bottom: 0),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: Expanded(
                  child: TweetDisplayer(
                    get: (limit, offset) async {
                      return await getProfileTweets(
                          username: widget.username,
                          orderBy: orderBy,
                          limit: limit,
                          offset: offset,
                          connection: this.widget.connection);
                    },
                    connection: widget.connection,
                    key: UniqueKey(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.addScaffold) {
      return Scaffold(
        body: colum,
      );
    } else {
      return colum;
    }
  }

  Widget buildRetry() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Text("Nothing here...", style: Theme.of(context).textTheme.bodyMedium),
        ),
        ButtonWithLoading(
          loading: _loading,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(7),
                child: Icon(Icons.refresh),
              ),
              Text("Refresh"),
            ],
          ),
          onPressed: () {
            if (!_loading) {
              loadData();
            }
          },
        )
      ],
    );
  }

  /// The summary is the zone directly underneath the top stack, it displays
  /// the name, the number of followers, the join date...
  Widget buildUserSummary() {
    final children = [
      Row(
        children: [
          Text(
            userModel.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            " (@${userModel.username})",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14, fontStyle: FontStyle.italic),
          ),
        ],
      ),
      Text("🗓️ joined twixer in ${DateFormat("MMMM").format(userModel.joinDate)} ${userModel.joinDate.year}",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14)),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return buildFollowerFollowingView(false);
            }));
          },
          child: Row(
            children: [
              Text(
                userModel.following.toString(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(" following"),
            ],
          ),
        ),
        Spacer(
          flex: 1,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return buildFollowerFollowingView(true);
            }));
          },
          child: Row(
            children: [
              Text(
                userModel.follower.toString(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(" follower"),
            ],
          ),
        ),
        Spacer(
          flex: 4,
        )
      ]),
    ];
    if (this.userModel.description != "") {
      children.insert(
        1,
        Text(
          userModel.description,
          maxLines: 3,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }

  Widget buildFollowerFollowingView(bool follower) {
    return Scaffold(
      appBar: AppBar(
        title: Text(follower ? "Followers of ${this.userModel.name}" : "Following ${this.userModel.name}"),
      ),
      body: ProfileDisplayer(
          get: (limit, offset) async {
            final result = follower
                ? await getFollowers(this.userModel.id, limit, offset)
                : await getFollowing(this.userModel.id, limit, offset);
            return result;
          },
          connection: this.widget.connection),
    );
  }
}
