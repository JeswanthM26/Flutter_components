import 'package:flutter/material.dart';
import 'dart:ui';
import 'apz_menu_style_config.dart';
import '../appz_image/appz_image.dart';
import '../appz_image/appz_assets.dart';
import '../appz_text/appz_text.dart';
import '../appz_text/appz_text_style_config.dart';
import '../apz_button/appz_button.dart';

enum ApzMenuPosition {
  top,
  bottom,
  left,
  right,
}

class MenuOverlayManager {
  static OverlayEntry? _currentEntry;

  static void show(BuildContext context, OverlayEntry entry) {
    hide();
    Overlay.of(context).insert(entry);
    _currentEntry = entry;
  }

  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MenuItem {
  final String text;

  const MenuItem({
    required this.text,
  });
}

class ApzMenu extends StatefulWidget {
  final List<MenuItem> items;
  final VoidCallback? onClose;
  final String? signOutText;
  final VoidCallback? onSignOut;
  final Function(String)? onMenuItemTap;
  final ApzMenuPosition position;
  final Widget child;

  const ApzMenu({
    super.key,
    required this.items,
    required this.child,
    this.onClose,
    this.signOutText,
    this.onSignOut,
    this.onMenuItemTap,
    this.position = ApzMenuPosition.right,
  });

  @override
  State<ApzMenu> createState() => _ApzMenuState();
}

class _ApzMenuState extends State<ApzMenu> {
  bool _configLoaded = false;
  OverlayEntry? _currentEntry;
  final GlobalKey _menuKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    print('Loading config...');
    try {
      await Future.wait([
        ApzMenuStyleConfig.instance.load(),
        AppzTextStyleConfig.instance.load(),
      ]);
      print('Config loaded successfully');
      if (mounted) setState(() => _configLoaded = true);
    } catch (e) {
      print('Error loading config: $e');
      // Set config as loaded even if there's an error to prevent blocking
      if (mounted) setState(() => _configLoaded = true);
    }
  }

  Offset _calculateMenuOffset({
    required Offset targetCenter,
    required Size targetSize,
    required Size menuSize,
    required Size screenSize,
    required double offset,
    required ApzMenuPosition position,
  }) {
    Offset clampOffset(Offset offset) {
      double dx = offset.dx;
      double dy = offset.dy;

      // Ensure menu doesn't overflow horizontally
      if (dx < 0) dx = 0;
      if (dx + menuSize.width > screenSize.width) {
        dx = screenSize.width - menuSize.width;
      }

      // Ensure menu doesn't overflow vertically
      if (dy < 0) dy = 0;
      if (dy + menuSize.height > screenSize.height) {
        dy = screenSize.height - menuSize.height;
      }

      return Offset(dx, dy);
    }

    // Smart fallback if position doesn’t have enough space
    ApzMenuPosition actualPosition = position;
    const double buffer = 16.0;

    switch (position) {
      case ApzMenuPosition.top:
        double spaceAbove = targetCenter.dy - targetSize.height / 2 - offset;
        if (spaceAbove < menuSize.height + buffer) {
          actualPosition = ApzMenuPosition.bottom;
        }
        break;
      case ApzMenuPosition.bottom:
        double spaceBelow = screenSize.height -
            (targetCenter.dy + targetSize.height / 2 + offset);
        if (spaceBelow < menuSize.height + buffer) {
          actualPosition = ApzMenuPosition.top;
        }
        break;
      case ApzMenuPosition.left:
        double spaceLeft = targetCenter.dx - targetSize.width / 2 - offset;
        if (spaceLeft < menuSize.width + buffer) {
          actualPosition = ApzMenuPosition.right;
        }
        break;
      case ApzMenuPosition.right:
        double spaceRight = screenSize.width -
            (targetCenter.dx + targetSize.width / 2 + offset);
        if (spaceRight < menuSize.width + buffer) {
          actualPosition = ApzMenuPosition.left;
        }
        break;
    }

    // Final position calculations
    double dx = 0;
    double dy = 0;

    switch (actualPosition) {
      case ApzMenuPosition.left:
        dx = targetCenter.dx - targetSize.width / 2 - offset - menuSize.width;
        dy = targetCenter.dy - menuSize.height / 2;

        // Clamp Y so it fits on screen
        if (dy + menuSize.height > screenSize.height) {
          dy = screenSize.height - menuSize.height - buffer;
        } else if (dy < buffer) {
          dy = buffer;
        }

        return Offset(dx, dy);

      case ApzMenuPosition.right:
        dx = targetCenter.dx + targetSize.width / 2 + offset;
        dy = targetCenter.dy - menuSize.height / 2;

        if (dy + menuSize.height > screenSize.height) {
          dy = screenSize.height - menuSize.height - buffer;
        } else if (dy < buffer) {
          dy = buffer;
        }

        return Offset(dx, dy);

      case ApzMenuPosition.top:
        dx = targetCenter.dx - menuSize.width / 2;
        dy = targetCenter.dy - targetSize.height / 2 - offset - menuSize.height;
        return clampOffset(Offset(dx, dy));

      case ApzMenuPosition.bottom:
        dx = targetCenter.dx - menuSize.width / 2;
        dy = targetCenter.dy + targetSize.height / 2 + offset;
        return clampOffset(Offset(dx, dy));
    }
  }

  void _showMenu() {
    print('_showMenu called, _configLoaded: $_configLoaded');
    if (!_configLoaded) {
      print('Config not loaded yet, returning');
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox;
    final Size targetSize = renderBox.size;
    final Offset targetCenter =
        renderBox.localToGlobal(targetSize.center(Offset.zero));
    final screenSize = MediaQuery.of(context).size;
    final double offset = 8.0;

    print(
        'Target size: $targetSize, Target center: $targetCenter, Screen size: $screenSize');

    void insertOverlay([Size? measuredMenuSize]) {
      Size menuSize = measuredMenuSize ?? const Size(300, 400);
      final Offset menuOffset = _calculateMenuOffset(
        targetCenter: targetCenter,
        targetSize: targetSize,
        menuSize: menuSize,
        screenSize: screenSize,
        offset: offset,
        position: widget.position,
      );

      print(
          'Menu size: $menuSize, Menu offset: $menuOffset, Position: ${widget.position}');

      final entry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            // Blurred background overlay
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            // Tap outside to dismiss
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  print('Tap outside detected');
                  MenuOverlayManager.hide();
                  _currentEntry = null;
                },
              ),
            ),
            Positioned(
              left: menuOffset.dx,
              top: menuOffset.dy,
              child: Material(
                color: Colors.transparent,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: Transform.translate(
                        offset: Offset(0, (1 - opacity) * 20),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: _menuKey,
                    child: _buildMenuContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      print('Inserting overlay entry');
      MenuOverlayManager.show(context, entry);
      _currentEntry = entry;
    }

    insertOverlay();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final menuBox = _menuKey.currentContext?.findRenderObject() as RenderBox?;
      if (menuBox != null) {
        final actualMenuSize = menuBox.size;
        print('Actual menu size: $actualMenuSize');
        MenuOverlayManager.hide();
        insertOverlay(actualMenuSize);
      }
    });
  }

  void _hideMenu() {
    MenuOverlayManager.hide();
    _currentEntry = null;
  }

  @override
  void dispose() {
    _hideMenu();
    super.dispose();
  }

  Widget _buildMenuContent() {
    final config = ApzMenuStyleConfig.instance;

    final backgroundColor = config.getMenuBackgroundColor();
    final borderRadius = config.getMenuBorderRadius();
    final padding = config.getMenuPadding();
    final closeButtonBgColor = config.getCloseButtonBackgroundColor();
    final closeButtonBorderRadius = config.getCloseButtonBorderRadius();
    final closeButtonPadding = config.getCloseButtonPadding();
    final closeButtonIconSize = config.getCloseButtonIconSize();
    final menuItemPaddingTop = config.getMenuItemPaddingTop();
    final menuItemPaddingBottom = config.getMenuItemPaddingBottom();
    final menuItemSpacing = config.getMenuItemSpacing();
    final menuItemTextColor = config.getMenuItemTextColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Close button above menu
        GestureDetector(
          onTap: () {
            widget.onClose?.call();
            _hideMenu();
          },
          child: Container(
            padding: EdgeInsets.all(closeButtonPadding),
            decoration: BoxDecoration(
              color: closeButtonBgColor,
              borderRadius: BorderRadius.circular(closeButtonBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: AppzImage(
              assetName: AppzIcons.closeCircle1,
              size: AppzImageSize.square(size: closeButtonIconSize),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Menu below close button
        Container(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 400),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max, // <-- changed here!
              children: [
                // Scrollable menu items, fill available space
                Expanded(
                  child: ScrollConfiguration(
                    behavior: _NoScrollbarBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.items
                            .map((item) => _buildMenuItem(item, config))
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          return Column(
                            children: [
                              item,
                              if (index < widget.items.length - 1)
                                SizedBox(height: menuItemSpacing),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // Sign out button below scrollable area, always visible
                if (widget.onSignOut != null) ...[
                  SizedBox(height: menuItemSpacing),
                  AppzButton(
                    onPressed: () {
                      widget.onSignOut?.call();
                      _hideMenu();
                    },
                    label: widget.signOutText ?? 'Sign out',
                    appearance: AppzButtonAppearance.primary,
                    size: AppzButtonSize.medium,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item, ApzMenuStyleConfig config) {
    final menuItemPaddingTop = config.getMenuItemPaddingTop();
    final menuItemPaddingBottom = config.getMenuItemPaddingBottom();
    final menuItemTextColor = config.getMenuItemTextColor();

    return Container(
      padding: EdgeInsets.only(
        top: menuItemPaddingTop,
        bottom: menuItemPaddingBottom,
      ),
      child: GestureDetector(
        onTap: () {
          if (widget.onMenuItemTap != null) {
            widget.onMenuItemTap!(item.text);
          }
          _hideMenu();
        },
        child: AppzText(
          item.text,
          category: 'menuItem',
          fontWeight: 'regular',
          color: menuItemTextColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('ApzMenu tap detected');
        if (_currentEntry == null) {
          print('Showing menu');
          _showMenu();
        } else {
          print('Hiding menu');
          _hideMenu();
        }
      },
      child: widget.child,
    );
  }
}
