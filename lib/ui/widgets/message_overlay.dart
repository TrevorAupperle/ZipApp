import 'package:flutter/material.dart';

class MessageOverlay {
  final String message;
  final Duration duration;
  final String color;
  final String textColor;
  final double opacity;
  final bool background;
  static OverlayEntry? _currentOverlayEntry;
  
  static void removeOverlay() {
    _currentOverlayEntry?.remove();
    _currentOverlayEntry = null;
  }

  MessageOverlay({
    required this.message, 
    required this.duration, 
    this.color = "#000000", 
    this.textColor = "#000000", 
    this.opacity = 1, 
    this.background = false});

    void show(BuildContext context) {
      if (_currentOverlayEntry != null) {
        // An overlay is already showing, so don't show another one.
        return;
      }

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 6 - 25,
            left: MediaQuery.of(context).size.width * 0, // To center horizontally
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: background ? Color(int.parse(color.substring(1, 7), radix: 16) + 0xFF000000).withOpacity(opacity) : Colors.transparent,
                child: Text(
                  message,
                  style: TextStyle(
                    color: Color(int.parse(textColor.substring(1, 7), radix: 16) + 0xFF000000), 
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    
    _currentOverlayEntry = overlayEntry;
    Overlay.of(context).insert(overlayEntry);

    // Automatically remove the overlay after the duration
    Future.delayed(duration, () {
      overlayEntry.remove();
      _currentOverlayEntry = null; // Reset the static variable
    });
  }
}

