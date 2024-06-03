import 'package:flutter/material.dart';
import 'package:weather/services/weather.dart';
import 'package:weather/utilities/constants.dart';
import 'package:weather/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int? temperature;
  int? condition;
  String? cityName;
  String? WeatherIcon;
  String? MessageIcon;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic WeatherData) {
    setState(() {
      if (WeatherData == null) {
        temperature = 0;
        WeatherIcon = 'Error';
        MessageIcon = 'Unable to get weather data';
        cityName = '';
        return;
      }
      temperature = WeatherData['main']['temp'].toInt();
      condition = WeatherData['weather'][0]['id'].toInt();
      cityName = WeatherData['name'];
      WeatherIcon = weather.getWeatherIcon(condition!);
      MessageIcon = weather.getMessage(temperature!);
    });

    print('$temperature C');
    print(condition);
    print(cityName);
    print(WeatherIcon);
    print(MessageIcon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.black,
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () async {
                      var weatherData = await weather.getWeatherData();
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const CityScreen();
                      }));
                      print(typedName);
                      if (typedName != null) {
                        var weatherData =
                            await weather.GetCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 49, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$temperature°C',
                      style: kTempTextStyle,
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      '$WeatherIcon',
                      style: kConditionTextStyle,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                child: Text(
                  "$MessageIcon in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
