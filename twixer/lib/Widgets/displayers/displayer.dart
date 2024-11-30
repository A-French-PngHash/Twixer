import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:twixer/Widgets/buttons/button_with_loading.dart';
import 'package:twixer/Widgets/other/error_handler.dart';

/// Displayer is a convenient way to show a list of widget that is fetched from a suplied
/// `get` function returning a future. It asynchronously loads elements as the list is browsed.
///
/// - get : The function that supplies the data. Must return a future. The first value indicates wether
/// the request succeeded, the second is a list of value in case it succeeded and the last is an error
/// message in case the request failed. `Displayer` handles the error message by displaying it to the user.
///
/// - buildWidget : This function is called when the values were fetched and are being displayed to the user.
/// It should return a widget corresponding to the value passed.
class Displayer<T> extends StatefulWidget {
  final Future<(bool, List<T>?, String?)> Function(int limit, int offset) get;
  final Widget Function(T value) buildWidget;

  /// Whether to show the retry button or not.
  final bool showRetry;

  Displayer({required this.get, required this.buildWidget, super.key, required this.showRetry});

  @override
  State<StatefulWidget> createState() {
    return _DisplayerState<T>();
  }
}

class _DisplayerState<T> extends State<Displayer> {
  final controller = ScrollController();
  late ErrorHandler _handler;
  bool _loadingData = false;
  List<T> _values = [];
  int _itemCount = 0;

  void loadData() {
    setState(() {
      _loadingData = true;
    });
    compute((a) async {
      final value = await widget.get(a.$1, a.$2);
      setState(() {
        final res = _handler.handle(value);
        _loadingData = false;
        if (res != null) {
          _itemCount += res.length;
          for (var value in res) {
            _values.add(value);
          }
        }
      });
    }, (30, _itemCount));
    widget.get(30, _itemCount).then((value) {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset && !_loadingData) {
        loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _handler = ErrorHandler(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (_itemCount == 0)
            ? buildRetry(context)
            : Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  cacheExtent: 20,
                  controller: controller,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: widget.buildWidget(_values[index]),
                    );
                  },
                  itemCount: _itemCount,
                  physics: BouncingScrollPhysics(),
                ),
              ),
      ],
    );
  }

  Widget buildRetry(BuildContext context) {
    if (widget.showRetry) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text("Nothing here...", style: Theme.of(context).textTheme.bodyMedium),
          ),
          ButtonWithLoading(
            loading: _loadingData,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(7),
                  child: Icon(Icons.refresh),
                ),
                Text("Refresh"),
              ],
            ),
            onPressed: () {
              if (!_loadingData) {
                loadData();
              }
            },
          )
        ],
      );
    } else {
      return Text("");
    }
  }
}
