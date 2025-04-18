class ScoreService {
  static const String _baseUrl = "http://192.168.1.33/game_api/save_score.php";

  Future<bool> saveScore(String userId, int score) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          "user_id": userId,
          "score": score.toString(),
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['success'];
      }
    } catch (e) {
      print("Error saving score: $e");
    }
    return false;
  }
}
