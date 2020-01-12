// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color.fromRGBO(241, 243, 246, 1),
  _Element.text: Color(0xFF282828),
  _Element.shadow: Color.fromRGBO(0, 0, 0, 0.07),
};

final _darkTheme = {
  _Element.background: Color.fromRGBO(56, 56, 56, 1),
  _Element.text: Color.fromRGBO(233, 233, 233, 1),
  _Element.shadow: Color.fromRGBO(0, 0, 0, 0.07),
};
var neuEffectLight = [
  BoxShadow(
    blurRadius: 0,
    color: Color.fromRGBO(55, 84, 170, 0.1),
    offset: Offset(7, 7),
  ),
  BoxShadow(
    blurRadius: 0,
    color: Color.fromRGBO(255, 255, 255, 1),
    offset: Offset(-7, -7),
  ),
  BoxShadow(
    blurRadius: 0,
    color: Color.fromRGBO(255, 255, 255, 0.5),
    offset: Offset(3, 3),
  ),
];
var neuEffectDark = [
  BoxShadow(
    blurRadius: 0,
    color: Color.fromRGBO(0, 0, 0, 0.43),
    offset: Offset(7, 7),
  ),
  BoxShadow(
    blurRadius: 0,
    color: Color.fromRGBO(77, 77, 77, 0.4),
    offset: Offset(-7, -7),
  ),
  BoxShadow(
    blurRadius: 0,
    color: Color.fromRGBO(77, 77, 77, 0.5),
    offset: Offset(3, 3),
  ),
];

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var _temperature = '';
  var _templow = '';
  var _temphigh = '';
  var _condition = '';
  var _location = '';
  var _weatherIcon = Icons.cloud_off;
  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() => setState(() {}));
    animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);

    animationController.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.repeat();
      }
    });
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    animationController.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.

      _temperature = widget.model.temperatureString;
      _templow = widget.model.lowString;
      _temphigh = widget.model.highString;
      _condition = widget.model.weatherString;
      _location = widget.model.location;
      switch (_condition) {
        case "cloudy":
          _weatherIcon = Icons.wb_cloudy;
          break;
        case "foggy":
          _weatherIcon = FontAwesomeIcons.smog;
          break;
        case "rainy":
          _weatherIcon = FontAwesomeIcons.cloudRain;
          break;
        case "snowy":
          _weatherIcon = FontAwesomeIcons.snowflake;
          break;
        case "sunny":
          _weatherIcon = Icons.wb_sunny;
          break;
        case "thunderstorm":
          _weatherIcon = FontAwesomeIcons.cloudShowersHeavy;
          break;
        case "windy":
          _weatherIcon = FontAwesomeIcons.wind;
          break;
      }
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  void updateShadow() {
    setState(() {
      neuEffectLight = [
        BoxShadow(
          blurRadius: MediaQuery.of(context).size.height * 0.0096666,
          color: Color.fromRGBO(55, 84, 170, 0.1),
          offset: Offset(7, 7),
        ),
        BoxShadow(
          blurRadius: MediaQuery.of(context).size.height * 0.026666,
          color: Color.fromRGBO(255, 255, 255, 1),
          offset: Offset(-7, -7),
        ),
        BoxShadow(
          blurRadius: MediaQuery.of(context).size.height * 0.0066666666,
          color: Color.fromRGBO(255, 255, 255, 0.5),
          offset: Offset(3, 3),
        ),
      ];
      neuEffectDark = [
        BoxShadow(
          blurRadius: MediaQuery.of(context).size.height * 0.0096666,
          color: Color.fromRGBO(0, 0, 0, 0.23),
          offset: Offset(7, 7),
        ),
        BoxShadow(
          blurRadius: MediaQuery.of(context).size.height * 0.026666,
          color: Color.fromRGBO(77, 77, 77, 0.14),
          offset: Offset(-7, -7),
        ),
        BoxShadow(
          blurRadius: MediaQuery.of(context).size.height * 0.0066666666,
          color: Color.fromRGBO(77, 77, 77, 0.5),
          offset: Offset(3, 3),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    updateShadow();
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final neuEffect = Theme.of(context).brightness == Brightness.light
        ? neuEffectLight
        : neuEffectDark;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 8;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'monoton',
      fontSize: fontSize,
      // shadows: [
      //   Shadow(
      //     blurRadius: 0,
      //     color: colors[_Element.shadow],
      //     offset: Offset(10, 0),
      //   ),
      // ],
    );
    // print(animationController.value);
    Widget temperatureBlock = Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: colors[_Element.background],
        boxShadow: neuEffect,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DefaultTextStyle(
                style: defaultStyle,
                child: Text(
                  _temperature,
                  style: TextStyle(
                    fontSize: fontSize / 3,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: neuEffect,
                  shape: BoxShape.circle,
                  color: colors[_Element.background],
                ),
                child: Icon(_weatherIcon, color: colors[_Element.text]),
              )
            ],
          ),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                    style: TextStyle(
                      color: colors[_Element.text],
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(text: "Day $_temphigh"),
                      WidgetSpan(
                        child: Icon(
                          Icons.arrow_upward,
                        ),
                      ),
                      WidgetSpan(
                          child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.023,
                      )),
                      TextSpan(text: "Night $_templow"),
                      WidgetSpan(
                        child: Icon(
                          Icons.arrow_downward,
                        ),
                      )
                    ]),
              )
            ],
          )
        ],
      ),
    );
    Widget precipitationBlock = Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: colors[_Element.background],
        boxShadow: neuEffect,
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              boxShadow: neuEffect,
              shape: BoxShape.circle,
              color: colors[_Element.background],
            ),
            child: Icon(
              FontAwesomeIcons.tint,
              color: colors[_Element.text],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Text(
            "28%\nPrecipitation",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: colors[_Element.text],
            ),
          ),
        ],
      ),
    );
    Widget windDirectionBlock = Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: colors[_Element.background],
        boxShadow: neuEffect,
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              boxShadow: neuEffect,
              shape: BoxShape.circle,
              color: colors[_Element.background],
            ),
            child: Icon(FontAwesomeIcons.locationArrow,
                color: colors[_Element.text]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Text(
            "11 km/h\nWind Speed",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: colors[_Element.text]),
          ),
        ],
      ),
    );
    Widget upperRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        windDirectionBlock,
        temperatureBlock,
        precipitationBlock,
      ],
    );
    Widget clockBlock = Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: colors[_Element.background],
        boxShadow: neuEffect,
      ),
      child: DefaultTextStyle(
        style: defaultStyle,
        child: RichText(
          textScaleFactor: 0.9,
          text: TextSpan(style: defaultStyle, children: <TextSpan>[
            TextSpan(
              text: "$hour",
            ),
            TextSpan(
              text: ":",
              style: TextStyle(
                fontSize: fontSize * 1.3,
                fontFamily: 'sans',
                textBaseline: TextBaseline.alphabetic,
                color: colors[_Element.text].withOpacity(
                    animationController.value < 0.5
                        ? (animationController.value * 2) % 1
                        : (1 - (animationController.value) % 1)),
              ),
            ),
            TextSpan(text: "$minute"),
          ]),
        ),
      ),
    );
    Widget sunRiseBlock = Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: colors[_Element.background],
        boxShadow: neuEffect,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            FontAwesomeIcons.cloudSun,
            size: fontSize * 0.4,
            color: colors[_Element.text].withOpacity(0.83),
          ),
          SizedBox(
            height: fontSize * 0.03,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: colors[_Element.text],
              ),
              children: [
                TextSpan(
                    text: "Sunrise\n",
                    style: TextStyle(
                        color: colors[_Element.text].withOpacity(0.6),
                        fontWeight: FontWeight.w400)),
                TextSpan(
                    text: "05:30 AM",
                    style: TextStyle(
                        fontSize: fontSize * 0.17,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );

    Widget sunSetBlock = Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: colors[_Element.background],
        boxShadow: neuEffect,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            FontAwesomeIcons.cloudMoon,
            size: fontSize * 0.4,
            color: colors[_Element.text].withOpacity(0.83),
          ),
          SizedBox(
            height: fontSize * 0.03,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: colors[_Element.text],
              ),
              children: [
                TextSpan(
                    text: "Sunset\n",
                    style: TextStyle(
                        color: colors[_Element.text].withOpacity(0.6),
                        fontWeight: FontWeight.w400)),
                TextSpan(
                    text: "06:40 PM",
                    style: TextStyle(
                        fontSize: fontSize * 0.17,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );

    Widget midBlock = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        sunRiseBlock,
        clockBlock,
        sunSetBlock,
      ],
    );
    Widget locationBlock = Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: colors[_Element.background],
        boxShadow: neuEffect,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DefaultTextStyle(
            style: defaultStyle,
            child: Text(
              _location,
              style: TextStyle(
                fontSize: fontSize / 3,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w300,
              ),
            ),
          )
        ],
      ),
    );
    return Container(
      color: colors[_Element.background],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          upperRow,
          midBlock,
          locationBlock,
        ],
      ),
    );
  }
}
