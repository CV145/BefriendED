import 'package:befriended_flutter/app/buddy_request/cubit/request_buddy.dart';
import 'package:befriended_flutter/app/support/cubit/request.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:befriended_flutter/local_storage/local_storage.dart';
import 'package:befriended_flutter/models/user_chat.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer';

part 'state.dart';

class RequestBuddyCubit extends Cubit<RequestBuddyState> {
  RequestBuddyCubit() : super(const RequestBuddyState());

  void requestDescChanged(String requestDesc) =>
      emit(state.copyWith(requestDesc: requestDesc.trim()));

  void requestEDTypeChanged(EDType eDType) =>
      emit(state.copyWith(requestEdType: eDType));

  void submitBuddyRequest() {
    FirebaseProvider().saveBuddyRequest(state.requestDesc, state.requestEdType);
  }

  void getBuddyRequest() {
    FirebaseProvider().getBuddyRequest().listen((requestData) {
      inspect(requestData);
      emit(
        state.copyWith(
          requestData: requestData,
        ),
      );
      emit(state.copyWith(requestDesc: requestData.description));
      emit(state.copyWith(requestEdType: requestData.eDType));
    });
  }

  // void getCountryList(String data) {
  //   final countryList = parseJson(data);
  //   if (countryList.isNotEmpty) {
  //     emit(
  //       RequestBuddyState(
  //         countryList: countryList,
  //         selectedCountryData: countryList[0],
  //       ),
  //     );
  //   }
  // }
}
