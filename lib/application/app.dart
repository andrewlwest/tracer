import 'package:Tracer/application/router.dart' as router;
import 'package:Tracer/ui/colors.dart';
import 'package:Tracer/home.dart';
import 'package:flutter/material.dart';

class TracerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracer',
      home: HomePage(),
      initialRoute: "/login",
      onGenerateRoute: router.generateRoute,
      theme: _kTracersTheme, // New code
    );
  }
}

final Typography typography2018 = Typography(
  englishLike: Typography.englishLike2018,
  dense: Typography.dense2018,
  tall: Typography.tall2018,
);

final ThemeData _kTracersTheme = _buildTracersTheme();

ThemeData _buildTracersTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    typography: typography2018,
    accentColor: kTracersBlue900,
    primaryColor: kTracersBlue500,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: kTracersBlue500,
      textTheme: ButtonTextTheme.normal,
    ),
    scaffoldBackgroundColor: kTracersBackgroundWhite,
    cardColor: kTracersBackgroundWhite,
    textSelectionColor: kTracersBlue500,
    errorColor: kTracersRed500,
    textTheme: _buildTracersTextTheme(base.textTheme),
    primaryTextTheme: _buildTracersTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTracersTextTheme(base.accentTextTheme),
  );
}

TextTheme _buildTracersTextTheme(TextTheme base) {
  return base
      .copyWith(
        // headline: base.headline.copyWith(
        //   fontWeight: FontWeight.w500,
        // ),
        title: base.title.copyWith(fontSize: 18.0),
        subhead: TextStyle(color: kTracersBlue500, fontSize: 12),

        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
          //fontFamily: 'Rubik',
          //displayColor: kTracersBlue900,
          //bodyColor: kTracersBlue900,
          );
}
