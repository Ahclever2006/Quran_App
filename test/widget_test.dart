import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app/core/di/injection_container.dart';
import 'package:quran_app/core/theme/app_theme.dart';
import 'package:quran_app/features/recitation/presentation/cubit/recitation_cubit.dart';
import 'package:quran_app/features/recitation/presentation/cubit/surah_list_cubit.dart';
import 'package:quran_app/features/recitation/presentation/screens/recitation_screen.dart';

void main() {
  setUpAll(() {
    initDependencies();
  });

  tearDownAll(() {
    sl.reset();
  });

  testWidgets('RecitationScreen renders with app bar and controls',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<SurahListCubit>()),
          BlocProvider(create: (_) => sl<RecitationCubit>()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const RecitationScreen(),
        ),
      ),
    );

    expect(find.text('Quran Recitation Coach'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Select a surah and ayah to begin'), findsOneWidget);
  });
}
