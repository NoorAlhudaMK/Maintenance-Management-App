import 'package:flutter_bloc/flutter_bloc.dart';

import 'about_app_event.dart';
import 'about_app_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  AboutBloc() : super(AboutState()) {
    on<LoadAboutInfoEvent>((event, emit) {
      emit(AboutState());
    });
  }
}