import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/provider/room_data_provider.dart';
import 'package:tic_tac_toe/resources/socket_methods.dart';

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({super.key});

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  final SocketMethods _socketMethods = SocketMethods();
  void tapped(int index, RoomDataProvider roomDataProvider) {
    _socketMethods.tapGrid(index, roomDataProvider.roomData['_id'],
        roomDataProvider.displayElement);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socketMethods.tappedListener(context);
  }

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.7,
        maxWidth: 500,
      ),
      child: AbsorbPointer(
        absorbing: roomDataProvider.roomData['turn']['socketId'] !=
            _socketMethods.socketClient.id,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: 9,
          itemBuilder: ((BuildContext context, index) {
            return GestureDetector(
              onTap: () => tapped(index, roomDataProvider),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),
                child: Center(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      roomDataProvider.displayElement[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 100,
                        shadows: [
                          Shadow(
                            blurRadius: 40,
                            color: roomDataProvider.displayElement[index] == 'X'
                                ? Colors.blue
                                : Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
