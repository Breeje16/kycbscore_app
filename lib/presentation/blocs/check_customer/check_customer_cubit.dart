import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traveller_ratings/data/models/customer.dart';
import 'package:traveller_ratings/data/repositories/auth_repo.dart';

part 'check_customer_state.dart';

class CheckCustomerCubit extends Cubit<CheckCustomerState> {
  CheckCustomerCubit() : super(CheckCustomerInitial());

  Future<void> getCustomerData(Map query) async {
    emit(CheckCustomerLoading());

    final response = await AuthRepo.getCustomerData(query);
    Customer customerData = Customer.fromMap(response);
    emit(CheckCustomerLoaded(customerData));
  }
}
