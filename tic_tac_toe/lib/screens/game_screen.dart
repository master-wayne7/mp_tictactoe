import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/provider/room_data_provider.dart';
import 'package:tic_tac_toe/resources/socket_methods.dart';
import 'package:tic_tac_toe/views/score_board.dart';
import 'package:tic_tac_toe/views/tictactoe_board.dart';
import 'package:tic_tac_toe/views/waiting_lobby.dart';

class GameScreen extends StatefulWidget {
  static String routeName = '/game';
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketMethods.updateRoomListener(context);
    _socketMethods.updatePlayersListeners(context);
    _socketMethods.pointIncreaseListener(context);
    _socketMethods.endGameListener(context);
  }

  @override
  Widget build(BuildContext context) {
    bool allow = false;
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    setState(() {
      allow = roomDataProvider.roomData['isJoin'];
    });

    return Scaffold(
      body: allow
          ? WaitingLobby()
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ScoreBoard(),
                  TicTacToeBoard(),
                  Text(
                    "${roomDataProvider.roomData['turn']['nickname']}'s turn",
                  ),
                ],
              ),
            ),
    );
  }
}
