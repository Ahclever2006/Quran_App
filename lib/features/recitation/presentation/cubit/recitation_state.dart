import 'package:equatable/equatable.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/recitation_progress.dart';

abstract class RecitationState extends Equatable {
  const RecitationState();

  @override
  List<Object?> get props => [];
}

class RecitationIdle extends RecitationState {
  const RecitationIdle();
}

class RecitationLoading extends RecitationState {
  const RecitationLoading();
}

class RecitationReady extends RecitationState {
  final List<Ayah> ayahs;
  final String surahName;

  const RecitationReady({required this.ayahs, required this.surahName});

  @override
  List<Object?> get props => [ayahs, surahName];
}

class RecitationListening extends RecitationState {
  final List<Ayah> ayahs;
  final String surahName;
  final RecitationProgress progress;

  const RecitationListening({
    required this.ayahs,
    required this.surahName,
    required this.progress,
  });

  @override
  List<Object?> get props => [surahName, progress];
}

class RecitationError extends RecitationState {
  final String message;

  const RecitationError(this.message);

  @override
  List<Object?> get props => [message];
}
