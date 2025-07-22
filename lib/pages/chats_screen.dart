import 'package:chatty/models/app_user.dart';
import 'package:chatty/models/chat.dart';
import 'package:chatty/providers/authentication_provider.dart';
import 'package:chatty/providers/chats_provider.dart';
import 'package:chatty/utils/app_navigation.dart';
import 'package:chatty/widgets/custom_chats_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import 'chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late AuthenticationProvider authenticationProvider;
  late ChatsProvider chatsProvider;
  late AppNavigation appNav;

  @override
  Widget build(BuildContext context) {
    authenticationProvider = Provider.of<AuthenticationProvider>(context);
    appNav = GetIt.instance.get<AppNavigation>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatsProvider(authenticationProvider),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chats"),
          actions: [
            IconButton(
              onPressed: () {
                authenticationProvider.logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: buildUI(),
      ),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (context) {
        chatsProvider = context.watch<ChatsProvider>();
        List<Chat>? chats = chatsProvider.chats;

        return Padding(
          padding: EdgeInsets.all(15.r),
          child: Column(
            children: [
              Expanded(
                child: () {
                  if (chats != null) {
                    if (chats.isNotEmpty) {
                      return ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          return chatItemBuilder(chats[index]);
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "No chats found",
                          style: TextStyle(color: Colors.white),
                        ),
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget chatItemBuilder(Chat chat) {
    List<AppUser>? recipients = chat.chatRecipients();
    bool isActive = recipients.any(
      (element) => element.wasRecentlyActive(),
    );
    String subtitle = "";
    if (chat.messages.isNotEmpty) {
      subtitle = chat.messages.first.type != MessageType.text
          ? "Media Attachment"
          : chat.messages.first.content;
    }
    return CustomChatsItem(
      height: 50.h,
      title: chat.chatTitle(),
      subtitle: subtitle,
      imagePath: chat.chatImageURL(),
      isActive: isActive,
      isGroup: chat.isGroup,
      isActivity: chat.isActivity,
      onTap: () {
        appNav.navigateToPage(ChatScreen(chat: chat));
      },
    );
  }
}
