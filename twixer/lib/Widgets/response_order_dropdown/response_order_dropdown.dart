import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:twixer/DataModel/enums/order_by.dart';
import 'package:twixer/Widgets/response_order_dropdown/base_button.dart';
import 'package:twixer/config.dart';

class ResponseOrderDropdown extends StatefulWidget {
  final void Function(OrderBy) onSelect;

  const ResponseOrderDropdown({super.key, required this.onSelect});

  @override
  State<ResponseOrderDropdown> createState() => _ResponseOrderDropdownState();
}

class _ResponseOrderDropdownState extends State<ResponseOrderDropdown> {
  final OverlayPortalController _controller = OverlayPortalController();
  final link = LayerLink();

  OrderBy selected = OrderBy.date;
  double? _buttonWidth;
  double? _buttonHeight;

  bool menuHasBeenHidden = false;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: link,
      child: TapRegion(
        onTapOutside: (tap) {
          if (this._controller.isShowing) {
            this._controller.toggle();
          }
        },
        child: OverlayPortal(
          controller: this._controller,
          overlayChildBuilder: (context) {
            return Positioned(
              height: 130,
              width: this._buttonWidth! + 10,
              child: CompositedTransformFollower(
                link: link,
                targetAnchor: Alignment.bottomLeft,
                child: TapRegion(
                  onTapOutside: (tap) {
                    if (this._controller.isShowing) {
                      this.menuHasBeenHidden = true;
                      this._controller.toggle();
                    }
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: BLUE),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: OrderBy.values.map((e) {
                        return buildRowElement(e);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          },
          child: BaseButton(
            child: Text("Order response by " + this.selected.screenDisplay.toLowerCase()),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  Widget buildRowElement(OrderBy e) {
    return Container(
      width: this._buttonWidth! + 10,
      padding: EdgeInsets.all(6),
      color: this.selected == e ? BLUE.withAlpha(100) : null,
      child: InkWell(
        onTap: () {
          this.widget.onSelect(e);
          setState(() {
            this.selected = e;
            this._controller.toggle();
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              child: e.icon,
              padding: EdgeInsets.only(right: 5),
            ),
            Text(e.screenDisplay),
          ],
        ),
      ),
    );
  }

  void onTap() {
    if (this.menuHasBeenHidden) {
      this.menuHasBeenHidden = !this.menuHasBeenHidden;
    } else {
      this._controller.toggle();
    }
    this._buttonWidth = context.size?.width;
    this._buttonHeight = context.size?.height;
  }
}
