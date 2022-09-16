import 'package:befriended_flutter/app/support/cubit/request.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:befriended_flutter/local_storage/local_storage.dart';
import 'package:befriended_flutter/models/user_chat.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer';

part 'state.dart';

class SupportCubit extends Cubit<SupportState> {
  SupportCubit() : super(const SupportState());

  void requestDescChanged(String requestDesc) =>
      emit(state.copyWith(requestDesc: requestDesc.trim()));

  void submitRequest() {
    FirebaseProvider().saveToBeBuddyRequest(state.requestDesc);
  }

  void getRequest() {
    FirebaseProvider().getRequest().listen((requestData) {
      inspect(requestData);
      emit(
        state.copyWith(
          requestData: requestData,
        ),
      );
      emit(state.copyWith(requestDesc: requestData.description));
    });
  }

  // void getCountryList(String data) {
  //   final countryList = parseJson(data);
  //   if (countryList.isNotEmpty) {
  //     emit(
  //       SupportState(
  //         countryList: countryList,
  //         selectedCountryData: countryList[0],
  //       ),
  //     );
  //   }
  // }
}
