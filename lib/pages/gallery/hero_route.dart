import 'package:flutter/material.dart';

class HeroRoute<T> extends PageRoute<T> {
  HeroRoute({
    required this.builder,
  }) : super();

  final WidgetBuilder builder;
  @override
  Color? get barrierColor => null;

  //路由可被关闭
  @override
  bool get barrierDismissible => true;

  //半透明
  @override
  bool get opaque => false;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
  
  //Page过渡动画
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder(context),
    );
  }
}
