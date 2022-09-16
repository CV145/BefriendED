part of 'country_picker_cubit.dart';

class CountryPickerState extends Equatable {
  const CountryPickerState({this.countryList, this.selectedCountryData});

  final List<CountryModel>? countryList;
  final CountryModel? selectedCountryData;

  CountryPickerState copyWith({
    List<CountryModel>? countryList,
    CountryModel? selectedCountryData,
  }) {
    return CountryPickerState(
      countryList: countryList ?? this.countryList,
      selectedCountryData: selectedCountryData ?? this.selectedCountryData,
    );
  }

  @override
  List<Object?> get props => [countryList, selectedCountryData];
}
