import 'package:flutter/material.dart';
import 'package:tic_tac_toe/resources/socket_methods.dart';

import '../responsive/responsive.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_textfield.dart';

class JoinRoomScreen extends StatefulWidget {
  static String routeName = '/join-room';
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gameIdController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketMethods.joinRoomSuccessListener(context);
    _socketMethods.errorOccurredListener(context);
    _socketMethods.updatePlayersListeners(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    gameIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                shadows: [
                  Shadow(
                    blurRadius: 40,
                    color: Colors.blue,
                  ),
                ],
                text: 'Join Room',
                fontSize: 70,
              ),
              SizedBox(
                height: size.height * 0.08,
              ),
              CustomTextField(
                controller: nameController,
                hintText: 'Enter your nickname',
              ),
              SizedBox(
                height: size.height * 0.045,
              ),
              CustomTextField(
                controller: gameIdController,
                hintText: 'Enter Game ID',
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                onTap: () => _socketMethods.joinRoom(
                    nameController.text, gameIdController.text),
                text: 'Join',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
