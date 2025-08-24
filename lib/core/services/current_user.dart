class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();

  factory CurrentUser() => _instance;

  CurrentUser._internal();

  String? uId;
  String? name;
}
