part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class CreateSellerRequested extends HomeEvent {
  final String username;
  final String email;
  final String password;
  final int createdByAdminId;

  const CreateSellerRequested({
    required this.username,
    required this.email,
    required this.password,
    required this.createdByAdminId,
  });

  @override
  List<Object> get props => [username, email, password, createdByAdminId];
}

class ClearSellerForm extends HomeEvent {}

class LoadSellersList extends HomeEvent {
  final int adminId;

  const LoadSellersList(this.adminId);

  @override
  List<Object> get props => [adminId];
}

class ToggleSellerDeactivated extends HomeEvent {
  final int adminId;
  final int sellerId;
  final bool isDeactivated;

  const ToggleSellerDeactivated({
    required this.adminId,
    required this.sellerId,
    required this.isDeactivated,
  });

  @override
  List<Object> get props => [adminId, sellerId, isDeactivated];
}
