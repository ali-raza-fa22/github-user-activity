import '../lib/utils.dart';

void main(List<String> args) async {
  if (args.isEmpty || args.length > 1) {
    print("Error: Please provide exactly one username as an argument.");
    print("Usage: dart run bin/main.dart <username>");
    return;
  }

  final username = args[0];
  await fetchUserActivity(username);
}
