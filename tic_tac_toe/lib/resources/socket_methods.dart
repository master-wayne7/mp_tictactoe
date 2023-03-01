import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:tic_tac_toe/provider/room_data_provider.dart';
import 'package:tic_tac_toe/resources/game_methods.dart';
import 'package:tic_tac_toe/resources/socket_client.dart';
import 'package:tic_tac_toe/screens/main_menu_screen.dart';
import 'package:tic_tac_toe/utils/utils.dart';

import '../screens/game_screen.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;
  Socket get socketClient => _socketClient;

  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('createRoom', {
        'nickname': nickname,
      });
    }
  }

  void joinRoom(String nickname, String roomId) {
    if (nickname.isNotEmpty && roomId.isNotEmpty) {
      _socketClient.emit("joinRoom", {
        'nickname': nickname,
        "roomId": roomId,
      });
    }
  }

  void tapGrid(int index, String roomId, List<String> displayElements) {
    if (displayElements[index] == '') {
      _socketClient.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  void createRoomSuccessListener(BuildContext context) {
    _socketClient.on('CreateRoomSuccess', (room) {
      print('------------------');
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      print('---------------5555555555555555');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GameScreen(),
      ));
    });
  }

  void joinRoomSuccessListener(BuildContext context) {
    _socketClient.on('joinRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void errorOccurredListener(BuildContext context) {
    _socketClient.on('errorOccurred', (data) {
      showSnackBar(context, data);
    });
  }

  void updatePlayersListeners(BuildContext context) {
    _socketClient.on(
        'updatePlayers',
        (playerData) => {
              Provider.of<RoomDataProvider>(
                context,
                listen: false,
              ).updatePlayer1(playerData[0])
            });
    _socketClient.on(
        'updatePlayers',
        (playerData) => {
              Provider.of<RoomDataProvider>(
                context,
                listen: false,
              ).updatePlayer2(playerData[1])
            });
  }

  void updateRoomListener(BuildContext context) {
    _socketClient.on('updateRoom', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(data);
    });
  }

  void tappedListener(BuildContext context) {
    _socketClient.on('tapped', (data) {
      RoomDataProvider roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      roomDataProvider.updateDisplayelements(
        data['index'],
        data['choice'],
      );
      roomDataProvider.updateRoomData(data['room']);
      GameMethods().checkWinner(context, _socketClient);
    });
  }

  void pointIncreaseListener(BuildContext context) {
    _socketClient.on('pointIncrease', (playerData) {
      var roomDataProvider =
          Provider.of<RoomDataProvider>(context, listen: false);
      if (playerData['socketID'] == roomDataProvider.player1.socketID) {
        roomDataProvider.updatePlayer1(playerData);
      } else {
        roomDataProvider.updatePlayer2(playerData);
      }
    });
  }

  void endGameListener(BuildContext context) {
    _socketClient.on('endGame', (playerData) {
      showGameDialog(context, '${playerData['nickname']} won the game.');
      Navigator.pushReplacementNamed(context, MainMenuScreen.routeName);
    });
  }
}
