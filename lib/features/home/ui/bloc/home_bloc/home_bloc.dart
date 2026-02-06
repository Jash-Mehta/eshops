import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../auth/data/repositories/auth_repository.dart';
import '../../../data/models/seller_list_item_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthRepository _authRepository;

  HomeBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(HomeInitial()) {
    on<CreateSellerRequested>(_onCreateSellerRequested);
    on<ClearSellerForm>(_onClearSellerForm);
    on<LoadSellersList>(_onLoadSellersList);
    on<ToggleSellerDeactivated>(_onToggleSellerDeactivated);
  }

  Future<void> _onCreateSellerRequested(
    CreateSellerRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final user = await _authRepository.register(
        username: event.username,
        email: event.email,
        password: event.password,
        isAdmin: 0, // Seller flag
        createdByAdminId: event.createdByAdminId,
      );

      if (user != null) {
        emit(SellerCreatedSuccessfully('Seller account created successfully!'));
      } else {
        emit(const HomeError('Failed to create seller account'));
      }
    } catch (e) {
      emit(HomeError('Failed to create seller: ${e.toString()}'));
    }
  }

  Future<void> _onClearSellerForm(
    ClearSellerForm event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeInitial());
  }

  Future<void> _onLoadSellersList(
    LoadSellersList event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final users = await _authRepository.getSellersCreatedByAdminId(event.adminId);
      final sellers = users
          .where((user) => user.isSeller)
          .map(SellerListItem.fromUser)
          .toList();
      
      emit(SellersLoaded(sellers));
    } catch (e) {
      emit(HomeError('Failed to load sellers: ${e.toString()}'));
    }
  }

  Future<void> _onToggleSellerDeactivated(
    ToggleSellerDeactivated event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      await _authRepository.setSellerDeactivated(
        sellerId: event.sellerId,
        isDeactivated: event.isDeactivated,
      );

      emit(
        SellerStatusUpdatedSuccessfully(
          event.isDeactivated ? 'Seller deactivated' : 'Seller activated',
        ),
      );

      final users = await _authRepository.getSellersCreatedByAdminId(event.adminId);
      final sellers = users
          .where((user) => user.isSeller)
          .map(SellerListItem.fromUser)
          .toList();

      emit(SellersLoaded(sellers));
    } catch (e) {
      emit(HomeError('Failed to update seller: ${e.toString()}'));
    }
  }
}
