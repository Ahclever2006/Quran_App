class ArabicTextUtils {
  ArabicTextUtils._();

  // Arabic diacritics (tashkeel/harakat) and Uthmani marks
  // NOTE: U+0670 (superscript alef) is excluded — it represents a hidden
  // alef that is pronounced, so normalize() expands it to a full alef.
  static final _diacriticsRegex = RegExp(
    '[\u0610-\u061A\u064B-\u065F\u06D6-\u06DC\u06DF-\u06ED\u08D3-\u08E1\u08E3-\u08FF\uFE70-\uFE7F]',
  );

  // Uthmani ornamental markers (rub el hizb, sajdah, etc.)
  static final _markersRegex = RegExp('[\u06DE\u06E9]');

  static String removeDiacritics(String text) {
    return text
        .replaceAll(_diacriticsRegex, '')
        .replaceAll(_markersRegex, '');
  }

  static String normalize(String text) {
    // Expand superscript alef to full alef before stripping diacritics
    // (e.g. الرحمٰن → الرحمان — the hidden alef is pronounced)
    var result = text.replaceAll('\u0670', '\u0627');
    result = removeDiacritics(result);
    // Normalize alef variants to bare alef
    result = result.replaceAll(RegExp('[\u0622\u0623\u0625\u0671]'), '\u0627');
    // Normalize hamza variants
    result = result.replaceAll('\u0624', '\u0648'); // ؤ → و
    result = result.replaceAll('\u0626', '\u064A'); // ئ → ي
    result = result.replaceAll('\u0621', '');        // ء → remove
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
