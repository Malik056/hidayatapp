import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';

class FastScrollPhysics extends ScrollPhysics {
  const FastScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FastScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 10,
        damping: 1,
      );
}
