import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_weather/models/custom_error.dart';
import 'package:open_weather/models/weather.dart';
import 'package:open_weather/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherCubit({required this.weatherRepository}) : super(WeatherState.initial());

  Future<void> fetchWeather(String city) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final Weather weather = await weatherRepository.fetchWeather(city);

      emit(state.copyWith(weather: weather, status: WeatherStatus.loaded));

      print('state: $state');
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          status: WeatherStatus.error,
          error: CustomError(errorMsg: e.errorMsg),
        ),
      );
      print('state: $state');
    }
  }
}
