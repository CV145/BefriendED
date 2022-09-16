import 'dart:convert';

import 'package:befriended_flutter/app/availability_schedule/cubit/timezone.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:befriended_flutter/firebase/firestore_constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'availability_schedule_state.dart';

class AvialabiliyScheduleCubit extends Cubit<AvialabiliyScheduleState> {
  AvialabiliyScheduleCubit() : super(const AvialabiliyScheduleState());

  void selectedTimezoneDataChanged(TimezoneModel timezone) =>
      emit(state.copyWith(selectedTimezoneData: timezone));

  void getTimezoneList(String data) {
    if (state.timezoneList?.isEmpty ?? true) {
      final timezoneList = parseJson(data);
      if (timezoneList.isNotEmpty) {
        emit(
          state.copyWith(
            timezoneList: timezoneList,
            selectedTimezoneData: timezoneList[0],
          ),
        );
      }
    }
    getAvailability();
  }

  void getAvailability() {
    // TODO handle error status
    // TODO try and optimize this call
    FirebaseProvider().getAvailability().then((value) {
      print(value);
      if (value != null) {
        emit(
          state.copyWith(
            selectedTimezoneData:
                value[FirestoreConstants.timezone] as TimezoneModel,
            timeMatrix: value[FirestoreConstants.timematrix] as List<List<int>>,
          ),
        );
      }
    });
  }

  void saveAvailability() {
    // TODO handle error status
    FirebaseProvider()
        .saveAvailability(state.selectedTimezoneData!, state.timeMatrix);
  }

  void timeMatrixChanged(int x, int y, int value) {
    if (state.timeMatrix[x][y] != value) {
      final timeMatrix = state.timeMatrix.map<List<int>>(List.from).toList();

      timeMatrix[x][y] = value;
      print(timeMatrix);
      emit(state.copyWith(timeMatrix: timeMatrix));
    }
  }

  List<TimezoneModel> parseJson(String response) {
    final iterable = jsonDecode(response) as List<dynamic>;
    return iterable
        .map<TimezoneModel>(
          (dynamic json) =>
              TimezoneModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
