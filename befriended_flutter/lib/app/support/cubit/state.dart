part of 'cubit.dart';

enum SupportRequestStatus { initial, loading, success, failure }

class SupportState extends Equatable {
  const SupportState({
    this.requestDesc = '',
    this.supportRequestStatus = SupportRequestStatus.initial,
    this.requestData,
  });

  final String requestDesc;
  final SupportRequestStatus supportRequestStatus;
  final RequestModel? requestData;

  SupportState copyWith({
    String? requestDesc,
    SupportRequestStatus? supportRequestStatus,
    RequestModel? requestData,
  }) {
    return SupportState(
      requestDesc: requestDesc ?? this.requestDesc,
      supportRequestStatus: supportRequestStatus ?? this.supportRequestStatus,
      requestData: requestData ?? this.requestData,
    );
  }

  @override
  List<Object?> get props => [
        requestDesc,
        supportRequestStatus,
        requestData,
      ];
}
