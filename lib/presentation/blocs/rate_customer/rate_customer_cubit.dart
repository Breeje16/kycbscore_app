import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traveller_ratings/data/models/customer.dart';
import 'package:traveller_ratings/data/repositories/auth_repo.dart';

part 'rate_customer_state.dart';

class RateCustomerCubit extends Cubit<RateCustomerState> {
  RateCustomerCubit() : super(RateCustomerInitial());

  Future<void> postCustomerData(Customer data) async {
    emit(RateCustomerLoading());

    final response = await AuthRepo.postCustomerData(data);

    emit(RateCustomerLoaded(response));
  }
}
