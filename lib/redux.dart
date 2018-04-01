import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ========================================================================
class AppState {
  String token;

  AppState(this.token);

  AppState.loadFromJson(j) {
    this.token = j['token'];
  }

  dynamic toJson() => {"token":"${this.token}"};

  void saveToPreference() async {
    SharedPreferences.getInstance()
    .then((sp) {
      sp.setString('state', json.encode(this));
    });
  }
}


// ========================================================================
class ActionUpdateToken {
  String token;

  ActionUpdateToken(this.token);
}

class ActionLoadFromPreference {
  AppState state;

  ActionLoadFromPreference(this.state);
}


// ========================================================================
// The reducer, which takes the previous count and increments it in response
// to an Increment action.
AppState _stateReducer(AppState state, dynamic action) {
  switch (action.runtimeType) {
    case ActionUpdateToken:
      state.token = action.token;
      break;

    case ActionLoadFromPreference:
      return action.state;
      // break;

    default:
  }

  state.saveToPreference();

  return state;
}

_loggingMiddleware(Store<AppState> store, action, NextDispatcher next) {
  print('${new DateTime.now()}: $action');

  next(action);
}


// ========================================================================
final Store<AppState> reduxStore = new Store<AppState>(_stateReducer,
    initialState: new AppState(""), middleware: [_loggingMiddleware]);
