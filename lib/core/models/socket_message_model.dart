class SocketMessageModel<T> {
  final String event;
  final T data;

  SocketMessageModel({required this.event, required this.data});

  factory SocketMessageModel.fromJson(Map<String, dynamic> json) {
    return SocketMessageModel(
      event: json['event'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'data': data,
    };
  }
}
