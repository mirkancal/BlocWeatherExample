import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DetailBlocState extends Equatable {
  DetailBlocState([List props = const <dynamic>[]]) : super(props);
}

class InitialDetailBlocState extends DetailBlocState {}

class LoadingDetailState extends DetailBlocState {}

class FetchedDetailState extends DetailBlocState {}
