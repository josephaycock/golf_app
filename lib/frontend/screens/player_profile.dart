// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../backend/services/firebase.dart';
// import '../../backend/services/models/player_stats.dart';

// class PlayerProfile extends StatefulWidget {
//   const PlayerProfile({Key? key}) : super(key: key);

//   @override
//   _PlayerProfileState createState() => _PlayerProfileState();
// }

// class _PlayerProfileState extends State<PlayerProfile> {
//   final FirebaseService _firebaseService = FirebaseService();
//   late String _userId;
//   PlayerStats _playerStats = PlayerStats();

//   @override
//   void initState() {
//     super.initState();
//     _userId = FirebaseAuth.instance.currentUser!.uid;
//     _loadStats();
//   }

//   Future<void> _loadStats() async {
//     var data = await _firebaseService.getPlayerStats(_userId);
//     if (data != null) {
//       setState(() {
//         _playerStats = PlayerStats.fromJson(data);
//       });
//     }
//   }

//   Future<void> _saveStats() async {
//     await _firebaseService.savePlayerStats(_userId, _playerStats.toJson());
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Stats Saved!')),
//     );
//   }

//   void _increment(String stat) {
//     setState(() {
//       switch (stat) {
//         case 'gamesPlayed':
//           _playerStats.gamesPlayed++;
//           break;
//         case 'totalStrokes':
//           _playerStats.totalStrokes++;
//           break;
//         case 'birdies':
//           _playerStats.birdies++;
//           break;
//         case 'pars':
//           _playerStats.pars++;
//           break;
//         case 'bogeys':
//           _playerStats.bogeys++;
//           break;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Player Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             StatRow(title: 'Games Played', value: _playerStats.gamesPlayed, onTap: () => _increment('gamesPlayed')),
//             StatRow(title: 'Total Strokes', value: _playerStats.totalStrokes, onTap: () => _increment('totalStrokes')),
//             StatRow(title: 'Birdies', value: _playerStats.birdies, onTap: () => _increment('birdies')),
//             StatRow(title: 'Pars', value: _playerStats.pars, onTap: () => _increment('pars')),
//             StatRow(title: 'Bogeys', value: _playerStats.bogeys, onTap: () => _increment('bogeys')),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _saveStats,
//               child: const Text('Save Stats'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class StatRow extends StatelessWidget {
//   final String title;
//   final int value;
//   final VoidCallback onTap;

//   const StatRow({
//     Key? key,
//     required this.title,
//     required this.value,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(title),
//       trailing: Text(value.toString()),
//       onTap: onTap,
//     );
//   }
// }
