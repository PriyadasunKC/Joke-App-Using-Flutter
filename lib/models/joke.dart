
class Joke {
  final String category;
  final String type;
  final String setup;
  final String delivery;
  final String joke;

  Joke({
    required this.category,
    required this.type,
    this.setup = '',
    this.delivery = '',
    this.joke = '',
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      category: json['category'] ?? '',
      type: json['type'] ?? '',
      setup: json['setup'] ?? '',
      delivery: json['delivery'] ?? '',
      joke: json['joke'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'type': type,
      'setup': setup,
      'delivery': delivery,
      'joke': joke,
    };
  }

  bool get isTwoPart => type == 'twopart';
}
