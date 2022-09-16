import 'package:befriended_flutter/app/forum/screens/forum_screen.dart';
import 'package:befriended_flutter/app/widget/delay_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ForumPage();
    return SizedBox(
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (index < 5) {
            return Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 150,
                  margin: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 50, 20, 50),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "You are so close to the victory, don't you dare give up now",
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: DealySizedBox(
                          width: 200,
                          height: 200,
                          child: SvgPicture.asset(
                            'assets/images/home.svg',
                            width: 200,
                            height: 200,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: 50,
                  margin: EdgeInsetsDirectional.fromSTEB(60, 10, 30, 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Icon(
                      Icons.format_quote_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 40,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 100,
                    height: 50,
                    margin: EdgeInsetsDirectional.fromSTEB(30, 10, 60, 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Icon(
                      Icons.format_quote_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 40,
                    ),
                  ),
                )
              ],
            );
          }
          return Container();
        },
        itemCount: 5,
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: <Widget>[
      //     const SizedBox(
      //       height: 100,
      //     ),
      //     const Spacer(),
      //     const SizedBox(
      //       height: 80,
      //     ),
      //   ],
      // ),
    );
  }
}

// const ColorFiltered(
//                   colorFilter: ColorFilter.mode(
//                     Colors.black,
//                     BlendMode.overlay,
//                   ),
//                   child: Image(
//                     image: AssetImage('assets/images/friendship.png'),
//                   ),
//                 ),
