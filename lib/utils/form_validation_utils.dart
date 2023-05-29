class RegexPattern {
  const RegexPattern._internal();
  static const instance = RegexPattern._internal();
  factory RegexPattern() => instance;

  // two decimal places number
  static const twoDecimalPlaces = r'^\d+\.?\d{0,2}';
  // int, minimum one
  static const intMinimumOne = r'^[1-9]\d*$';
  // int, minimum one, max length three
  static const intMinimumOneMaxLengthThree = r'^[1-9]\d{0,2}$';

  // REGEX EMAIL
  static const emailPattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";

  // REGEX PASSWORD
  static const passwordMinThreePattern = r'^.{3,}$';
  // Minimum eight characters, at least one letter and one number:
  static const passwordMinEightChOneLetOneNumPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';

  // Minimum eight characters, at least one letter, one number and one special character:
  static const passwordMinEightChOneLetOneNumOneSpChPattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$';

  // Minimum eight characters, at least one uppercase letter, one lowercase letter and one number:
  static const passwordMinEightChOneUpLetOneLowLetOneNumPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$';

  // Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character:
  static const passwordMinEightChOneUpLetOneLowLetOneNumOneSpChPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  // Minimum eight and maximum 10 characters, at least one uppercase letter, one lowercase letter, one number and one special character:
  static const passwordMinEightMaxTenChOneUpLetOneLowLetOneNumOneSpChPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,10}$';
}

class FormValidationUtils {
  const FormValidationUtils._internal();
  static const instance = FormValidationUtils._internal(); // create a singleton
  factory FormValidationUtils() => instance;

  static String? formFieldValidator({required String? value, required String fieldName}) {
    if (value == null || value.isEmpty) {
      return '"$fieldName" field can\'t be empty';
    }
    return null;
  }

  static String? contactFieldValidator({required String? value, required String fieldName, required int length}) {
    if (value == null || value.isEmpty) {
      return '"$fieldName" field can\'t be empty';
    } else if (value.length != length) {
      return '"$fieldName" must be of length "$length"';
    }
    return null;
  }

  static String? dateTimeValidator({required String? value, required String fieldName}) {
    if (value == null) {
      return '"$fieldName" field can\'t be empty';
    }
    return null;
  }

  static String? emailValidator({required String? email}) {
    RegExp emailRegex = RegExp(RegexPattern.emailPattern);
    if (email == null || email.isEmpty) {
      return '"Email" field can\'t be empty';
    } else if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid Email';
    }
    return null;
  }

  static String? passwordValidator({required String? password}) {
    RegExp passwordRegex = RegExp(RegexPattern.passwordMinThreePattern);
    if (password == null || password.isEmpty) {
      return '"Password" field can\'t be empty';
    } else if (!passwordRegex.hasMatch(password)) {
      return 'Password must contain at least 3 characters in lengths containing one small character, one capital character.';
    }
    return null;
  }

  static String? regexValidator({
    required String fieldName,
    required String? value,
    required RegExp pattern,
    String onInvalidMessage = 'Invalid',
  }) {
    if (value == null || value.isEmpty) {
      return '"$fieldName" field can\'t be empty';
    } else if (!pattern.hasMatch(value)) {
      return onInvalidMessage;
    }
    return null;
  }
}
