import 'package:flutter/material.dart';

/////////////////////////////////////////////////////////////////////////////////////////////////
//          All credit goes to Matthew Carroll (https://github.com/matthew-carroll).           //
//  Check out his Youtube channel (https://www.youtube.com/channel/UCtWyVkPpb8An90SNDTNF0Pg).  //
/////////////////////////////////////////////////////////////////////////////////////////////////

/// An [OverlayBuilder] that passes the position of the [child] to the [overlayBuilder],
/// so that it can be used for placing Widgets relative to it.
class AnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
  final Widget child;

  AnchoredOverlay({
    this.showOverlay,
    this.overlayBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return OverlayBuilder(
              showOverlay: showOverlay,
              overlayBuilder: (BuildContext overlayContext) {
                RenderBox box = context.findRenderObject() as RenderBox;
                final center = box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));
                return overlayBuilder(overlayContext, center);
              },
              child: child,
            );
          }),
    );
  }
}

/// Places the Widget built using the [overlayBuilder] on top of the overlay,
/// that is, on top of everything else. It's completely transparent to the
/// Widget tree, in that the [child] will be rendered as if it wasn't there.
class OverlayBuilder extends StatefulWidget {
  final bool showOverlay;
  final Function(BuildContext) overlayBuilder;
  final Widget child;

  OverlayBuilder({
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
  });

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncWidgetOverlay();
  }

  @override
  void reassemble() {
    super.reassemble();
    syncWidgetOverlay();
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }
    super.dispose();
  }

  void syncWidgetOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: widget.overlayBuilder,
    );
    addToOverlay(overlayEntry);
  }

  void addToOverlay(OverlayEntry entry) async {
    Overlay.of(context).insert(entry);
  }

  void hideOverlay() {
    overlayEntry.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    overlayEntry?.markNeedsBuild();
    return widget.child;
  }
}
