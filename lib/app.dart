import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/recitation/presentation/cubit/recitation_cubit.dart';
import 'features/recitation/presentation/cubit/recording_timer_cubit.dart';
import 'features/recitation/presentation/cubit/surah_list_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/recitation/presentation/screens/recitation_screen.dart';

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SurahListCubit>()..loadSurahs()),
        BlocProvider(create: (_) => sl<RecitationCubit>()),
        BlocProvider(create: (_) => sl<RecordingTimerCubit>()),
        BlocProvider(create: (_) => sl<SettingsCubit>()),
      ],
      child: BlocSelector<SettingsCubit, SettingsState, bool>(
        selector: (state) => state.isDarkMode,
        builder: (context, isDarkMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quran App',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const RecitationScreen(),
          );
        },
      ),
    );
  }
}
