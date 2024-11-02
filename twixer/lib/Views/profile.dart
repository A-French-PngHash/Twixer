import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/DataLogic/browsing.dart';
import 'package:twixer/DataModel/user_model.dart';
import 'package:twixer/Widgets/buttons/button_with_loading.dart';
import 'package:twixer/Widgets/displayers/tweet_displayer.dart';
import 'package:twixer/Widgets/error_handler.dart';
import 'package:twixer/Widgets/middle_nav_bar/middle_nav_bar.dart';
import 'package:twixer/Widgets/profile_picture.dart';

class ProfileView extends StatefulWidget {
  final String username;
  final ErrorHandler errorHandler;
  final Connection connection;

  /// Displays a return arrow in the top left corner if this is set to true.
  ///
  /// The profile page can be accessed from the home screen using the bottom
  /// navigation bar in which case such an arrow is unwanted. It can also be
  /// accessed through common navigation (clicking on a profile image, on a
  /// @username...), in that situation we want the arrow to be displayed.
  final bool provideReturnArrow;

  ProfileView(
      {required this.username, required this.errorHandler, required this.connection, this.provideReturnArrow = false});

  @override
  State<StatefulWidget> createState() {
    return _ProfileViewState();
  }
}

class _ProfileViewState extends State<ProfileView> {
  bool _loading = true;
  bool success = false;
  UserModel userModel = UserModel(0, 0, "Loading...", "Loading...", DateTime.now(), DateTime.now());
  String orderBy = "date";
  final _orders = ["date", "popularity", "number_of_response"];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    getProfileDataFor(username: widget.username).then((result) async {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 220,
          child: buildUpperStack(context),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildUserSummary(),
              Container(
                child: MiddleNavBar(
                    labels: ["Latest", "Most liked", "Most commented"],
                    onSelect: (number) {
                      setState(() {
                        orderBy = _orders[number];
                      });
                    }),
                padding: EdgeInsets.only(top: 20, bottom: 8),
              ),
            ],
          ),
        ),
        Expanded(
          child: TweetDisplayer(
            get: (limit, offset) async {
              return await getProfileTweets(username: widget.username, orderBy: orderBy, limit: limit, offset: offset);
            },
            connection: widget.connection,
            key: UniqueKey(),
          ),
        ),
      ],
    );
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

  Widget buildUpperStack(BuildContext context) {
    final children = [
      Positioned(
        child: Container(
          height: 150,
          width: double.infinity,
          decoration:
              BoxDecoration(color: Colors.blue, border: Border(bottom: BorderSide(color: Colors.white, width: 0))),
        ),
      ),
      Positioned(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
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
                username: this.widget.username,
                handler: ErrorHandler(context),
                connection: this.widget.connection,
                size: 90,
                clickable: false,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        top: 110,
        left: 30,
      ),
      Positioned(
        child: TextButton(
          onPressed: () {
            // TODO : Edit profile
            print("edit profile");
          },
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
    ];
    if (this.widget.provideReturnArrow) {
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
            style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.4), minimumSize: Size.zero, padding: EdgeInsets.all(4)),
          ),
        ),
      );
    }
    return Stack(
      clipBehavior: Clip.none,
      children: children,
    );
  }

  /// The summary is the zone directly underneath the top stack, it displays
  /// the name, the number of followers, the join date...
  Widget buildUserSummary() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "@${userModel.username}",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text("🗓️ joined twixer in ${DateFormat("MMMM").format(userModel.joinDate)} ${userModel.joinDate.day}",
            style: Theme.of(context).textTheme.bodyLarge)
      ],
    );
  }
}
