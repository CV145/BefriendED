import 'package:befriended_flutter/local_storage/local_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.localStorage}) : super(const LoginState());

  final LocalStorage localStorage;

  void pinChanged(String pin) => emit(state.copyWith(pin: pin));

  void verificationIdChanged(String verificationId) {
    emit(state.copyWith(verificationId: verificationId));
  }

  // void getPhoneNumber() {
  //   emit(state.copyWith(phoneNumberStatus: PhoneNumberStatus.loading));
  //   emit(
  //     state.copyWith(
  //       phoneNumber: localStorage.getPhoneNumber() ?? '',
  //       countryCode: localStorage.getCountryCode() ?? '',
  //       phoneNumberStatus: PhoneNumberStatus.success,
  //     ),
  //   );
  // }
  // void getCountryList(String data) {
  //   final countryList = parseJson(data);
  //   if (countryList.isNotEmpty) {
  //     emit(
  //       LoginState(
  //         countryList: countryList,
  //         selectedCountryData: countryList[0],
  //       ),
  //     );
  //   }
  // }
}
