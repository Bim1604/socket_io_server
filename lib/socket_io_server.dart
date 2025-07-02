import 'dart:io';
import 'package:socket_io/socket_io.dart';

final receivedConfirmStore = "receivedConfirmStore";
final sendConfirmStore = "sendConfirmStore";
final actionResult = 'actionResult';
final String sendConfirm = "sendConfirm";

void main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final io = Server();

  io.on('connection', (client) {
    print('✅ Client connected: ${client.id}');

    client.on('ping', (data) {
      print('📥 Received ping: $data');
      client.emit('pong', 'Hello from Dart server!');
    });

    client.on(sendConfirmStore, (data) {
      print('Received $sendConfirmStore: $data');
      print("toString $data.toString()");
      print(data.toString() == "StoreConfirm");
      if (data.toString() == "StoreConfirm") {
        client.emit(receivedConfirmStore, data);
      }
    });

    client.on(receivedConfirmStore, (data) {
      /// confirmXPoint:hai:502
      print('Received $receivedConfirmStore: $data');
      List<String> temp = data.toString().split(":");
      int xPoint = int.parse(temp[1]);
      int money = int.parse(temp[2]);
      client.emit(sendConfirmStore, "$actionResult:$xPoint:$money");
    });

    client.on('disconnect', (_) {
      print('❌ Client disconnected');
    });
  });

  io.listen(port);
  print('🚀 Server listening on port $port');
}
