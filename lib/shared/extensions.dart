extension IntegerDurationExtension on int {
  Duration get ms => Duration(milliseconds: this);
  Duration get s => Duration(seconds: this);
  Duration get m => Duration(minutes: this);
  Duration get h => Duration(hours: this);
  Duration get d => Duration(days: this);
}

extension ListExtension<T> on List<T> {
  /// Returns the element at the specified [index] that "wraps" around the list like a cycle.
  /// For example, if the list has 3 elements, then `list.cyclicAt(3)` is equivalent to `list[0]`.
  /// This also handles negative indices, so `list.cyclicAt(-1)` is equivalent to `list[2]`.
  /// If the list is empty, then this will throw an [ArgumentError].
  T cyclicAt(int index) => length > 0 ? this[index % length] : throw ArgumentError("Tried indexing an empty list");
}
