import 'package:befriended_flutter/animations/fade_animation.dart';
import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/availability_schedule/availability_schedule.dart';
import 'package:befriended_flutter/app/availability_schedule/view/schedule_selectoion.dart';
import 'package:befriended_flutter/app/buddy_request/cubit/cubit.dart';
import 'package:befriended_flutter/app/buddy_request/cubit/request_buddy.dart';
import 'package:befriended_flutter/app/home/home.dart';
import 'package:befriended_flutter/app/launch/launch.dart';
import 'package:befriended_flutter/app/name/name.dart';
import 'package:befriended_flutter/app/widget/bouncing_button.dart';
import 'package:befriended_flutter/app/widget/delay_sizedbox.dart';
import 'package:befriended_flutter/app/widget/text_field.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BuddyRequest extends StatefulWidget {
  const BuddyRequest({
    Key? key,
    // required this.selectedPage,
    // required this.onTapped,
  }) : super(key: key);

  // final HomePageStatus selectedPage;
  // final Function(HomePageStatus, int) onTapped;

  @override
  State<BuddyRequest> createState() => _BuddyRequestState();
}

class _BuddyRequestState extends State<BuddyRequest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.70,
      padding: const EdgeInsetsDirectional.fromSTEB(25, 25, 20, 0),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                child: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 30,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Befriended will match you with suitable buddy mentor',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 30,
            ),
            BlocBuilder<RequestBuddyCubit, RequestBuddyState>(
              builder: (context, state) {
                return MyTextField(
                  label: 'Tell about yourself',
                  value: state.requestDesc,
                  onChanged: (value) {
                    context.read<RequestBuddyCubit>().requestDescChanged(value);
                  },
                  noOfLines: 5,
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'This will help in understanding about you',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Eating Disorder Type',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                showCupertinoModalBottomSheet<EDType>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  shadow: BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 0,
                    spreadRadius: 0,
                    offset: Offset(0, 0),
                  ),
                  builder: (context) {
                    return CustomDialog();
                  },
                  duration: Duration(milliseconds: 500),
                ).then((eDType) {
                  if (eDType != null) {
                    context
                        .read<RequestBuddyCubit>()
                        .requestEDTypeChanged(eDType);
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
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.04),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: BlocBuilder<RequestBuddyCubit, RequestBuddyState>(
                  builder: (context, state) {
                    return Text(
                      state.requestEdType.value,
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.left,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: BouncingButton(
                onPress: () {
                  showCupertinoModalBottomSheet<String>(
                    context: context,
                    expand: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return AvailabilitySchedule();
                    },
                    shadow: BoxShadow(
                      color: Colors.transparent,
                      blurRadius: 0,
                      spreadRadius: 0,
                      offset: Offset(0, 0),
                    ),
                    // duration: Duration(milliseconds: 500),
                  );
                },
                child: Container(
                  // margin: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.5),
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.schedule_rounded,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 26,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Update Availability',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'This help us match your buddy friend',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            BouncingButton(
              label: 'Send Request',
              onPress: () {
                context.read<RequestBuddyCubit>().submitBuddyRequest();
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

// dialogue state class
class _CustomDialogState extends State<CustomDialog> {
  List<EDType> tmpList = [];

  // initiation of state
  @override
  void initState() {
    super.initState();
    tmpList = EDType.values;
  }

  // build method
  @override
  Widget build(BuildContext context) {
    return Container(
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
                tmpList[index].value,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
