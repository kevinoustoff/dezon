
class User{
  String _email;
  String _password;

  User(){
    this._email ='';
    this._password ='';
  }
  User.fromJson(Map<String, dynamic> parsedJson){
    this._email = parsedJson['email'];
    this._password = parsedJson['password'];
  }

   String get email => this._email;
   String get password => this._password;
}