import 'dart:async';
import 'dart:developer';
import 'package:dms_assement/core/constants/app_constatns.dart';
import 'package:dms_assement/core/models/socket_message_model.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket _socket;
  late StreamController<SocketMessageModel> streamController;

  void connect({
    String url = AppConstatns.baseUrl,
    Function(dynamic)? onConnect,
    Function(dynamic)? onDisconnect,
    Function(dynamic)? onError,
  }) {
    streamController = StreamController.broadcast();
    _socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.onConnect((data) {
      debugPrint('Socket connected');
      onConnect?.call(data);
    });

    _socket.onDisconnect((data) {
      debugPrint('Socket disconnected');
      onDisconnect?.call(data);
    });

    _socket.onError((error) {
      debugPrint('Socket error: $error');
      onError?.call(error);
    });

    _socket.onAny((String event, dynamic data) {
      log('Event: $event: Data: $data');
      streamController.add(
        SocketMessageModel(event: event, data: data),
      );
    });
  }

  void sendMessage({
    required String eventName,
    required Map<String, dynamic> data,
  }) {
    _socket.emit(eventName, data);
  }

  // void listenForMessages(Function(dynamic) callback) {
  //   _socket.on(SocketConstants.RIDE_REQUEST, (data) {
  //     log('Ride request: $data');
  //     callback.call(data);
  //   });
  // }

  void disconnect() {
    streamController.close();
    _socket.disconnect();
  }
}
