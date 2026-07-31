import 'package:equatable/equatable.dart';

import 'enums.dart';

/// A bookmark a user has placed on a talent, casting or agency.
class FavoriteModel extends Equatable {
  final String id;
  final String userId;
  final String itemId;
  final FavoriteItemType itemType;
  final DateTime createdAt;

  const FavoriteModel({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.createdAt,
  });

  FavoriteModel copyWith({
    String? id,
    String? userId,
    String? itemId,
    FavoriteItemType? itemType,
    DateTime? createdAt,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      itemType: itemType ?? this.itemType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, itemId, itemType, createdAt];
}
