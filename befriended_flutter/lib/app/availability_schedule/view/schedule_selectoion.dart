import 'package:befriended_flutter/app/availability_schedule/cubit/availability_schedule_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleSelection extends StatefulWidget {
  const ScheduleSelection({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<ScheduleSelection> createState() => _ScheduleSelectionState();
}

class _ScheduleSelectionState extends State<ScheduleSelection> {
  GlobalKey gridKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      //DeviceOrientation.landscapeRight,
      //DeviceOrientation.landscapeLeft,
    ]);
  }

  Widget _getText(String text) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 9, 0, 8.7),
      child: Text(
        text,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }

  Widget _getContainer(String text, Color color) {
    return Container(
      width: 36,
      height: 857,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.only(top: 20, right: 3),
        child: RotatedBox(
          quarterTurns: 1,
          child: Text(
            text,
            style: TextStyle(
              letterSpacing: 20,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    int gridStateLength = 7;
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 857,
            margin: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
            padding: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _getText("6 am"),
                _getText("7 am"),
                _getText("8 am"),
                _getText("9 am"),
                _getText("10 am"),
                _getText("11 am"),
                _getText("12 pm"),
                _getText("1 pm"),
                _getText("2 pm"),
                _getText("3 pm"),
                _getText("4 pm"),
                _getText("5 pm"),
                _getText("6 pm"),
                _getText("7 pm"),
                _getText("8 pm"),
                _getText("9 pm"),
                _getText("10 pm"),
                _getText("11 pm"),
                _getText("12 am"),
                _getText("1 am"),
                _getText("2 am"),
                _getText("3 am"),
                _getText("4 am"),
                _getText("5 am"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    margin: EdgeInsetsDirectional.fromSTEB(20.0, 20, 20, 0),
                    child: Row(
                      children: [
                        _getContainer(
                          'Sunday',
                          Colors.red,
                        ),
                        _getContainer(
                          'Monday',
                          Colors.orange,
                        ),
                        _getContainer(
                          'Tuesday',
                          Colors.yellow,
                        ),
                        _getContainer(
                          'Wednesday',
                          Colors.green,
                        ),
                        _getContainer(
                          'Thursday',
                          Colors.blue,
                        ),
                        _getContainer(
                          'Friday',
                          Colors.indigo,
                        ),
                        _getContainer(
                          'Saturday',
                          Colors.purple,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 857,
                  width: 252,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      // border: Border.all(color: Colors.black, width: 0.5),
                      // border: Border(
                      //   top: BorderSide(
                      //     color: Theme.of(context).colorScheme.secondary,
                      //     width: 0.5,
                      //   ),
                      //   left: BorderSide(
                      //     color: Theme.of(context).colorScheme.secondary,
                      //     width: 0.5,
                      //   ),
                      // ),
                      ),
                  // color: Colors.red,
                  margin: EdgeInsetsDirectional.fromSTEB(20.0, 20, 20, 0),
                  child: GridView.builder(
                    key: gridKey,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      //childAspectRatio: 8.0 / 11.9
                    ),
                    itemBuilder: _buildGridItems,
                    itemCount: gridStateLength * 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    // print(index);

    int gridStateLength = 7;
    int x, y = 0;
    x = (index / 7).floor();
    y = (index % gridStateLength);
    GlobalKey gridItemKey = new GlobalKey();

    return BlocBuilder<AvialabiliyScheduleCubit, AvialabiliyScheduleState>(
      builder: (context, state) {
        return GestureDetector(
          onTapDown: (details) {
            RenderBox _box =
                gridItemKey.currentContext!.findRenderObject()! as RenderBox;
            RenderBox _boxGrid =
                gridKey.currentContext!.findRenderObject()! as RenderBox;
            Offset position =
                _boxGrid.localToGlobal(Offset.zero); //this is global position
            double gridLeft = position.dx;
            double gridTop = position.dy;

            double gridPosition = details.globalPosition.dy - gridTop;

            //Get item position
            int indexX = (gridPosition / _box.size.width).floor().toInt();
            int indexY =
                ((details.globalPosition.dx - gridLeft) / _box.size.width)
                    .floor()
                    .toInt();
            if (context
                    .read<AvialabiliyScheduleCubit>()
                    .state
                    .timeMatrix[indexX][indexY] ==
                1) {
              print(indexX.toString() + " - " + indexY.toString());
              context
                  .read<AvialabiliyScheduleCubit>()
                  .timeMatrixChanged(indexX, indexY, 0);
            } else {
              print(indexX.toString() + " - " + indexY.toString());
              context
                  .read<AvialabiliyScheduleCubit>()
                  .timeMatrixChanged(indexX, indexY, 1);
            }

            setState(() {});
          },
          onVerticalDragUpdate: (details) {
            selectItem(gridItemKey, details);
          },
          onHorizontalDragUpdate: (details) {
            selectItem(gridItemKey, details);
          },
          // child: GridTile(
          //   key: gridItemKey,
          child: Container(
            key: gridItemKey,
            height: 100,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.black, width: 0.5),
              border: Border(
                // right: BorderSide(
                //   color: Theme.of(context).colorScheme.secondary,
                //   width: 0.5,
                // ),
                bottom: BorderSide(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  width: 0.5,
                ),
              ),
            ),
            child: Center(
              child: _buildGridItem(state.timeMatrix[x][y]),
            ),
          ),
          // ),
        );
      },
    );
  }

  void selectItem(
      GlobalKey<State<StatefulWidget>> gridItemKey, DragUpdateDetails details) {
    final _boxItem =
        gridItemKey.currentContext!.findRenderObject()! as RenderBox;
    final _boxMainGrid =
        gridKey.currentContext!.findRenderObject()! as RenderBox;
    final position =
        _boxMainGrid.localToGlobal(Offset.zero); //this is global position
    final gridLeft = position.dx;
    final gridTop = position.dy;

    final gridPosition = details.globalPosition.dy - gridTop;

    //Get item position
    final rowIndex = (gridPosition / _boxItem.size.width).floor().toInt();
    final colIndex =
        ((details.globalPosition.dx - gridLeft) / _boxItem.size.width)
            .floor()
            .toInt();
    if (rowIndex < 24 && colIndex < 7) {
      context
          .read<AvialabiliyScheduleCubit>()
          .timeMatrixChanged(rowIndex, colIndex, 1);
    }

    setState(() {});
  }

  Widget _buildGridItem(int value) {
    // print(x.toString() + " - " + y.toString());

    switch (value) {
      // case '':
      //   return Text('');
      //   break;
      case 1:
        return Container(
          color: Colors.green.withOpacity(0.5),
          // height: 10,
        );
        break;
      // case 'N':
      //   return Container(
      //     color: Colors.white,
      //   );
      //   break;
      default:
        return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  // _gridItemTapped(int x, int y) {
  //   print('x is $x and Y is $y');
  // }
}
