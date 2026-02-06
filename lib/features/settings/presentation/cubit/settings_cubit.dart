import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsState extends Equatable {
  final bool showHelpWords;

  const SettingsState({this.showHelpWords = false});

  SettingsState copyWith({bool? showHelpWords}) {
    return SettingsState(
      showHelpWords: showHelpWords ?? this.showHelpWords,
    );
  }

  @override
  List<Object> get props => [showHelpWords];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleShowHelpWords() {
    emit(state.copyWith(showHelpWords: !state.showHelpWords));
  }
}
