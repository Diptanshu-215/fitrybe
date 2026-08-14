# Fitrybe - Frontend to Backend Integration Documentation

This document provides complete instructions, endpoint mappings, authentication workflows, Socket.io real-time specs, and Dart helper service code to connect the **Flutter Frontend** (`C:\VS_Code\fitrybe`) with the **Node.js / Express / Prisma Backend** (`C:\VS_Code\fitrybe-backend`).

---

## 1. Server Configuration & Base URLs

### Base API Endpoints
- **Android Emulator**: `http://10.0.2.2:4000/api`
- **iOS Simulator / macOS / Windows**: `http://localhost:4000/api`
- **Physical Mobile Device**: `http://<YOUR_LOCAL_IP>:4000/api` (e.g. `http://192.168.1.50:4000/api`)

### Socket.IO URL
- **Android Emulator**: `http://10.0.2.2:4000`
- **iOS / Desktop**: `http://localhost:4000`

---

## 2. Authentication & Authorization Flow

### Headers Required for Authenticated Requests
All protected endpoints require an `Authorization` header containing the JWT Access Token:
```http
Authorization: Bearer <ACCESS_TOKEN>
Content-Type: application/json
```

### Auth Workflow
1. **Register**: `POST /api/auth/register`
   - Body: `{ "email": "user@example.com", "password": "securepassword" }`
   - Response: `{ "user": {...}, "accessToken": "...", "refreshToken": "..." }`
2. **Login**: `POST /api/auth/login`
   - Body: `{ "email": "user@example.com", "password": "securepassword" }`
   - Response: `{ "user": {...}, "accessToken": "...", "refreshToken": "..." }`
3. **Token Refresh**: `POST /api/auth/refresh`
   - Body: `{ "refreshToken": "<REFRESH_TOKEN>" }`
   - Response: `{ "accessToken": "...", "refreshToken": "..." }`

---

## 3. Screen-to-API Mapping Matrix

| Flutter Screen (`lib/screens/`) | HTTP Method & Route | Description / Trigger |
|---|---|---|
| `welcome_screen.dart`, `auth_screens.dart` | `POST /api/auth/login`<br>`POST /api/auth/register` | User authentication & session startup |
| `user_details_screen.dart` | `PATCH /api/users/me` | Onboarding profile setup (gender, DOB, interests, goals) |
| `home_screen.dart` | `GET /api/posts?limit=20` | Feed listing |
| `home_screen.dart` | `POST /api/posts/:id/like` | Like/Unlike post toggle |
| `home_screen.dart` | `GET /api/posts/:id/comments`<br>`POST /api/posts/:id/comments` | Fetch & post comments |
| `create_post_screen.dart` | `POST /api/posts` | Create new post (supports image upload via multipart/form-data) |
| `record_screen.dart`, `record_map_screen.dart` | `POST /api/activities` | Save recorded workout (duration, distance, calories, avgPace, routeData) |
| `activity_analytics_tab.dart` | `GET /api/activities/analytics` | Fetch weekly/monthly summaries, total distance, hours, calories |
| `trybes_tab.dart` | `GET /api/trybes?category=Running` | Discover & filter trybes |
| `create_trybe_screen.dart` | `POST /api/trybes` | Create trybe with cover image upload |
| `trybe_detail_screen.dart` | `GET /api/trybes/:id`<br>`GET /api/trybes/:id/leaderboard`<br>`POST /api/trybes/:id/join` | Trybe details, member leaderboard ranking, join/leave |
| `clique_tab.dart`, `create_clique_activity_screen.dart` | `GET /api/cliques`<br>`POST /api/cliques` | List & host live group workout sessions |
| `clique_live_activity_screen.dart` | `POST /api/cliques/:id/join`<br>`PATCH /api/cliques/:id/status` | Join session, start/complete session |
| `messaging_screen.dart` | `GET /api/chat/conversations`<br>`POST /api/chat/conversations` | Conversation inbox & DM start |
| `chat_detail_screen.dart` | `GET /api/chat/conversations/:id/messages`<br>`POST /api/chat/conversations/:id/messages` | Message history & sending messages |
| `notifications_tab.dart` | `GET /api/notifications`<br>`PATCH /api/notifications/:id/read` | Notifications feed & mark read |
| `profile_tab.dart`, `edit_profile_screen.dart` | `GET /api/users/:id`<br>`PATCH /api/users/me`<br>`POST /api/users/me/avatar` | Profile stats, avatar/banner uploads |
| `customize_goal_screen.dart` | `GET /api/goals`<br>`PUT /api/goals` | Step, distance, and calorie target setup |

---

## 4. Socket.IO Real-Time Integration

### Connection Initialization
Supply the JWT token in `auth` or query parameter during connection:
```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

IO.Socket socket = IO.io('http://10.0.2.2:4000', IO.OptionBuilder()
  .setTransports(['websocket'])
  .setAuth({'token': accessToken})
  .build());

socket.onConnect((_) => print('Connected to Socket.IO backend'));
```

### Real-Time Chat Events
- **Join Room**: `socket.emit('join_conversation', conversationId);`
- **Leave Room**: `socket.emit('leave_conversation', conversationId);`
- **Send Message Event**:
  ```javascript
  socket.emit('chat:send', {
    conversationId: '...',
    text: 'See you at the run!',
  });
  ```
- **Listen for Messages**:
  ```javascript
  socket.on('chat:message', (data) => {
    // data: { senderId, text, conversationId, createdAt }
  });
  ```

### Live Clique Group Activity Telemetry
- **Join Clique Session**: `socket.emit('clique:join', sessionId);`
- **Broadcast Live GPS Telemetry**:
  ```javascript
  socket.emit('clique:telemetry', {
    sessionId: '...',
    lat: 37.7749,
    lng: -122.4194,
    distance: 4250, // meters
    pace: 4.85,    // min/km
    calories: 320
  });
  ```
- **Listen for Participant Telemetry**:
  ```javascript
  socket.on('clique:telemetry_update', (data) => {
    // data: { userId, lat, lng, distance, pace, calories, timestamp }
  });
  ```

---

## 5. Dart API Service Implementation Sample

Save this helper snippet in Flutter `lib/services/api_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:4000/api'; // Android Emulator
  static String? _accessToken;

  static void setAccessToken(String token) {
    _accessToken = token;
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  // Auth Methods
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _accessToken = data['accessToken'];
    }
    return data;
  }

  // Fetch Feed
  static Future<List<dynamic>> getFeed() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'), headers: _headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['posts'];
    }
    throw Exception('Failed to load feed');
  }

  // Save Workout Activity
  static Future<Map<String, dynamic>> logActivity({
    required String title,
    required String type,
    required int duration,
    required double distance,
    required int calories,
    List<Map<String, double>>? routeData,
    bool createPost = true,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/activities'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'type': type,
        'duration': duration,
        'distance': distance,
        'calories': calories,
        'routeData': routeData,
        'createPost': createPost,
      }),
    );
    return jsonEncode(response.body);
  }

  // Get Analytics Summary
  static Future<Map<String, dynamic>> getAnalytics() async {
    final response = await http.get(Uri.parse('$baseUrl/activities/analytics'), headers: _headers);
    return jsonDecode(response.body);
  }
}
```
