import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/floating_cards_bloc.dart';

class FloatingCardsBlocProvider extends InheritedWidget {
  final FloatingCardsBloc bloc;

  FloatingCardsBlocProvider({Key key, Widget child})
      : this.bloc = FloatingCardsBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static FloatingCardsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(FloatingCardsBlocProvider)
            as FloatingCardsBlocProvider)
        .bloc;
  }
}
