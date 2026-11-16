/// Pure domain entity representing a category.
class CategoryEntity {
  final String id;
  final String name;
  final String? description;
  final String icon;
  final bool isDefault;
  final DateTime createdAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    this.isDefault = false,
    required this.createdAt,
  });
}

