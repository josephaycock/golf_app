class PlayerStats {
  int gamesPlayed;
  int totalStrokes;
  int birdies;
  int pars;
  int bogeys;

  PlayerStats({
    this.gamesPlayed = 0,
    this.totalStrokes = 0,
    this.birdies = 0,
    this.pars = 0,
    this.bogeys = 0,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      gamesPlayed: json['gamesPlayed'] ?? 0,
      totalStrokes: json['totalStrokes'] ?? 0,
      birdies: json['birdies'] ?? 0,
      pars: json['pars'] ?? 0,
      bogeys: json['bogeys'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gamesPlayed': gamesPlayed,
      'totalStrokes': totalStrokes,
      'birdies': birdies,
      'pars': pars,
      'bogeys': bogeys,
    };
  }
}
