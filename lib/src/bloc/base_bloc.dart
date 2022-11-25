import 'dart:async';

abstract class BaseBloc<Event, State> {
  State state;

  BaseBloc(State initialState): state = initialState;

  StreamController<Event> provideEventController();

  StreamController<State> provideStateController();

  StreamController<Event> get eventController {
    return provideEventController();
  }

  StreamController<State> get stateController {
    return provideStateController();
  }

  void dispose() {
    stateController.close();
    eventController.close();
  }
}
