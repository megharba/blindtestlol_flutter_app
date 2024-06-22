# Documentation Technique

## Services

### UserService

**Description**: Ce service gère les opérations liées aux utilisateurs, telles que la création, la connexion, la mise à jour des mots de passe, et l'achat d'avatars.

#### Méthodes

##### `createUser`

- **Description**: Crée un nouvel utilisateur.
- **Paramètres**:
  - `name` (String): Nom de l'utilisateur.
  - `email` (String): Adresse e-mail de l'utilisateur.
  - `password` (String): Mot de passe de l'utilisateur.
- **Retourne**: `Future<User>` - Un objet utilisateur.
- **Exceptions**: `Exception` si l'utilisateur ne peut pas être créé.

```dart
Future<User> createUser(String name, String email, String password) async;
```

##### `connectUser`

- **Description**: Connecte un utilisateur existant.
- **Paramètres**:
  - `name` (String): Nom de l'utilisateur.
  - `password` (String): Mot de passe de l'utilisateur.
- **Retourne**: `Future<User>` - Un objet utilisateur.
- **Exceptions**: `Exception` si l'utilisateur ne peut pas être connecté.

```dart
Future<User> connectUser(String name, String password) async;
```

##### `updatePassword`

- **Description**: Met à jour le mot de passe d'un utilisateur.
- **Paramètres**:
  - `userUid` (String): UID de l'utilisateur.
  - `newPassword` (String): Nouveau mot de passe.
- **Retourne**: `Future<User>` - Un objet utilisateur.
- **Exceptions**: `Exception` si le mot de passe ne peut pas être mis à jour.

```dart
Future<User> updatePassword(String userUid, String newPassword) async;
```

##### `getUser`

- **Description**: Récupère les informations d'un utilisateur.
- **Paramètres**:
  - `userUid` (String): UID de l'utilisateur.
- **Retourne**: `Future<User>` - Un objet utilisateur.
- **Exceptions**: `Exception` si l'utilisateur ne peut pas être récupéré.

```dart
Future<User> getUser(String userUid) async;
```

##### `getAllAvatars`

- **Description**: Récupère tous les avatars disponibles pour un utilisateur.
- **Paramètres**:
  - `userUid` (String): UID de l'utilisateur.
- **Retourne**: `Future<List<Avatar>>` - Une liste d'objets avatar.
- **Exceptions**: `Exception` si les avatars ne peuvent pas être récupérés.

```dart
Future<List<Avatar>> getAllAvatars(String userUid) async;
```

##### `buyAvatar`

- **Description**: Achète un avatar pour un utilisateur.
- **Paramètres**:
  - `userUid` (String): UID de l'utilisateur.
  - `avatarId` (int): ID de l'avatar à acheter.
- **Retourne**: `Future<void>`
- **Exceptions**: `Exception` si l'achat échoue.

```dart
Future<void> buyAvatar(String userUid, int avatarId) async;
```

### MusicService

**Description**: Ce service gère les opérations liées aux musiques, telles que la récupération de la liste des musiques disponibles.

#### Méthodes

##### `getMusicList`

- **Description**: Récupère la liste de toutes les musiques disponibles.
- **Retourne**: `Future<List<Music>>` - Une liste d'objets musique.
- **Exceptions**: `Exception` si les musiques ne peuvent pas être récupérées.

```dart
Future<List<Music>> getMusicList() async;
```

### HighScoreService

**Description**: Ce service gère les opérations liées aux scores élevés, telles que la récupération de la liste des meilleurs scores pour un tour donné.

#### Méthodes

##### `getHighScores`

- **Description**: Récupère la liste des meilleurs scores pour un tour spécifique.
- **Paramètres**:
  - `round` (int): Numéro du tour.
- **Retourne**: `Future<List<UserHighScore>>` - Une liste d'objets UserHighScore.
- **Exceptions**: `Exception` si les scores ne peuvent pas être récupérés.

```dart
Future<List<UserHighScore>> getHighScores(int round) async;
```

### GameService

**Description**: Ce service gère les opérations liées aux jeux, telles que la création de jeux, la lecture de tours, et l'envoi des réponses des joueurs.

#### Méthodes

##### `createGame`

- **Description**: Crée un nouveau jeu pour un utilisateur.
- **Paramètres**:
  - `userUid` (String): UID de l'utilisateur.
  - `roundToPlay` (int): Nombre de tours à jouer.
- **Retourne**: `Future<GameResponse>` - Un objet réponse de jeu.
- **Exceptions**: `Exception` si le jeu ne peut pas être créé.

```dart
Future<GameResponse> createGame(String userUid, int roundToPlay) async;
```

##### `playRound`

- **Description**: Joue un tour de jeu.
- **Paramètres**:
  - `gameId` (String): ID du jeu.
- **Retourne**: `Future<PlayRoundResponse?>` - Un objet réponse de tour ou null si une erreur survient.
- **Exceptions**: `Exception` si le tour ne peut pas être joué.

```dart
Future<PlayRoundResponse?> playRound(String gameId) async;
```

##### `postPlayerResponse`

- **Description**: Envoie la réponse d'un joueur pour une musique donnée.
- **Paramètres**:
  - `gameId` (String): ID du jeu.
  - `musicToken` (String): Token de la musique.
  - `proposition` (String): Proposition du joueur.
  - `type` (String): Type de réponse.
  - `date` (String): Date de la réponse.
- **Retourne**: `Future<GameResponse>` - Un objet réponse de jeu.
- **Exceptions**: `Exception` si la réponse du joueur ne peut pas être soumise.

```dart
Future<GameResponse> postPlayerResponse({
  required String gameId,
  required String musicToken,
  required String proposition,
  required String type,
  required String date,
}) async;
```

Cette documentation couvre toutes les méthodes disponibles dans vos services Dart pour l'application.
