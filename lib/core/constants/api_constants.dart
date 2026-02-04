class ApiConstants {
  ApiConstants._();

  static const String quranBaseUrl = 'https://api.alquran.cloud/v1';
  static const String surahListEndpoint = '/surah';
  static String surahEndpoint(int number) => '/surah/$number';
  static String ayahEndpoint(int surahNumber, int ayahNumber) =>
      '/ayah/$surahNumber:$ayahNumber';

  static const String webSocketBaseUrl = 'ws://localhost:8000';
  static const String recitationSocketPath = '/ws/recitation';
}
