import 'package:flutter/material.dart';

/////////////////////////////////////////////////////////////////////////////////////////////////
//          All credit goes to Matthew Carroll (https://github.com/matthew-carroll).           //
//  Check out his Youtube channel (https://www.youtube.com/channel/UCtWyVkPpb8An90SNDTNF0Pg).  //
/////////////////////////////////////////////////////////////////////////////////////////////////

/// Places and centers the [child] around the [position].
class CenterAbout extends StatelessWidget {
  final Offset position;
  final Widget child;

  CenterAbout({
    key,
    this.position,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}
