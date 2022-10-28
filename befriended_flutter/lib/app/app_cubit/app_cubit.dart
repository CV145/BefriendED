import 'package:befriended_flutter/local_storage/local_storage.dart';
import 'package:befriended_flutter/models/user_chat.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required this.localStorage}) : super(const AppState());

  final LocalStorage localStorage;

  void nameChanged(String name) => emit(state.copyWith(name: name.trim()));

  //Emit or "update" to new state = to copy of current state with
  //the new email, trimmed for whitespace
  void emailChanged(String givenEmail)
  => emit(state.copyWith(userEmail: givenEmail.trim()));

  void saveName() {
    localStorage.setName(state.name);
  }

  void getName() {
    emit(state.copyWith(nameStatus: NameStatus.loading));
    emit(
      state.copyWith(
        name: localStorage.getName() ?? '',
        nameStatus: NameStatus.success,
      ),
    );
  }

  void phoneNumberChanged(String phoneNumber) =>
      emit(state.copyWith(phoneNumber: phoneNumber));

  void savePhoneNumber() {
    localStorage.setPhoneNumber(state.phoneNumber, state.countryCode);
  }

  void countryCodeChanged(String countryCode) =>
      emit(state.copyWith(countryCode: countryCode));

  void getPhoneNumber() {
    emit(state.copyWith(phoneNumberStatus: PhoneNumberStatus.loading));
    emit(
      state.copyWith(
        phoneNumber: localStorage.getPhoneNumber() ?? '',
        countryCode: localStorage.getCountryCode() ?? '',
        phoneNumberStatus: PhoneNumberStatus.success,
      ),
    );
  }

  void updateLocalUser(UserChat user) {
    localStorage
      ..setName(user.name)
      ..setPhoneNumber(user.phoneNumber, user.countryCode);
    emit(
      state.copyWith(
        phoneNumberStatus: PhoneNumberStatus.loading,
        nameStatus: NameStatus.loading,
      ),
    );
    emit(
      state.copyWith(
        name: user.name,
        phoneNumber: user.phoneNumber,
        countryCode: user.countryCode,
        phoneNumberStatus: PhoneNumberStatus.success,
        nameStatus: NameStatus.success,
        isLoggedIn: true,
      ),
    );
  }

  void clearLocalUser() {
    localStorage
      ..setName('')
      ..setPhoneNumber('', '');
    emit(
      state.copyWith(
        name: '',
        phoneNumber: '',
        countryCode: '',
        phoneNumberStatus: PhoneNumberStatus.initial,
        nameStatus: NameStatus.initial,
        isLoggedIn: false,
      ),
    );
  }

  void checkLogIn({required bool preValidation}) {
    emit(
      state.copyWith(
        isLoggedIn: preValidation &&
            (localStorage.getPhoneNumber()?.isNotEmpty ?? false),
      ),
    );
  }

  // void getCountryList(String data) {
  //   final countryList = parseJson(data);
  //   if (countryList.isNotEmpty) {
  //     emit(
  //       AppState(
  //         countryList: countryList,
  //         selectedCountryData: countryList[0],
  //       ),
  //     );
  //   }
  // }
}
