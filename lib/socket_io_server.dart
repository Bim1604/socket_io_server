import 'dart:io';
import 'package:socket_io/socket_io.dart';

final receivedConfirmStore = "receivedConfirmStore";
final sendConfirmStore = "sendConfirmStore";
final actionResult = 'actionResult';
final String sendConfirm = "sendConfirm";

void main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final io = Server();

  final Map<String, Socket> clients = {};

  io.on('connection', (client) {
    print('✅ Client connected: ${client.id}');
    clients[client.id] = client;
    client.on('ping', (data) {
      print('📥 Received ping: $data');
      client.emit('pong', 'Hello from Dart server!');
    });

    client.on(sendConfirmStore, (data) {
      MapEntry<String, Socket>? clientReceive = clients.entries
          .where((entry) => entry.value.id != client.id)
          .cast<MapEntry<String, Socket>?>()
          .firstOrNull;
      if (clientReceive != null && data.toString() == "StoreConfirm") {
        clientReceive.value.emit(receivedConfirmStore, data);
      }
    });

    client.on(receivedConfirmStore, (data) {
      /// confirmXPoint:hai:502
      print('Received $receivedConfirmStore: $data');
      List<String> temp = data.toString().split(":");
      if (temp.length > 1) {
        int xPoint = int.parse(temp[1]);
        int money = int.parse(temp[2]);
        client.emit(sendConfirmStore, "$actionResult:$xPoint:$money");
      }
    });

    client.on('disconnect', (_) {
      print('❌ Client disconnected');
    });
  });

  io.listen(port);
  print('🚀 Server listening on port $port');
}
