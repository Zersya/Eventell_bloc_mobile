import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eventell/blocs/profile/index.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
   static final ProfileBloc _profileBlocSingleton = new ProfileBloc._internal();
   factory ProfileBloc() {
     return _profileBlocSingleton;
   }
   ProfileBloc._internal();
  
  ProfileState get initialState => new UnProfileState();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    try {
      print(event.toString());
      yield await event.applyAsync(currentState: currentState, bloc: this);
    } catch (_) {
      print('ProfileBloc ' + _?.toString());
      yield currentState;
    }
  }
}
