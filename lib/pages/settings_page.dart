import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather/cubits/temp_settings/temp_settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: ListTile(
          title: const Text('Temperature Unit'),
          subtitle: const Text('Celsious/Fahrenheit (Default: Celsius)'),
          trailing: BlocBuilder<TempSettingsCubit, TempSettingsState>(
            builder: (context, state) {
              return Switch(
                value: context.read<TempSettingsCubit>().state.tempUnit == TempUnit.fahrenheit,
                onChanged: (_) {
                  context.read<TempSettingsCubit>().toggleTempSettings();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
