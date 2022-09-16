part of 'cubit.dart';

enum RequestBuddyStatus { initial, loading, success, failure }

class RequestBuddyState extends Equatable {
  const RequestBuddyState({
    this.requestDesc = '',
    this.requestEdType = EDType.AnorexiaNervosa,
    this.requestBuddyStatus = RequestBuddyStatus.initial,
    this.requestData,
  });

  final String requestDesc;
  final RequestBuddyStatus requestBuddyStatus;
  final EDType requestEdType;
  final RequestBuddyModel? requestData;

  RequestBuddyState copyWith({
    String? requestDesc,
    RequestBuddyStatus? requestBuddyStatus,
    EDType? requestEdType,
    RequestBuddyModel? requestData,
  }) {
    return RequestBuddyState(
      requestDesc: requestDesc ?? this.requestDesc,
      requestBuddyStatus: requestBuddyStatus ?? this.requestBuddyStatus,
      requestEdType: requestEdType ?? this.requestEdType,
      requestData: requestData ?? this.requestData,
    );
  }

  @override
  List<Object?> get props => [
        requestDesc,
        requestBuddyStatus,
        requestEdType,
        requestData,
      ];
}
