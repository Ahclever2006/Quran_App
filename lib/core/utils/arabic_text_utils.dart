class ArabicTextUtils {
  ArabicTextUtils._();

  // Arabic diacritics (tashkeel/harakat) Unicode range
  static final _diacriticsRegex = RegExp(
    '[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E4\u06E7\u06E8\u06EA-\u06ED\u08D3-\u08E1\u08E3-\u08FF\uFE70-\uFE7F]',
  );

  // Small/superscript letters used in Uthmani script
  static final _smallLettersRegex = RegExp(
    '[\u06D6-\u06DC\u06DF-\u06E4\u06E7\u06E8\u06EA-\u06ED]',
  );

  static String removeDiacritics(String text) {
    return text
        .replaceAll(_diacriticsRegex, '')
        .replaceAll(_smallLettersRegex, '');
  }

  static String normalize(String text) {
    var result = removeDiacritics(text);
    // Normalize alef variants to bare alef
    result = result.replaceAll(RegExp('[\u0622\u0623\u0625\u0671]'), '\u0627');
    // Normalize teh marbuta to heh
    result = result.replaceAll('\u0629', '\u0647');
    // Normalize alef maqsura to yeh
    result = result.replaceAll('\u0649', '\u064A');
    // Remove tatweel (kashida)
    result = result.replaceAll('\u0640', '');
    return result.trim();
  }

  static bool wordsMatch(String spoken, String expected) {
    return normalize(spoken) == normalize(expected);
  }
}
