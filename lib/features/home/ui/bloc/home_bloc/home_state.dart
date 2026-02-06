part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class SellerCreatedSuccessfully extends HomeState {
  final String message;

  const SellerCreatedSuccessfully(this.message);

  @override
  List<Object> get props => [message];
}

class SellerStatusUpdatedSuccessfully extends HomeState {
  final String message;

  const SellerStatusUpdatedSuccessfully(this.message);

  @override
  List<Object> get props => [message];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class SellersLoaded extends HomeState {
  final List<SellerListItem> sellers;

  const SellersLoaded(this.sellers);

  @override
  List<Object> get props => [sellers];
}
