import 'dart:io';
import 'package:socket_io/socket_io.dart';

void main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '3000');
  final io = Server();

  io.on('connection', (client) {
    print('✅ Client connected: ${client.id}');

    client.on('ping', (data) {
      print('📥 Received ping: $data');
      client.emit('pong', 'Hello from Dart server!');
    });

    client.on('disconnect', (_) {
      print('❌ Client disconnected');
    });
  });

  io.listen(port);
  print('🚀 Server listening on port $port');
}
