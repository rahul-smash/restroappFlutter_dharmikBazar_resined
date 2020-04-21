import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {


  Widget futureBuild<T>({ Future<T> future, Widget Function(BuildContext, T) builder, Widget placeholder, bool showSpinner }) {

    var decoratedBuilder = (context, snapshot){
      if (snapshot.connectionState == ConnectionState.done)
      {
        if (snapshot.hasError) {
          var error = snapshot.error;
          throw error;
        } else {
          return builder(context, snapshot.data);
        }
      }
      else 
      {
        return showSpinner == true
                ? Center(child:CircularProgressIndicator())
                : placeholder != null
                  ? placeholder
                  : Container(color: Colors.white);
      }
    };

    return FutureBuilder(future: future, builder: decoratedBuilder);
  }


}