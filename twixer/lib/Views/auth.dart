import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/Views/navigation.dart';
import 'package:twixer/Widgets/buttons/button_with_loading.dart';
import 'package:twixer/Widgets/buttons/form_checkbox.dart';

class AuthView extends StatefulWidget {
  final String _clauseString = "I agree to the storage of all data published";

  @override
  State<StatefulWidget> createState() {
    return _AuthViewState();
  }
}

class _AuthViewState extends State<AuthView> {
  bool login = true; // If false shows sign up screen.
  bool agreement = false;
  String? errorMessage;
  bool loading = false;

  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Twixer"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Navigation(
                            connection: Connection("guest", true),
                          )));
              print("GUEST");
              print("WARNING : NOT IMPLEMENTED FULLY");
            },
            child: Text(
              "Continue as guest",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          )
        ],
      ),
      body: Container(
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
                  autocorrect: false,
                  controller: usernameController,
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
                autocorrect: false,
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value != null && (value.length > 40 || 8 > value.length)) {
                    return "Password must be more than 8 characters long and less than 40 characters.";
                  }
                  return null;
                },
              ),
              checkBox(),
              ButtonWithLoading(
                loading: loading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      errorMessage = null;
                      loading = true;
                    });
                    if (login) {
                      Connection.establishLogin(
                        usernameController.text,
                        passwordController.text,
                      ).then((result) {
                        connectionEstablished(result);
                      });
                    } else {
                      Connection.createAccount(
                        usernameController.text,
                        passwordController.text,
                      ).then((result) {
                        connectionEstablished(result);
                      });
                    }
                  }
                },
                child: Text(login ? "Login" : "Signup"),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      login = !login;
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
    );
  }

  void connectionEstablished((bool, Connection?, String?) result) {
    final success = result.$1;
    final connection = result.$2;
    final error = result.$3;
    if (success) {
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
}
