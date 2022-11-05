class ChatMessage {
   ChatMessage(this.message, this.senderName, this.timestamp);

  late final String senderName;
  final String message;
  final DateTime timestamp;
}
