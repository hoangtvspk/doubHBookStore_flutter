import 'package:doubhBookstore_flutter_springboot/src/widgets/title_text.dart';
import 'package:flutter/material.dart';

import '../../themes/light_color.dart';
import 'bottom_curved_Painter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onIconPresedCallback;
  CustomBottomNavigationBar({Key? key, required this.onIconPresedCallback})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _xController;
  late AnimationController _yController;
  @override
  void initState() {
    _xController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);
    _yController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);

    Listenable.merge([_xController, _yController]).addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _xController.value =
        _indexToPosition(_selectedIndex) / MediaQuery.of(context).size.width;
    _yController.value = 1.0;

    super.didChangeDependencies();
  }

  double _indexToPosition(int index) {
    // Calculate button positions based off of their
    // index (works with `MainAxisAlignment.spaceAround`)
    const buttonCount = 4.0;
    final appWidth = MediaQuery.of(context).size.width;
    final buttonsWidth = _getButtonContainerWidth();
    final startX = (appWidth - buttonsWidth) / 2;
    return startX +
        index.toDouble() * buttonsWidth / buttonCount +
        buttonsWidth / (buttonCount * 2.0);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  Widget _icon(IconData icon, bool isEnable, int index, String title) {
    return Expanded(
      child: InkWell(

        onTap: () {
          _handlePressed(index);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          alignment: Alignment.center,
          child: AnimatedContainer(
              height: isEnable ? 50 : 40,
              duration: Duration(milliseconds: 300),
              alignment: Alignment.center,

              child:Column(
                children: [
                  Icon(icon,
                    color: isEnable
                        ? Colors.blueAccent
                        : Theme.of(context).iconTheme.color),
                  TitleText(
                    text: title,
                    fontSize: 9,
                    color: isEnable
                        ? Colors.blueAccent
                        : Theme.of(context).iconTheme.color!,
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final inCurve = ElasticOutCurve(0.38);
    return CustomPaint(
      painter: BackgroundCurvePainter(
          _xController.value * MediaQuery.of(context).size.width,
          Tween<double>(
            begin: Curves.easeInExpo.transform(_yController.value),
            end: inCurve.transform(_yController.value),
          ).transform(_yController.velocity.sign * 0.5 + 0.5),
          Theme.of(context).backgroundColor),
    );
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width > 400.0) {
      width = 400.0;
    }
    return width;
  }

  void _handlePressed(int index) {
    if (_selectedIndex == index || _xController.isAnimating) return;
    widget.onIconPresedCallback(index);
    setState(() {
      _selectedIndex = index;
    });

    _yController.value = 1;
    _xController.animateTo(
        _indexToPosition(index) / MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 620));
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        _yController.animateTo(1, duration: Duration(milliseconds: 1200));
      },
    );
    _yController.animateTo(1.0, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    final height = 60.0;
    return Container(
      width: appSize.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.3,color: Colors.grey),
        ),
      ),
      height: 50,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            width: appSize.width,
            height: height +10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
            ),
          ),
          Positioned(
            left: (appSize.width - _getButtonContainerWidth()) / 2,
            top: 0,
            width: _getButtonContainerWidth(),
            height: height,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined, _selectedIndex == 0, 0,"Trang chủ"),
                _icon(_selectedIndex == 1? Icons.book :Icons.book_outlined, _selectedIndex == 1, 1,"Sách"),
                _icon(_selectedIndex == 2? Icons.shopping_cart : Icons.shopping_cart_outlined, _selectedIndex == 2, 2, "Giỏ hàng"),
                _icon(_selectedIndex == 3? Icons.person :Icons.person_outline, _selectedIndex == 3, 3, "Cá nhân"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
