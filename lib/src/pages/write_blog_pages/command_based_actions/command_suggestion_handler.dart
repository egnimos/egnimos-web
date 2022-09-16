import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/command_constants.dart';
import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/command_suggestion_constants.dart';
import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/commands.dart';

class CommandSuggestionHandler {
  final String cmdText;
  final void Function(List<String> suggestion) showOverlay;
  CommandSuggestionHandler(
    this.cmdText, {
    required this.showOverlay,
  });

  //start the command suggestion
  void startSuggestion() {
    //get the length
    var trimText = cmdText.trim();
    trimText = trimText.replaceAll(" ", "");
    final length = trimText.length;
    //print("TRIM TEXT: $trimText");
    //print("LENGTH: $length");

    //check the (0 index), if the given index doesn't contains
    //the value [@] then stop the execution
    //check the (1 index), if the given index doesn't contains
    //the value [<] the stop the execution
    if (length == 1) {
      if (startCommand[0].contains(trimText[0])) {
        showOverlay(commandNames.keys.toList());
        return;
      }
    }

    if (length == 2) {
      if (startCommand[0].contains(trimText[0]) &&
          startCommand[1].contains(trimText[1])) {
        // //print("SUGGESTION:: ${suggestions[trimText[0]]}");
        showOverlay(commandNames.keys.toList());
        return;
      }
    }

    if (commands.join(", ").contains(trimText)) {
      final cmd = filterCommand(trimText);
      //print(cmd);
      final values =
          commandNames.keys.toList().where((e) => e.contains(cmd)).toList();
      showOverlay(values);
      return;
    }
  }

  String filterCommand(String text) {
    int size = text.length;
    return text.substring(2, size - 1);
  }
}
