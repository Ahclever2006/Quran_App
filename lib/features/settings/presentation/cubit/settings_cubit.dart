import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState extends Equatable {
  final bool showHelpWords;
  final bool isDarkMode;

  const SettingsState({this.showHelpWords = false, this.isDarkMode = false});

  SettingsState copyWith({bool? showHelpWords, bool? isDarkMode}) {
    return SettingsState(
      showHelpWords: showHelpWords ?? this.showHelpWords,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object> get props => [showHelpWords, isDarkMode];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleShowHelpWords() {
    emit(state.copyWith(showHelpWords: !state.showHelpWords));
  }

  void toggleDarkMode() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }
}
