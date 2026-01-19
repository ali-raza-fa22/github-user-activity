import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> fetchUserActivity(String username) async {
  final url = Uri.parse("https://api.github.com/users/$username/events");
  try {
    final res = await http.get(url);

    if (res.statusCode == 404) {
      print("User $username not found.");
      return;
    }

    print("Fetching $username's activity...\n");
    if (res.statusCode == 200) {
      final events = jsonDecode(res.body);
      printUserActivity(events);
    } else {
      print("Error: ${res.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
    return;
  }
}

void printUserActivity(List<dynamic> activity) {
  if (activity.isEmpty) {
    print("No activity found for this user.");
    return;
  }
  for (var event in activity) {
    String type = event['type'];
    String repo = event['repo']['name'];
    String createdAt = event['created_at'];
    String action;

    switch (type) {
      case 'PushEvent':
        int commits = (event['payload']?['commits'] as List?)?.length ?? 0;
        action = 'Pushed $commits commit(s) to $repo on $createdAt';
        break;
      case 'IssuesEvent':
        String issueAction = event['payload']['action'];
        action = '$issueAction an issue in $repo on $createdAt';
        break;
      case 'ForkEvent':
        action = 'forked $repo on $createdAt';
        break;
      case 'WatchEvent':
        action = 'starred $repo on $createdAt';
        break;
      case 'CreateEvent':
        action = 'created a new branch in $repo on $createdAt';
        break;
      default:
        action = '$type in $repo';
    }
    print("- $action");
  }
}
