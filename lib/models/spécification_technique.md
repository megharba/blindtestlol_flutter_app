## Technical Documentation for Data Models

### PlayerResponse Class

Represents a response from a player.

**Fields:**
- `musicId` (String): The ID of the music.
- `proposition` (String): The player's proposition.
- `type` (String): The type of response.
- `date` (DateTime): The date of the response.

**Constructor:**
```dart
PlayerResponse({
  required this.musicId,
  required this.proposition,
  required this.type,
  required this.date,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `PlayerResponse` from a JSON object. Throws `FormatException` if the date is invalid or missing.

**Methods:**
- `toJson()`: Converts the `PlayerResponse` instance to a JSON object.

### GameResponse Class

Represents the response for a game.

**Fields:**
- `gameId` (String?): The ID of the game.
- `player` (Player): The player object.
- `roundToPlay` (int): The round to be played.
- `round` (int): The current round.
- `musicPlayed` (List<MusicPlayed>): List of music played.
- `over` (bool): Indicates if the game is over.

**Constructor:**
```dart
GameResponse({
  this.gameId,
  required this.player,
  required this.roundToPlay,
  required this.round,
  required this.musicPlayed,
  required this.over,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `GameResponse` from a JSON object.

**Methods:**
- `toJson()`: Converts the `GameResponse` instance to a JSON object.

### Music Class

Represents a music object.

**Fields:**
- `id` (String): The ID of the music.
- `name` (String): The name of the music.
- `date` (String): The release date of the music.
- `type` (String): The type/genre of the music.
- `aliases` (List<String>): A list of aliases for the music.

**Constructor:**
```dart
Music({
  required this.id,
  required this.name,
  required this.date,
  required this.type,
  required this.aliases,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `Music` from a JSON object.

**Methods:**
- `toJson()`: Converts the `Music` instance to a JSON object.

### Player Class

Represents a player in the game.

**Fields:**
- `name` (String): The name of the player.
- `uid` (String): The unique ID of the player.
- `score` (int): The player's score.
- `combo` (int): The player's combo.
- `mastery` (String): The player's mastery level.

**Constructor:**
```dart
Player({
  required this.name,
  required this.uid,
  required this.score,
  required this.combo,
  required this.mastery,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `Player` from a JSON object.

**Methods:**
- `toJson()`: Converts the `Player` instance to a JSON object.

### PlayRoundResponse Class

Represents the response for playing a round.

**Fields:**
- `token` (String): The token for the round.
- `name` (String): The name associated with the round.
- `date` (String): The date of the round.
- `type` (String): The type of round.

**Constructor:**
```dart
PlayRoundResponse({
  required this.token,
  required this.name,
  required this.date,
  required this.type,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `PlayRoundResponse` from a JSON object.

**Methods:**
- `toJson()`: Converts the `PlayRoundResponse` instance to a JSON object.

### User Class

Represents a user in the system.

**Fields:**
- `id` (int): The ID of the user.
- `name` (String): The name of the user.
- `uid` (String): The unique ID of the user.
- `email` (String): The email of the user.
- `avatarToken` (String): The token for the user's avatar.
- `gamePlayed` (int): Number of games played by the user.
- `highScore` (List<HighScore>): List of high scores achieved by the user.
- `totalScore` (int): The total score of the user.

**Constructor:**
```dart
User({
  required this.id,
  required this.name,
  required this.uid,
  required this.email,
  required this.avatarToken,
  required this.gamePlayed,
  required this.highScore,
  required this.totalScore,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `User` from a JSON object.

**Methods:**
- `toJson()`: Converts the `User` instance to a JSON object.

### UserAvatar Class

Represents the association between a user and an avatar.

**Fields:**
- `id` (int): The ID of the association.
- `user` (User): The user object.
- `id_avatar` (int): The ID of the avatar.
- `isSelectable` (bool): Indicates if the avatar is selectable.
- `isSelected` (bool): Indicates if the avatar is selected.

**Constructor:**
```dart
UserAvatar({
  required this.id,
  required this.user,
  required this.id_avatar,
  required this.isSelectable,
  required this.isSelected,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `UserAvatar` from a JSON object.

**Methods:**
- `toJson()`: Converts the `UserAvatar` instance to a JSON object.

### Avatar Class

Represents an avatar in the system.

**Fields:**
- `id` (int): The ID of the avatar.
- `token` (String): The token associated with the avatar.
- `price` (int): The price of the avatar.

**Constructor:**
```dart
Avatar({
  required this.id,
  required this.token,
  required this.price,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `Avatar` from a JSON object.

### HighScore Class

Represents a high score achieved by a player.

**Fields:**
- `roundNumber` (int): The round number.
- `highScoreValue` (int): The value of the high score.
- `mastery` (String): The mastery level associated with the high score.

**Constructor:**
```dart
HighScore({
  required this.roundNumber,
  required this.highScoreValue,
  required this.mastery,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `HighScore` from a JSON object.

**Methods:**
- `toJson()`: Converts the `HighScore` instance to a JSON object.

### UserHighScore Class

Represents the high score of a user.

**Fields:**
- `userName` (String): The name of the user.
- `highScore` (HighScore): The high score object.

**Constructor:**
```dart
UserHighScore({
  required this.userName,
  required this.highScore,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `UserHighScore` from a JSON object.

**Methods:**
- `toJson()`: Converts the `UserHighScore` instance to a JSON object.

### MusicPlayed Class

Represents a music played during a game.

**Fields:**
- `token` (String): The token for the music.
- `name` (String): The name of the music.
- `date` (String): The date of the music.
- `type` (String): The type/genre of the music.
- `aliases` (List<String>): List of aliases for the music.

**Constructor:**
```dart
MusicPlayed({
  required this.token,
  required this.name,
  required this.date,
  required this.type,
  required this.aliases,
});
```

**Factory Method:**
- `fromJson(Map<String, dynamic> json)`: Creates an instance of `MusicPlayed` from a JSON object.

**Methods:**
- `toJson()`: Converts the `MusicPlayed` instance to a JSON object.
