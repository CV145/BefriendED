part of 'availability_schedule_cubit.dart';

const List<List<int>> _initGridState = [
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
];

class AvialabiliyScheduleState extends Equatable {
  const AvialabiliyScheduleState({
    this.timezoneList,
    this.selectedTimezoneData,
    this.timeMatrix = _initGridState,
  });

  final List<TimezoneModel>? timezoneList;
  final TimezoneModel? selectedTimezoneData;
  final List<List<int>> timeMatrix;

  AvialabiliyScheduleState copyWith({
    List<TimezoneModel>? timezoneList,
    TimezoneModel? selectedTimezoneData,
    List<List<int>>? timeMatrix,
  }) {
    return AvialabiliyScheduleState(
      timezoneList: timezoneList ?? this.timezoneList,
      selectedTimezoneData: selectedTimezoneData ?? this.selectedTimezoneData,
      timeMatrix: timeMatrix ?? this.timeMatrix,
    );
  }

  @override
  List<Object?> get props => [timezoneList, selectedTimezoneData, timeMatrix];
}
