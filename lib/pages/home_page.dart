import 'package:flutter/material.dart';
import 'package:open_weather/constants/constants.dart';
import 'package:open_weather/cubits/temp_settings/temp_settings_cubit.dart';
import 'package:open_weather/cubits/weather/weather_cubit.dart';

import 'package:open_weather/pages/search_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather/pages/settings_page.dart';
import 'package:open_weather/widgets/error_dialog.dart';
import 'package:recase/recase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              _city = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SearchPage()));
              print('City: $_city');

              if (_city != null) {
                context.read<WeatherCubit>().fetchWeather(_city!);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: _showWeather(),
    );
  }

  String showTemperature(double temperature) {
    final tempUnit = context.read<TempSettingsCubit>().state.tempUnit;

    if (tempUnit == TempUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    }

    return temperature.toStringAsFixed(2) + '℃';
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/img/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String description) {
    final formatterdString = description.titleCase;
    return Text(
      formatterdString,
      style: const TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, state.error.errorMsg);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text('Select a city', style: TextStyle(fontSize: 20.0)),
          );
        }
        if (state.status == WeatherStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.status == WeatherStatus.error && state.weather.name == '') {
          return const Center(
            child: Text('Select a city', style: TextStyle(fontSize: 20.0)),
          );
        }

        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              state.weather.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(state.weather.lastUpdated).format(context),
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: 10.0),
                Text(
                  '(${state.weather.country})',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            SizedBox(height: 60.0),
            BlocBuilder<TempSettingsCubit, TempSettingsState>(
              builder: (c, s) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${showTemperature(state.weather.temp)}',
                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20.0),
                    Column(
                      children: [
                        Text(
                          '${showTemperature(state.weather.tempMax)}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '${showTemperature(state.weather.tempMin)}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                showIcon(state.weather.icon),
                Expanded(flex: 3, child: formatText(state.weather.description)),
                Spacer(),
              ],
            )
          ],
        );
      },
    );
  }
}
