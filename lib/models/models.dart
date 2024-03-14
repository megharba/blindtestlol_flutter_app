class PlayerResponse {
  String musicId;
  String proposition;
  String type;
  String date;

  PlayerResponse({
    required this.musicId,
    required this.proposition,
    required this.type,
    required this.date,
  });

  factory PlayerResponse.fromJson(Map<String, dynamic> json) {
    return PlayerResponse(
      musicId: json['musicId'],
      proposition: json['proposition'],
      type: json['type'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'musicId': musicId,
      'proposition': proposition,
      'type': type,
      'date': date,
    };
  }
}

class Game {
  String gameId;
  Player player;
  int rounPlay;
  int round;
  List<Music> musicPlayed;
  bool over;

  Game({
    required this.gameId,
    required this.player,
    required this.rounPlay,
    required this.round,
    required this.musicPlayed,
    required this.over,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameId: json['gameId'],
      player: Player.fromJson(json['player']),
      rounPlay: json['rounPlay'],
      round: json['round'],
      musicPlayed: List<Music>.from(json['musicPlayed'].map((x) => Music.fromJson(x))),
      over: json['over'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'player': player.toJson(),
      'rounPlay': rounPlay,
      'round': round,
      'musicPlayed': List<dynamic>.from(musicPlayed.map((x) => x.toJson())),
      'over': over,
    };
  }
}

class Music {
  String id;
  String name;
  String date;
  String type;
  List<String> aliases;

  Music({
    required this.id,
    required this.name,
    required this.date,
    required this.type,
    required this.aliases,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      type: json['type'],
      aliases: List<String>.from(json['aliases']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'type': type,
      'aliases': List<dynamic>.from(aliases),
    };
  }
}

class Player {
  String name;
  int score;
  int combo;
  String mastery;

  Player({
    required this.name,
    required this.score,
    required this.combo,
    required this.mastery,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
      score: json['score'],
      combo: json['combo'],
      mastery: json['mastery'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'combo': combo,
      'mastery': mastery,
    };
  }
}

class GameResponse {
  String gameId;
  Player player;
  int roundToPlay;
  int round;
  List<Music> musicPlayed;
  bool over;

  GameResponse({
    required this.gameId,
    required this.player,
    required this.roundToPlay,
    required this.round,
    required this.musicPlayed,
    required this.over,
  });

  factory GameResponse.fromJson(Map<String, dynamic> json) {
    return GameResponse(
      gameId: json['gameId'],
      player: Player.fromJson(json['player']),
      roundToPlay: json['roundToPlay'],
      round: json['round'],
      musicPlayed: List<Music>.from(json['musicPlayed'].map((x) => Music.fromJson(x))),
      over: json['over'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'player': player.toJson(),
      'roundToPlay': roundToPlay,
      'round': round,
      'musicPlayed': List<dynamic>.from(musicPlayed.map((x) => x.toJson())),
      'over': over,
    };
  }
}
