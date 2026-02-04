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
  final Ayah ayah;

  const RecitationReady({required this.ayah});

  @override
  List<Object?> get props => [ayah];
}

class RecitationListening extends RecitationState {
  final Ayah ayah;
  final RecitationProgress progress;

  const RecitationListening({required this.ayah, required this.progress});

  @override
  List<Object?> get props => [ayah, progress];
}

class RecitationError extends RecitationState {
  final String message;

  const RecitationError(this.message);

  @override
  List<Object?> get props => [message];
}
