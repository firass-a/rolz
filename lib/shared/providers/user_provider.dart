/// Riverpod state for the base [UserModel] accounts — the admin-facing
/// "all users" source of truth. Talent/recruiter profiles carry their own
/// denormalised copies of name/email for display, but [UserStatus] (active,
/// banned, suspended…) and account-level `isVerified` only live here.
library;

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';
import '../models/models.dart';

class UserNotifier extends Notifier<List<UserModel>> {
  @override
  List<UserModel> build() {
    MockData.init();
    return List<UserModel>.from(MockData.users);
  }

  UserModel? getById(String id) => state.firstWhereOrNull((u) => u.id == id);

  void create(UserModel user) {
    state = [user, ...state];
  }

  void update(UserModel user) {
    state = [
      for (final u in state) if (u.id == user.id) user else u,
    ];
  }

  void delete(String id) {
    state = state.where((u) => u.id != id).toList();
  }

  void setStatus(String id, UserStatus status) {
    state = [
      for (final u in state) if (u.id == id) u.copyWith(status: status) else u,
    ];
  }

  void setVerified(String id, bool verified) {
    state = [
      for (final u in state) if (u.id == id) u.copyWith(isVerified: verified) else u,
    ];
  }

  void ban(String id) => setStatus(id, UserStatus.banned);

  void unban(String id) => setStatus(id, UserStatus.active);
}

final userProvider = NotifierProvider<UserNotifier, List<UserModel>>(UserNotifier.new);

final userByIdProvider = Provider.family<UserModel?, String>((ref, id) {
  return ref.watch(userProvider).firstWhereOrNull((u) => u.id == id);
});

final usersByRoleProvider = Provider.family<List<UserModel>, UserRole>((ref, role) {
  return ref.watch(userProvider).where((u) => u.role == role).toList();
});
