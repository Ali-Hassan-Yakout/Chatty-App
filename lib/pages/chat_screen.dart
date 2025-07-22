import 'package:chatty/utils/app_colors.dart';
import 'package:chatty/widgets/custom_message_item.dart';
import 'package:chatty/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../models/chat.dart';
import '../providers/authentication_provider.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late AuthenticationProvider authenticationProvider;
  late GlobalKey<FormState> messageFormState;
  late ScrollController messageListViewController;
  late ChatProvider chatProvider;

  @override
  void initState() {
    super.initState();
    messageFormState = GlobalKey<FormState>();
    messageListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    authenticationProvider = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatProvider(
            authenticationProvider,
            widget.chat.uid,
            messageListViewController,
          ),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        chatProvider = context.watch<ChatProvider>();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.chat.chatTitle(),
              style: TextStyle(fontSize: 20.sp),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  chatProvider.deleteChat();
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(15.r),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: messagesListView(),
                ),
                sendMessageForm(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget messagesListView() {
    if (chatProvider.messages != null) {
      if (chatProvider.messages!.isNotEmpty) {
        return ListView.builder(
          controller: messageListViewController,
          shrinkWrap: true,
          itemCount: chatProvider.messages!.length,
          itemBuilder: (context, index) {
            final message = chatProvider.messages![index];
            final isMine =
                authenticationProvider.appUser.uid == message.senderId;
            final sender = widget.chat.members.firstWhere(
              (member) => member.uid == message.senderId,
            );

            return CustomMessageItem(
              message: message,
              isMine: isMine,
              sender: sender,
            );
          },
        );
      } else {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.78,
          child: const Align(
            alignment: Alignment.center,
            child: Text(
              "Be the first to say HI",
              style: TextStyle(color: Colors.white),
            ),
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
  }

  Widget sendMessageForm() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.textFormFieldFill,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Form(
              key: messageFormState,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  messageTextField(),
                  sendImageButton(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        sendMessageButton()
      ],
    );
  }

  Widget messageTextField() {
    return Expanded(
      child: CustomTextFormField(
        onSaved: (value) {
          chatProvider.message = value;
        },
        regEx: r'^.+$',
        hintText: "Type a message...",
        obscureText: false,
        chat: true,
      ),
    );
  }

  Widget sendMessageButton() {
    return GestureDetector(
      onTap: () {
        if (messageFormState.currentState!.validate()) {
          messageFormState.currentState!.save();
          chatProvider.sendTextMessage();
          messageFormState.currentState!.reset();
        }
      },
      child: CircleAvatar(
        radius: 24.r,
        backgroundColor: AppColors.elevatedButton,
        child: Icon(
          Icons.send_rounded,
          color: Colors.white,
          size: 30.r,
        ),
      ),
    );
  }

  Widget sendImageButton() {
    return IconButton(
      onPressed: () {
        chatProvider.sendImageMessage();
      },
      color: AppColors.elevatedButton,
      iconSize: 30.r,
      icon: const Icon(Icons.image),
    );
  }
}
