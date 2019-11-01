import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjcehostelredressal/utils/Constants.dart';

class CommonData{
  static saveLoginData(Map user) async {
    SharedPreferences Loginprefs = await SharedPreferences.getInstance();
    Loginprefs.setBool(Constants.isLoggedIn, true);
    Loginprefs.setString(Constants.loggedInUserId, user['id']);

    Loginprefs.setString(Constants.loggedInName, user['Name']);

    Loginprefs.setInt(Constants.loggedInUserRole, user['userRole']);

    Loginprefs.setString(Constants.loggedInUserMobile, user['userMobile']);

    Loginprefs.setString(Constants.loggedInUserBlock, user['userBlock']);

    Loginprefs.setString(Constants.loggedInUserRoom, user['userRoom']);
  }

static void clearLoggedInUserData() async {
  SharedPreferences removePrefs = await SharedPreferences.getInstance();

  removePrefs.setBool(Constants.isLoggedIn, false);
  removePrefs.setBool(Constants.isLoggedOut, true);

  removePrefs.remove(Constants.loggedInUserMobile);
  removePrefs.remove(Constants.loggedInName);
  removePrefs.remove(Constants.loggedInUserBlock);
  removePrefs.remove(Constants.loggedInUserRoom);
  removePrefs.remove(Constants.loggedInUserRole);

}

}