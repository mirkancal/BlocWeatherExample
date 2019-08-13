import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DetailBlocEvent extends Equatable {
  DetailBlocEvent([List props = const <dynamic>[]]) : super(props);
}

class BringDetailEvent extends DetailBlocEvent {
  BringDetailEvent(this.woeid, [List props = const <dynamic>[]]) : super(props);
  final int woeid;
}

class SwitchDetailEvent extends DetailBlocEvent {
  SwitchDetailEvent(this.index, [List props = const <dynamic>[]])
      : super(props);
  final int index;
}
