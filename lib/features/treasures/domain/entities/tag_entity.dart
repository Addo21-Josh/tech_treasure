/// Pure domain entity representing a cross-cutting tag.
class TagEntity {
  final String id;
  final String name;
  final DateTime createdAt;

  const TagEntity({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  /// Normalizes tag formatting (e.g. ensures '#android' format without spaces).
  static String normalize(String input) {
    var tag = input.trim().toLowerCase();
    if (!tag.startsWith('#')) {
      tag = '#$tag';
    }
    return tag.replaceAll(RegExp(r'\s+'), '_');
  }
}
