

///Responsible for checking the user's invites path in firebase for any new
///active chat invites using a periodic timer (check every 1 sec) until cancelled
class ChatInviteObserver
{
  /// Start the periodic callback
  void beginObserving()
  {

  }

  /*
  Javascript cloud functions are the only ones that can do this. They trigger
  whenever a write to a specific path in the database occurs, which will
  then invoke Firebase Cloud Messaging to notify the user

  However in order to do this the project must be under the Blaze pricing plan

  Otherwise at most only a local Firebase emulator can be used

  Hmm... so some node server is monitoring the database at all times
   */
}
