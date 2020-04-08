import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;

  openHomePage(StoreModel store) {
    _timer = new Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(CustomPageRoute(HomeScreen(store)));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
        future: ApiController.versionApiRequest("1"),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container();
          } else {
            if (projectSnap.hasData) {
              StoreResponse model = projectSnap.data;
              if (model.success) {
                openHomePage(model.store);
                return Container();
              } else {
                return Container();
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.black26,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
              );
            }
          }
        },
      ),
    );
  }
}

class CustomPageRoute<T> extends PageRoute<T> {
  CustomPageRoute(this.child);
  @override
  Color get barrierColor => Colors.black;

  @override
  String get barrierLabel => null;

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(seconds: 1);
}
