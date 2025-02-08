import 'dart:convert';


class AuthCredentials {
  final String username;
  final String password;

  AuthCredentials(this.username, this.password);

  String get basicAuth {
    String credentials = '$username:$password';
    String encodedCredentials = base64Encode(utf8.encode(credentials));
    print(username);
    print(password);
    return 'Basic $encodedCredentials';
  }
}


// Usage


