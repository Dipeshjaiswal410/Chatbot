import 'dart:convert';
import 'package:chatbot/components/constants.dart';
import 'package:http/http.dart' as http;

Future<String> generateResponse(String prompt) async {
  //var apiKey = "sk-proj-gAD9TVt1xeRObY6j0x0wT3BlbkFJGBr1HAUkofejlF3dR37k";
  var url = Uri.https("api.openai.com", "/v1/chat/completions");

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo', // Recent version model name
        'messages': [
          {
            'role': 'user',
            'content': prompt // User input to the chatbot
          }
        ],
        'temperature': 0.7, // You can adjust this for response randomness
        'max_tokens': 200, // Adjust token limit as needed
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      }),
    );

    if (response.statusCode == 200) {
      var newResponse = jsonDecode(response.body);
      if (newResponse.containsKey('choices') &&
          newResponse['choices'].isNotEmpty) {
        var botResponse = newResponse['choices'][0]['message']['content'];
        return botResponse; // Return the text from the response
      } else {
        return "Unexpected response structure.";
      }
    } else {
      var errorInfo = jsonDecode(response.body);
      var errorMessage = errorInfo['error']?['message'] ?? 'Unknown error';
      return "Error: $errorMessage";
    }
  } catch (e) {
    // Handling exceptions like network issues or JSON parsing errors
    return "Exception occurred: $e";
  }
}
