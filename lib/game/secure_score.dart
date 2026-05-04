/// A simple tamper-resistant score wrapper.
/// The value is stored with a shadow copy; if they diverge the game
/// treats it as cheating and resets to 0.
class SecureScore {
  int _value = 0;
  int _shadow = 0;

  int get value {
    if (_value != _shadow) {
      // Tampering detected – reset silently.
      _value = 0;
      _shadow = 0;
    }
    return _value;
  }

  void add(int points) {
    _value += points;
    _shadow += points;
  }

  void reset() {
    _value = 0;
    _shadow = 0;
  }
}
