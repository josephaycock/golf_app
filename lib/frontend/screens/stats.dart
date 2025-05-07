import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../backend/services/firebase.dart';
import '../../backend/services/models/player_stats.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  PlayerStats _playerStats = PlayerStats();
  late String? _userId;
  bool _statsChanged = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    if (_userId != null) {
      _loadStats();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      _isLoading = false;
    }
  }

  Future<void> _loadStats() async {
    try {
      var data = await _firebaseService.getPlayerStats(_userId!);
      if (data != null) {
        _playerStats = PlayerStats.fromJson(data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No stats found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load stats: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveStats() async {
    if (!_statsChanged) return;

    try {
      await _firebaseService.savePlayerStats(_userId!, _playerStats.toJson());
      setState(() => _statsChanged = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stats Saved!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save stats: $e')),
      );
    }
  }

  void _updateStat(String stat, {bool increment = true}) {
    setState(() {
      switch (stat) {
        case 'gamesPlayed':
          _playerStats.gamesPlayed += increment ? 1 : -1;
          break;
        case 'totalStrokes':
          _playerStats.totalStrokes += increment ? 1 : -1;
          break;
        case 'birdies':
          _playerStats.birdies += increment ? 1 : -1;
          break;
        case 'pars':
          _playerStats.pars += increment ? 1 : -1;
          break;
        case 'bogeys':
          _playerStats.bogeys += increment ? 1 : -1;
          break;
      }
      _statsChanged = true;
    });
  }

  Future<bool> _confirmDiscardChanges() async {
    if (!_statsChanged) return true;
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text('You have unsaved changes. Do you want to discard them?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Discard'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmDiscardChanges,
      child: Scaffold(
        appBar: AppBar(title: const Text('Player Stats',
            style: TextStyle(
              color: Colors.white,
            )),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          automaticallyImplyLeading: false,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    StatRow(
                      title: 'Games Played',
                      value: _playerStats.gamesPlayed,
                      onIncrement: () => _updateStat('gamesPlayed'),
                      onDecrement: () => _updateStat('gamesPlayed', increment: false),
                    ),
                    StatRow(
                      title: 'Total Strokes',
                      value: _playerStats.totalStrokes,
                      onIncrement: () => _updateStat('totalStrokes'),
                      onDecrement: () => _updateStat('totalStrokes', increment: false),
                    ),
                    StatRow(
                      title: 'Birdies',
                      value: _playerStats.birdies,
                      onIncrement: () => _updateStat('birdies'),
                      onDecrement: () => _updateStat('birdies', increment: false),
                    ),
                    StatRow(
                      title: 'Pars',
                      value: _playerStats.pars,
                      onIncrement: () => _updateStat('pars'),
                      onDecrement: () => _updateStat('pars', increment: false),
                    ),
                    StatRow(
                      title: 'Bogeys',
                      value: _playerStats.bogeys,
                      onIncrement: () => _updateStat('bogeys'),
                      onDecrement: () => _updateStat('bogeys', increment: false),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _saveStats,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Stats'),
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _playerStats = PlayerStats(); // Assumes default constructor will reset all
                          _statsChanged = true;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Stats'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 250, 117, 117),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const StatRow({
    Key? key,
    required this.title,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: value > 0 ? onDecrement : null,
            ),
            Text('$value', style: const TextStyle(fontSize: 18)),
            IconButton(icon: const Icon(Icons.add), onPressed: onIncrement),
          ],
        ),
      ),
    );
  }
}
