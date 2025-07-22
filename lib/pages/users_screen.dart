import 'package:chatty/models/app_user.dart';
import 'package:chatty/providers/authentication_provider.dart';
import 'package:chatty/widgets/custom_elevatedbutton.dart';
import 'package:chatty/widgets/custom_user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';
import '../widgets/custom_search_field.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late AuthenticationProvider authenticationProvider;
  late UsersProvider usersProvider;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsersProvider(authenticationProvider),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (context) {
        usersProvider = context.watch<UsersProvider>();
        return Scaffold(
          appBar: AppBar(
            title: const Text("Users"),
            actions: [
              IconButton(
                onPressed: () {
                  authenticationProvider.logout();
                },
                icon: const Icon(Icons.logout),
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(15.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomSearchField(
                  onEditingComplete: (value) {
                    usersProvider.getUsers(name: value);
                    FocusScope.of(context).unfocus();
                  },
                  hintText: "Search...",
                  obscure: false,
                  controller: controller,
                  icon: Icons.search,
                ),
                usersListView(),
                createChatButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget usersListView() {
    return Expanded(
      child: () {
        if (usersProvider.users != null) {
          if (usersProvider.users!.isNotEmpty) {
            return ListView.builder(
              itemCount: usersProvider.users!.length,
              itemBuilder: (context, index) {
                List<AppUser> users = usersProvider.users!;
                return CustomUserItem(
                  height: 50.h,
                  title: users[index].name,
                  subtitle: "Last Active: ${users[index].lastDayActive()}",
                  imagePath: users[index].imageURL,
                  isActive: users[index].wasRecentlyActive(),
                  isSelected: usersProvider.selectedUsers.contains(
                    users[index],
                  ),
                  onTap: () {
                    setState(() {
                      usersProvider.updateSelectedUsers(users[index]);
                    });
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text("No users found"),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      }(),
    );
  }

  Widget createChatButton() {
    if (usersProvider.selectedUsers.isEmpty) {
      return Container();
    } else {
      return CustomElevatedButton(
        name: usersProvider.selectedUsers.length > 1
            ? "Create Group Chat"
            : "Chat With ${usersProvider.selectedUsers.first.name}",
        height: 50.h,
        width: double.infinity,
        onPressed: () {
          usersProvider.createChat();
        },
      );
    }
  }
}
