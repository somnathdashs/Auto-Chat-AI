import 'dart:convert';

import 'package:auto_chat_ai/Backend/Localstorage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';


class AskGemini {

  Future<String> Chat_with_Gemini(String query, String apiKey,
      [context]) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
    final content = [Content.text(query)];
    try {
      final res = await model.generateContent(content);
      return res.text!;
    } catch (e) {

    }
    return "";
  }

  String _GetReplyPrompt_as_Assistanse(String Details,String Name,List<String> conversions,){
    String _Conversions ="{\n";
    for (int i = 0; i<conversions.length;i++){
      _Conversions=_Conversions+conversions[i]+"\n";
    }
    _Conversions=_Conversions+"}";
    return """
     Here is a person details,you analyzed about his characters and behavior from the details. Details: '$Details'.
     And Here are Conversions with $Name and the person. Conversions $_Conversions.
     As the assistanse of the person; Keeping in mind about the person details and  write the next replay
     in there respective language else in English.
     NO NEED to generate any other text except the reply. The Reply Do not contains the person Name, Just and ONLY REPLY you have to generate.
     You are the assistant of the person and an AI You have to answer all question $Name asked you, you can't just deny.
     Don't forget to mention '(by <The Person name here>'s Assistant)' in the end of all chat
     You Name is : <The Person name here> Assistant
     """;
  }


  String _GetReplyPrompt(String Details,String Name,List<String> conversions,){
    String _Conversions ="{\n";
    for (int i = 0; i<conversions.length;i++){
      _Conversions=_Conversions+conversions[i]+"\n";
    }
    _Conversions=_Conversions+"}";
    return """
     Here is a person details,you analyzed about his characters and behavior from the details. Details: '$Details'.
     And Here are Conversions with $Name and the person. Conversions $_Conversions.
     On the behalf of the person;  Keeping in mind about the person characters and behaviour in mind write the next replay
     in there respective language else in English and if the Otherside person name is indian then talk in hinglish.
     NO NEED to generate any other text except the replay. The Replay Do not contains the person Name, Just and ONLY REPLY you have to generate.
     Don't forget to mention '(by <The Person name here> AI)' in the end of all chat
     """;
  }


  GetReply(String person_Name, List<String> Conversions, String apiKey,String details) async {
    if (apiKey.isNotEmpty) {
      String Prompt;
      if ((await LocalStorage.getBool(MyKey.Asyou.toString()) ?? false)){
        Prompt = _GetReplyPrompt(details, person_Name, Conversions);
      }else{
        Prompt = _GetReplyPrompt_as_Assistanse(details, person_Name, Conversions);
      }
      return Chat_with_Gemini(Prompt, apiKey);
    }
    return null;
  }


}
