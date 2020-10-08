import 'package:flutter/material.dart';
import 'package:restroapp/src/utils/AppColor.dart';

class ProgressBar extends StatefulWidget {
  ProgressBar({Key key}) : super(key: key);

  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 1600),
      vsync: this,
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBar(
      controller: animationController,
    );
  }
}

class AnimatedBar extends StatelessWidget {
  final dotSize = 10.0;

  AnimatedBar({Key key, this.controller})
      : dotOneColor = ColorTween(
          begin: grayLightColor,
          end: appTheme,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.000,
              0.100,
              curve: Curves.linear,
            ),
          ),
        ),
        textOneStyle = TextStyleTween(
          begin: TextStyle(
              fontWeight: FontWeight.w400, color: grayLightColor, fontSize: 12),
          end: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 12),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.000,
              0.100,
              curve: Curves.linear,
            ),
          ),
        ),
        progressBarOne = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.100, 0.450),
          ),
        ),
        dotTwoColor = ColorTween(
          begin: grayLightColor,
          end: appTheme,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.450,
              0.550,
              curve: Curves.linear,
            ),
          ),
        ),
        textTwoStyle = TextStyleTween(
          begin: TextStyle(
              fontWeight: FontWeight.w400, color: grayLightColor, fontSize: 12),
          end: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 12),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.450,
              0.550,
              curve: Curves.linear,
            ),
          ),
        ),
        progressBarTwo = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.550, 0.900),
          ),
        ),
        dotThreeColor = ColorTween(
          begin: grayLightColor,
          end: appTheme,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.900,
              1.000,
              curve: Curves.linear,
            ),
          ),
        ),
        textThreeStyle = TextStyleTween(
          begin: TextStyle(
              fontWeight: FontWeight.w400, color: grayLightColor, fontSize: 12),
          end: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 12),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.900,
              1.000,
              curve: Curves.linear,
            ),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<Color> dotOneColor;
  final Animation<TextStyle> textOneStyle;
  final Animation<double> progressBarOne;
  final Animation<Color> dotTwoColor;
  final Animation<TextStyle> textTwoStyle;
  final Animation<double> progressBarTwo;
  final Animation<Color> dotThreeColor;
  final Animation<TextStyle> textThreeStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dotSize / 2),
                  color: dotOneColor.value),
            ),
            Container(
              height: 30,
              width: 2,
              child: LinearProgressIndicator(
                backgroundColor: grayLightColor,
                value: progressBarOne.value,
                valueColor: AlwaysStoppedAnimation<Color>(appTheme),
              ),
            ),
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dotSize / 2),
                  color: dotTwoColor.value),
            ),
            Container(
              height: 30,
              width: 2,
              child: LinearProgressIndicator(
                backgroundColor: grayLightColor,
                value: progressBarTwo.value,
                valueColor: AlwaysStoppedAnimation<Color>(appTheme),
              ),
            ),
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dotSize / 2),
                  color: dotThreeColor.value),
            ),

//            Container(
//              margin: EdgeInsets.only(top: 5),
//              width: MediaQuery.of(context).size.width / 1.2,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text(
//                    'Recieved',
//                    style: textOneStyle.value,
//                  ),
//                  Text(
//                    'Preparing',
//                    style: textTwoStyle.value,
//                  ),
//                  Text(
//                    'Ready',
//                    style: textThreeStyle.value,
//                  ),
//                ],
//              ),
//            )
          ],
        ),
      ),
    );
  }
}
