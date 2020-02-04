import 'package:flutter/foundation.dart' show objectRuntimeType;
import 'package:flutter/widgets.dart'
    show
        StatefulWidget,
        State,
        ConnectionState,
        Key,
        required,
        immutable,
        hashValues,
        Widget,
        BuildContext;

@immutable
class StackedAsyncSnapshot<T> {
  /// Creates an [StackedAsyncSnapshot] with the specified [connectionState],
  /// and optionally either [data] or [error] (but not both).
  const StackedAsyncSnapshot._(
      this.connectionState, this.data, this.error, this.stackTrace)
      : assert(connectionState != null),
        assert(!(data != null && error != null));

  /// Creates an [StackedAsyncSnapshot] in [ConnectionState.none] with null data and error.
  const StackedAsyncSnapshot.nothing()
      : this._(ConnectionState.none, null, null, null);

  /// Creates an [StackedAsyncSnapshot] in the specified [state] and with the specified [data].
  const StackedAsyncSnapshot.withData(ConnectionState state, T data)
      : this._(state, data, null, null);

  /// Creates an [StackedAsyncSnapshot] in the specified [state] and with the specified [error].
  const StackedAsyncSnapshot.withError(
      ConnectionState state, Object error, Object stackTrace)
      : this._(state, null, error, stackTrace);

  /// Current state of connection to the asynchronous computation.
  final ConnectionState connectionState;

  /// The latest data received by the asynchronous computation.
  ///
  /// If this is non-null, [hasData] will be true.
  ///
  /// If [error] is not null, this will be null. See [hasError].
  ///
  /// If the asynchronous computation has never returned a value, this may be
  /// set to an initial data value specified by the relevant widget. See
  /// [StackedFutureBuilder.initialData] and [StreamBuilder.initialData].
  final T data;

  /// Returns latest data received, failing if there is no data.
  ///
  /// Throws [error], if [hasError]. Throws [StateError], if neither [hasData]
  /// nor [hasError].
  T get requireData {
    if (hasData) return data;
    if (hasError) throw error;
    throw StateError('Snapshot has neither data nor error');
  }

  /// The latest error object received by the asynchronous computation.
  ///
  /// If this is non-null, [hasError] will be true.
  ///
  /// If [data] is not null, this will be null.
  final Object error;

  /// The latest stacktrace object received by the asynchronous computation.
  final Object stackTrace;

  /// Returns a snapshot like this one, but in the specified [state].
  ///
  /// The [data] and [error] fields persist unmodified, even if the new state is
  /// [ConnectionState.none].
  StackedAsyncSnapshot<T> inState(ConnectionState state) =>
      StackedAsyncSnapshot<T>._(state, data, error, stackTrace);

  /// Returns whether this snapshot contains a non-null [data] value.
  ///
  /// This can be false even when the asynchronous computation has completed
  /// successfully, if the computation did not return a non-null value. For
  /// example, a [Future<void>] will complete with the null value even if it
  /// completes successfully.
  bool get hasData => data != null;

  /// Returns whether this snapshot contains a non-null [error] value.
  ///
  /// This is always true if the asynchronous computation's last result was
  /// failure.
  bool get hasError => error != null;

  @override
  String toString() =>
      '${objectRuntimeType(this, 'AsyncSnapshot')}($connectionState, $data, $error)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StackedAsyncSnapshot<T> &&
        other.connectionState == connectionState &&
        other.data == data &&
        other.error == error;
  }

  @override
  int get hashCode => hashValues(connectionState, data, error);
}

typedef StackedAsyncWidgetBuilder<T> = Widget Function(
    BuildContext context, StackedAsyncSnapshot<T> snapshot);

class StackedFutureBuilder<T> extends StatefulWidget {
  /// Creates a widget that builds itself based on the latest snapshot of
  /// interaction with a [Future].
  ///
  /// The [builder] must not be null.
  const StackedFutureBuilder({
    Key key,
    this.future,
    this.initialData,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  /// The asynchronous computation to which this builder is currently connected,
  /// possibly null.
  ///
  /// If no future has yet completed, including in the case where [future] is
  /// null, the data provided to the [builder] will be set to [initialData].
  final Future<T> future;

  /// The build strategy currently used by this builder.
  ///
  /// The builder is provided with an [AsyncSnapshot] object whose
  /// [AsyncSnapshot.connectionState] property will be one of the following
  /// values:
  ///
  ///  * [ConnectionState.none]: [future] is null. The [AsyncSnapshot.data] will
  ///    be set to [initialData], unless a future has previously completed, in
  ///    which case the previous result persists.
  ///
  ///  * [ConnectionState.waiting]: [future] is not null, but has not yet
  ///    completed. The [AsyncSnapshot.data] will be set to [initialData],
  ///    unless a future has previously completed, in which case the previous
  ///    result persists.
  ///
  ///  * [ConnectionState.done]: [future] is not null, and has completed. If the
  ///    future completed successfully, the [AsyncSnapshot.data] will be set to
  ///    the value to which the future completed. If it completed with an error,
  ///    [AsyncSnapshot.hasError] will be true and [AsyncSnapshot.error] will be
  ///    set to the error object.
  final StackedAsyncWidgetBuilder<T> builder;

  /// The data that will be used to create the snapshots provided until a
  /// non-null [future] has completed.
  ///
  /// If the future completes with an error, the data in the [AsyncSnapshot]
  /// provided to the [builder] will become null, regardless of [initialData].
  /// (The error itself will be available in [AsyncSnapshot.error], and
  /// [AsyncSnapshot.hasError] will be true.)
  final T initialData;

  @override
  State<StackedFutureBuilder<T>> createState() =>
      _StackedFutureBuilderState<T>();
}

/// State for [StackedFutureBuilder].
class _StackedFutureBuilderState<T> extends State<StackedFutureBuilder<T>> {
  /// An object that identifies the currently active callbacks. Used to avoid
  /// calling setState from stale callbacks, e.g. after disposal of this state,
  /// or after widget reconfiguration to a new Future.
  Object _activeCallbackIdentity;
  StackedAsyncSnapshot<T> _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = StackedAsyncSnapshot<T>.withData(
        ConnectionState.none, widget.initialData);
    _subscribe();
  }

  @override
  void didUpdateWidget(StackedFutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.future != widget.future) {
      if (_activeCallbackIdentity != null) {
        _unsubscribe();
        _snapshot = _snapshot.inState(ConnectionState.none);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _snapshot);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.future != null) {
      final Object callbackIdentity = Object();
      _activeCallbackIdentity = callbackIdentity;
      widget.future.then<void>((T data) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot =
                StackedAsyncSnapshot<T>.withData(ConnectionState.done, data);
          });
        }
      }, onError: (Object error, StackTrace stackTrace) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot = StackedAsyncSnapshot<T>.withError(
                ConnectionState.done, error, stackTrace);
          });
        }
      });
      _snapshot = _snapshot.inState(ConnectionState.waiting);
    }
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
  }
}
