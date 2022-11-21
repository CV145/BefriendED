

/// A chat invite sent from uid1 to uid2. An invite can only be accepted if it's
/// 'active'. Invites are deactivated if they expire or are declined by the
/// receiving user. Deactivated invites are removed from firebase and eventually
/// removed entirely. We need an invite model so it can be represented in the UI
class ChatInvite
{
  ChatInvite({required this.senderID, required this.fromName, required this.toName,
  required this.isDeclined, required this.year, required this.month, required
  this.day, required this.hour, required this.minute,})
  {
    print('from: $fromName');
    print('to: $toName');
  }

  String senderID; //Primary key
  String fromName;
  String toName;
  bool isDeclined;
  int year;
  int month;
  int day;
  int hour;
  int minute;
}
