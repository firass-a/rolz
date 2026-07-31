import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// A user's saved search/filter combination (e.g. "Actresses in Algiers,
/// 18-25") that can be re-applied later or turned into an alert.
class SavedSearchModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final Map<String, dynamic> filters;
  final DateTime createdAt;

  const SavedSearchModel({
    required this.id,
    required this.userId,
    required this.name,
    this.filters = const {},
    required this.createdAt,
  });

  SavedSearchModel copyWith({
    String? id,
    String? userId,
    String? name,
    Map<String, dynamic>? filters,
    DateTime? createdAt,
  }) {
    return SavedSearchModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      filters: filters ?? this.filters,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        // Use a deep-equality wrapper so two searches with the same filter
        // contents compare equal even if the underlying Map instances differ.
        const DeepCollectionEquality().hash(filters),
        createdAt,
      ];
}
