import 'dart:math';

class Utils {
  static String generateUUID({int length = 8}) {
    final random = Random();
    const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final uuid = StringBuffer();

    for (int i = 0; i < length; i++) {
      final index = random.nextInt(characters.length);
      uuid.write(characters[index]);
    }

    return uuid.toString();
  }
}
