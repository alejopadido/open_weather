import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_weather/cubits/temp_settings/temp_settings_cubit.dart';
import 'package:open_weather/cubits/weather/weather_cubit.dart';
import 'package:open_weather/pages/home_page.dart';
import 'package:open_weather/repositories/weather_repository.dart';
import 'package:open_weather/services/weather_api_services.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          WeatherRepository(weatherApiServices: WeatherApiServices(httpClient: http.Client())),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WeatherCubit(
              weatherRepository: context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider<TempSettingsCubit>(create: (context) => TempSettingsCubit()),
        ],
        child: MaterialApp(
          theme: ThemeData(appBarTheme: AppBarTheme(centerTitle: true)),
          debugShowCheckedModeBanner: false,
          title: 'Weather App',
          home: const HomePage(),
        ),
      ),
    );
  }
}
