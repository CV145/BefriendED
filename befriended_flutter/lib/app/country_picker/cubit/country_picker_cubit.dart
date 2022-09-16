import 'dart:convert';

import 'package:befriended_flutter/app/country_picker/country.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'country_picker_state.dart';

class CountryPickerCubit extends Cubit<CountryPickerState> {
  CountryPickerCubit() : super(const CountryPickerState());

  void selectedCountryDataChanged(CountryModel country) =>
      emit(state.copyWith(selectedCountryData: country));

  void getCountryList(String data) {
    final countryList = parseJson(data);
    if (countryList.isNotEmpty) {
      emit(
        state.copyWith(
          countryList: countryList,
          selectedCountryData: countryList[0],
        ),
      );
    }
  }

  List<CountryModel> parseJson(String response) {
    final iterable = jsonDecode(response) as List<dynamic>;
    return iterable
        .map<CountryModel>(
          (dynamic json) => CountryModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
