import 'package:befriended_flutter/animations/fade_animation.dart';
import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/availability_schedule/cubit/availability_schedule_cubit.dart';
import 'package:befriended_flutter/app/availability_schedule/cubit/timezone.dart';
import 'package:befriended_flutter/app/availability_schedule/view/schedule_selectoion.dart';
import 'package:befriended_flutter/app/home/home.dart';
import 'package:befriended_flutter/app/launch/launch.dart';
import 'package:befriended_flutter/app/widget/delay_expanded.dart';
import 'package:befriended_flutter/app/widget/delay_sizedbox.dart';
import 'package:befriended_flutter/app/widget/text_field.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AvailabilitySchedule extends StatefulWidget {
  const AvailabilitySchedule({
    Key? key,
    // required this.selectedPage,
    // required this.onTapped,
  }) : super(key: key);

  // final HomePageStatus selectedPage;
  // final Function(HomePageStatus, int) onTapped;

  @override
  State<AvailabilitySchedule> createState() => _AvailabilityScheduleState();
}

class _AvailabilityScheduleState extends State<AvailabilitySchedule> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DefaultAssetBundle.of(context).loadString('assets/timezones.json').then(
            (value) =>
                context.read<AvialabiliyScheduleCubit>().getTimezoneList(value),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.70,
      padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child:
            // SingleChildScrollView(
            //   child:
            Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Availablility schedule',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left,
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Time Zone',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(25, 10, 25, 0),
              child: BlocBuilder<AvialabiliyScheduleCubit,
                  AvialabiliyScheduleState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      showCupertinoModalBottomSheet<TimezoneModel>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        shadow: BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 0,
                          spreadRadius: 0,
                          offset: Offset(0, 0),
                        ),
                        builder: (context) {
                          return CustomDialog(
                            searchList: state.timezoneList ?? [],
                          );
                        },
                        duration: Duration(milliseconds: 500),
                      ).then((selectedTimezone) {
                        if (selectedTimezone != null) {
                          context
                              .read<AvialabiliyScheduleCubit>()
                              .selectedTimezoneDataChanged(selectedTimezone);
                          // context
                          //     .read<AppCubit>()
                          //     .countryCodeChanged(selectedTimezone.);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 25,
                        left: 20,
                        bottom: 25,
                      ),
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
                      child: Text(
                        state.selectedTimezoneData?.name ?? '',
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: DealySizedBox(
                delay: 350,
                child: FadeAnimation(
                  delay: 50,
                  child: Text(
                    'Press and drag slots to select',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            const DealyExpanded(
              delay: 350,
              child: FadeAnimation(
                delay: 50,
                child: ScheduleSelection(),
              ),
            ),
            // ScheduleSelection(),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    required this.searchList,
  }) : super(key: key);

  final List<TimezoneModel> searchList;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

// dialogue state class
class _CustomDialogState extends State<CustomDialog> {
  List<TimezoneModel> tmpList = [];

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
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              label: 'Search Timezone',
              prefixIcon: Icon(
                Icons.search,
                size: 25,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              onChanged: filterData,
            ),
            Expanded(
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
                    child: Text(
                      tmpList[index].name,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),
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
      widget.searchList.forEach((timezone) {
        // ignore: always_put_control_body_on_new_line
        if (timezone.name.toLowerCase().contains(text.toLowerCase())) {
          tmpList.add(timezone);
        }
      });
    }
    setState(() {});
  }
}
