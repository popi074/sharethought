import 'package:nb_utils/nb_utils.dart';
import 'package:sharethought/core/network/database_constant.dart';

class SharedPrefData{
  email(String email){
    SharedPreferences.getInstance().then((pref){
      pref.getString(email); 
    } );
  }
  username(String username){
    SharedPreferences.getInstance().then((pref){
      pref.getString(username); 
    } );
  }

   contact(String contact){
    SharedPreferences.getInstance().then((pref){
      pref.getString(contact); 
    } );
  }
  //  toekn(String token){
  //   SharedPreferences.getInstance().then((pref){
  //     pref.getString(token); 
  //   } );
  // }
     Future<bool> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(DatabaseConst.token, token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? '';
  }
}