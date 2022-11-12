

class Request
{
    Request({required String requesterID, required String requesterName,
      required List<String> givenTopics,})
    {
      userID = requesterID;
      name = requesterName;
      topics = givenTopics;
    }

    //The requester and the topics they want to discuss
    late String name;
    late String userID;
    late List<String> topics;
}
