import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/country_picker/country.dart';
import 'package:befriended_flutter/app/country_picker/cubit/country_picker_cubit.dart';
import 'package:befriended_flutter/app/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CountryPickerWidget extends StatelessWidget {
  const CountryPickerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CountryPickerCubit(),
      child: CountryPicker(),
    );
  }
}

// ignore: must_be_immutable
class CountryPicker extends StatefulWidget {
  const CountryPicker({Key? key}) : super(key: key);

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

// Country picker state class
class _CountryPickerState extends State<CountryPicker> {
  // late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DefaultAssetBundle.of(context)
          .loadString('assets/countrycodes.json')
          .then(
            (value) => context.read<CountryPickerCubit>().getCountryList(value),
          );
    });
    // BottomSheet.createAnimationController(this);
    // _controller.duration = Duration(seconds: 2);
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 2),
    //   reverseDuration: Duration(milliseconds: 300),
    //   animationBehavior: AnimationBehavior.preserve,
    // );
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  //build method for UI render
  @override
  Widget build(BuildContext context) {
    // return Container();
    return BlocListener<CountryPickerCubit, CountryPickerState>(
      listener: (context, state) {
        if (state.countryList?.isNotEmpty ?? false) {
          final countryCode = context.read<AppCubit>().state.countryCode;
          if (countryCode.isEmpty) {
           /* context
                .read<AppCubit>()
                .countryCodeChanged(state.countryList![0].dialCode);*/
          }
        }
      },
      child: BlocBuilder<CountryPickerCubit, CountryPickerState>(
        builder: (context, state) {
          return BlocBuilder<AppCubit, AppState>(
            builder: (context, appState) {
              if (appState.countryCode.isNotEmpty) {
                return SizedBox(
                  child: GestureDetector(
                    onTap: () {
                      CupertinoScaffold.showCupertinoModalBottomSheet<
                          CountryModel>(
                        context: context,
                        builder: (context) {
                          return CustomDialog(
                            searchList: state.countryList ?? [],
                          );
                        },
                        duration: Duration(milliseconds: 500),
                      ).then((selectedCountry) {
                        if (selectedCountry != null) {
                         /* context
                              .read<CountryPickerCubit>()
                              .selectedCountryDataChanged(selectedCountry);
                          context
                              .read<AppCubit>()
                              .countryCodeChanged(selectedCountry.dialCode);*/
                        }
                      });
                      // showModalBottomSheet<CountryModel>(
                      //   context: context,
                      //   isScrollControlled: true,
                      //   backgroundColor: Colors.transparent,
                      //   transitionAnimationController: _controller,
                      //   builder: (context) {
                      //     return CustomDialog(
                      //       searchList: state.countryList ?? [],
                      //     );
                      //   },
                      //   enableDrag: false,
                      // ).then((selectedCountry) {
                      //   if (selectedCountry != null) {
                      //     context
                      //         .read<CountryPickerCubit>()
                      //         .selectedCountryDataChanged(selectedCountry);
                      //     context
                      //         .read<AppCubit>()
                      //         .countryCodeChanged(selectedCountry.dialCode);
                      //   }
                      // });
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 25, left: 20, bottom: 25),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.04),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            state.selectedCountryData?.flag ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6, bottom: 2),
                            child: Text(
                              appState.countryCode,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

// show country picker dialogue
  // Future<void> showDialogue(BuildContext context) async {
  //   final countryData = await ;
  // }
}

// Custom stateful widget dialogue

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    required this.searchList,
  }) : super(key: key);

  final List<CountryModel> searchList;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

// dialogue state class
class _CustomDialogState extends State<CustomDialog> {
  List<CountryModel> tmpList = [];

  // initiation of state
  @override
  void initState() {
    super.initState();
    tmpList = widget.searchList;
  }

  // build method
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              label: 'Search Country',
              prefixIcon: Icon(
                Icons.search,
                size: 25,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              onChanged: filterData,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.70 - 108,
              child: ListView.builder(
                shrinkWrap: true,
                controller: ModalScrollController.of(context),
                physics: ClampingScrollPhysics(),
                itemCount: tmpList.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context, tmpList[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            tmpList[index].flag,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text(
                            tmpList[index].name,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          tmpList[index].dialCode,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                // children: [
                //   // ignore: sdk_version_ui_as_code
                //   ...tmpList.map(
                //     (item) => GestureDetector(
                //       onTap: () {
                //         Navigator.pop(context, item);
                //       },
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 16,
                //           vertical: 20,
                //         ),
                //         child: Row(
                //           // ignore: prefer_const_literals_to_create_immutables
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Padding(
                //               padding: EdgeInsets.only(top: 5),
                //               child: Text(
                //                 item.flag,
                //                 style: const TextStyle(fontSize: 16),
                //               ),
                //             ),
                //             const SizedBox(
                //               width: 12,
                //             ),
                //             Expanded(
                //               child: Text(
                //                 item.name,
                //                 style:
                //                     Theme.of(context).textTheme.displayMedium,
                //               ),
                //             ),
                //             const SizedBox(
                //               width: 12,
                //             ),
                //             Text(
                //               item.dialCode,
                //               style: Theme.of(context).textTheme.displayMedium,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // fliter data on search bar text change
  void filterData(String text) {
    tmpList = [];
    if (text == '') {
      tmpList.addAll(widget.searchList);
    } else {
      // ignore: avoid_function_literals_in_foreach_calls
      widget.searchList.forEach((userDetail) {
        // ignore: always_put_control_body_on_new_line
        if (userDetail.name.toLowerCase().contains(text.toLowerCase())) {
          tmpList.add(userDetail);
        }
      });
    }
    setState(() {});
  }
}

// parse json data into model
// List<CountryModel> parseJson(String response) {
//   final iterable = jsonDecode(response) as Iterable<Map<String, dynamic>>;
//   return iterable.map<CountryModel>(CountryModel.fromJson).toList();
// }
