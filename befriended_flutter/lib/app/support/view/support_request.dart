import 'package:befriended_flutter/app/app_cubit/app_cubit.dart';
import 'package:befriended_flutter/app/availability_schedule/availability_schedule.dart';
import 'package:befriended_flutter/app/home/home.dart';
import 'package:befriended_flutter/app/launch/launch.dart';
import 'package:befriended_flutter/app/support/cubit/cubit.dart';
import 'package:befriended_flutter/app/widget/bouncing_button.dart';
import 'package:befriended_flutter/app/widget/text_field.dart';
import 'package:befriended_flutter/firebase/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SupportRequest extends StatefulWidget {
  const SupportRequest({
    Key? key,
    // required this.selectedPage,
    // required this.onTapped,
  }) : super(key: key);

  // final HomePageStatus selectedPage;
  // final Function(HomePageStatus, int) onTapped;

  @override
  State<SupportRequest> createState() => _SupportRequestState();
}

class _SupportRequestState extends State<SupportRequest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.70,
      padding: const EdgeInsetsDirectional.fromSTEB(25, 50, 20, 70),
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
                onTap: () {},
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Our team will contact you soon after getting this request!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 30,
            ),
            BlocBuilder<SupportCubit, SupportState>(
              builder: (context, state) {
                return MyTextField(
                  label: 'Hey buddy! Tell us about how you wish to support',
                  value: state.requestDesc,
                  onChanged: (value) {
                    context.read<SupportCubit>().requestDescChanged(value);
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
                // TODO handle error
                // TODO feedback message
                context.read<SupportCubit>().submitRequest();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenu({
    required String text,
    required IconData iconData,
    required Function() onPress,
  }) {
    return InkWell(
      onTap: onPress,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            child: Icon(
              iconData,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
