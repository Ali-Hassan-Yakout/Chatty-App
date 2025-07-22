import 'package:chatty/models/app_user.dart';
import 'package:chatty/models/chat.dart';
import 'package:chatty/pages/chat_screen.dart';
import 'package:chatty/providers/authentication_provider.dart';
import 'package:chatty/utils/app_cloud_database.dart';
import 'package:chatty/utils/app_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:toastification/toastification.dart';

import '../utils/app_toast.dart';

class UsersProvider extends ChangeNotifier {
  final AuthenticationProvider _authenticationProvider;
  late AppCloudDatabase _appDatabase;
  late AppNavigation _appNav;
  List<AppUser>? _users;
  late List<AppUser> _selectedUsers;

  UsersProvider(this._authenticationProvider) {
    _selectedUsers = [];
    _appDatabase = GetIt.instance.get<AppCloudDatabase>();
    _appNav = GetIt.instance.get<AppNavigation>();
    getUsers();
  }

  List<AppUser>? get users => _users;

  List<AppUser> get selectedUsers => _selectedUsers;

  void getUsers({String? name}) async {
    _selectedUsers = [];
    try {
      _appDatabase.getUsers(name).then(
        (snapShot) {
          _users = snapShot.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['uid'] = doc.id;
              return AppUser.fromJson(data);
            },
          ).toList();
          _users!.removeWhere(
            (user) => user.uid == _authenticationProvider.appUser.uid,
          );
          notifyListeners();
        },
      );
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while getting users. Please try again.",
        type: ToastificationType.error,
      );
    }
  }

  void updateSelectedUsers(AppUser user) {
    if (_selectedUsers.contains(user)) {
      _selectedUsers.remove(user);
    } else {
      _selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      List<String> memberIds = [];
      for (AppUser user in _selectedUsers) {
        memberIds.add(user.uid);
      }
      memberIds.add(_authenticationProvider.appUser.uid);
      bool isGroupChat = selectedUsers.length > 1;
      DocumentReference? doc = await _appDatabase.createChat({
        'isGroup': isGroupChat,
        'isActivity': false,
        'members': memberIds,
      });
      List<AppUser> members = [];
      for (var uid in memberIds) {
        DocumentSnapshot snap = await _appDatabase.getUser(uid);
        Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
        data['uid'] = snap.id;
        members.add(AppUser.fromJson(data));
      }
      ChatScreen chatScreen = ChatScreen(
        chat: Chat(
          uid: doc!.id,
          currentUserUid: _authenticationProvider.appUser.uid,
          messages: [],
          isActivity: false,
          isGroup: isGroupChat,
          members: members,
        ),
      );
      _selectedUsers = [];
      notifyListeners();
      _appNav.navigateToPage(chatScreen);
    } catch (e) {
      AppToast.displayToast(
        title: "Error",
        description:
            "Something went wrong while creating chat. Please try again.",
        type: ToastificationType.error,
      );
    }
  }
}
