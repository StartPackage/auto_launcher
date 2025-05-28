class CliFormatter {
  static int totalWidth = 100; // Consistent width for all logs

// Box drawing characters
  static String topLeft = '╔';
  static String topRight = '╗';
  static String bottomLeft = '╚';
  static String bottomRight = '╝';
  static String horizontal = '═';
  static String vertical = '║';

  static final ansiEscape = RegExp(r'\x1B\[[0-9;]*m');

  /// Helper to create a perfectly centered line with balanced spacing
  static String createCenteredLine(String content) {
    final strippedContent = content.replaceAll(ansiEscape, '');

    int contentLength = strippedContent.length;
    int sidePadding = (totalWidth - contentLength) ~/ 2;
    String line = '${' ' * sidePadding}$content${' ' * sidePadding}';

    // Ensure the line is exactly totalWidth by balancing odd length differences
    if (line.length < totalWidth) {
      line += ' ';
    }

    return line;
  }

  /// Helper to generate an empty line with box vertical borders and spaces inside
  static String createEmptyBoxLine(color) {
    return '$color$vertical${' ' * totalWidth}$vertical\x1B[0m';
  }

  /// Helper to generate a line with content inside the box with vertical borders and centering
  static String createBoxedLine(String content, color) {
    return '$color$vertical${createCenteredLine(content)}$vertical\x1B[0m';
  }

  static printBoxTopBorder(color) {
    print('$color$topLeft${horizontal * totalWidth}$topRight\x1B[0m');
  }

  static printBoxBottomBorder(color) {
    print('$color$bottomLeft${horizontal * totalWidth}$bottomRight\x1B[0m');
  }

  static printLogFormat(
    String title,
    List<String> names, {
    String status = '',
    bool isLast = false,
  }) {
    String color = status == 'success'
        ? '\x1B[96m'
        : status == 'error'
            ? '\x1B[95m'
            : '\x1B[92m';
    if (status != '') print('+' * (totalWidth + 2));
    printBoxTopBorder(color);

    if (title != null) {
      print(createBoxedLine(title, color));
    } else {
      print(createEmptyBoxLine(color));
    }

    // Separator line (a row of ~)
    print(createBoxedLine((status == '' ? '~' : '-') * totalWidth, color));
    print(createEmptyBoxLine(color));

    // Print all names (lines) centered inside the box
    for (var name in names) {
      print(createBoxedLine(name, color));
    }

    print(createEmptyBoxLine(color));
    printBoxBottomBorder(color);
    if (isLast) print('+' * (totalWidth + 2));
  }
}
