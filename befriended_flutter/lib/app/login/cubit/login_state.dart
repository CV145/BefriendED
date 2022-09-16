part of 'login_cubit.dart';

// enum PhoneNumberStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.pin = '',
    this.verificationId = '',
    // this.phoneNumberStatus = PhoneNumberStatus.initial,
  });

  final String pin;
  final String verificationId;
  // final PhoneNumberStatus phoneNumberStatus;

  LoginState copyWith({
    String? pin,
    String? verificationId,
    // PhoneNumberStatus? phoneNumberStatus,
  }) {
    return LoginState(
      pin: pin ?? this.pin,
      verificationId: verificationId ?? this.verificationId,
      // phoneNumberStatus: phoneNumberStatus ?? this.phoneNumberStatus,
    );
  }

  @override
  List<Object?> get props => [pin, verificationId];
}
