class Grade {
  Map<String, String> raw;

  Grade(this.raw);

  Grade.fromJson(Map<String, dynamic> json) {
    raw = Map<String, String>.from(json);
  }

  Map<String, dynamic> toJson() {
    return raw;
  }

  @override
  String toString() {
    return 'Grade${toJson()}';
  }
}
