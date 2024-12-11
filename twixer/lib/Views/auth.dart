import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/Views/navigation.dart';
import 'package:twixer/Widgets/buttons/button_with_loading.dart';
import 'package:twixer/Widgets/buttons/form_checkbox.dart';
import 'package:twixer/Widgets/other/twixer_loading_indicator.dart';

class AuthView extends StatefulWidget {
  final String _clauseString = "I agree to the storage of all data published";

  /// Whether the view is displayed because the user clicked the logout button.
  /// In this case, stored login data is erased.
  final bool logout;

  AuthView({required this.logout}) {
    print("init");
    print(this.logout);
  }

  @override
  State<StatefulWidget> createState() {
    return _AuthViewState();
  }
}

class _AuthViewState extends State<AuthView> {
  bool loadingConnection = true;

  bool login = true; // If false shows sign up screen.
  bool agreement = false;
  String? errorMessage;
  bool loading = false;
  late final SharedPreferences sharedPreferences;

  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _AuthViewState() {}

  @override
  void initState() {
    super.initState();
    if (this.widget.logout) {
      setState(() {
        loadingConnection = false;
      });
      SharedPreferences.getInstance().then((result) async {
        this.sharedPreferences = result;
        this.sharedPreferences.remove("connection");
      });
    } else {
      SharedPreferences.getInstance().then((result) async {
        this.sharedPreferences = result;
        if (this.sharedPreferences.containsKey("connection")) {
          final List con = this.sharedPreferences.get("connection") as List;
          await this
              .connectionEstablished((true, Connection(con[0], false, int.parse(con[1]), username: con[2]), null));
        }

        setState(() {
          loadingConnection = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.loadingConnection) {
      return Center(
        child: Container(
          width: 100,
          child: TwixerLoadingIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Twixer"),
        actions: [
          /*TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Navigation(
                            connection: Connection("guest", true, -1),
                          )));
              print("GUEST");
              print("WARNING : NOT IMPLEMENTED FULLY");
            },
            child: Text(
              "Continue as guest",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          )*/
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        login ? "Login" : "Create an account",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(login
                          ? "Please enter your credentials to begin using your account."
                          : "Please fill in your username and password to create an account."),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      this._passwordFocus.requestFocus();
                    },
                    autocorrect: false,
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: "Username"),
                    validator: (value) {
                      if (value != null && value.length > 40) {
                        return "Username length must be under 40 characters.";
                      }
                      return null;
                    },
                  ),
                ),
                TextFormField(
                  onFieldSubmitted: (value) {
                    doAction();
                  },
                  focusNode: this._passwordFocus,
                  autocorrect: false,
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  validator: (value) {
                    if (login) {
                      return null;
                    }
                    if (value != null && (value.length > 40 || 8 > value.length)) {
                      return "Password must be more than 8 characters long and less than 40 characters.";
                    }
                    return null;
                  },
                ),
                checkBox(),
                ButtonWithLoading(
                  loading: loading,
                  onPressed: doAction,
                  child: Text(login ? "Login" : "Signup"),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        login = !login;
                        this._passwordController.text = "";
                      });
                    },
                    child: Text(login ? "I don't have an account" : "I already have an account"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    (errorMessage == null) ? "" : errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Called when the main button (login/signup) is pressed.
  void doAction() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        errorMessage = null;
        loading = true;
      });
      if (login) {
        Connection.establishLogin(
          _usernameController.text,
          _passwordController.text,
        ).then((result) {
          connectionEstablished(result);
        });
      } else {
        Connection.createAccount(
          _usernameController.text,
          _passwordController.text,
        ).then((result) {
          connectionEstablished(result);
        });
      }
    }
  }

  Future<void> connectionEstablished((bool, Connection?, String?) result) async {
    final success = result.$1;
    final connection = result.$2;
    final error = result.$3;
    if (success) {
      await sharedPreferences
          .setStringList("connection", [connection!.token, connection.user_id.toString(), connection.username!]);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Navigation(
                    connection: connection!,
                  )));
    } else {
      if (error == null) {
        print("WARNING : Login call was not succesful but returned no error message.");
      }
      setState(() {
        this.errorMessage = error;
        this.loading = false;
      });
    }
  }

  Widget checkBox() {
    if (login) {
      return Text("");
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: CheckboxFormField(
          title: Text(
            widget._clauseString,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          validator: (value) {
            if (!value!) {
              return "You need to agree";
            } else {
              return null;
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    this._passwordController.dispose();
    this._usernameController.dispose();
  }
}
