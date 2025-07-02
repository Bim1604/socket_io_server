import 'dart:io';
import 'package:socket_io/socket_io.dart';

final channelCus = "sendXPoint";
final channel = "receiveXPoint";

void main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final io = Server();

  io.on('connection', (client) {
    print('✅ Client connected: ${client.id}');

    client.on('ping', (data) {
      print('📥 Received ping: $data');
      client.emit('pong', 'Hello from Dart server!');
    });

    client.on(channel, (data) {
      print('Received $channel: $data');
    });

    client.on(channelCus, (data) {
      print('Received $channelCus: $data');

    });

    client.on('disconnect', (_) {
      print('❌ Client disconnected');
    });

    client.on('disconnect', (_) {
      print('❌ Client disconnected');
    });
  });

  io.listen(port);
  print('🚀 Server listening on port $port');
}
