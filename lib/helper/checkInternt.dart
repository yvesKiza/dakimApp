import 'dart:io';

class CheckInternetConnection{
  Future<bool> get check async {
    bool _result=false;
    try {
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    _result=true;
  }
} on SocketException catch (_) {
  return false;
}
return _result;


  }
}