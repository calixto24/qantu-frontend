import 'package:flutter/material.dart';
import 'package:qantu_frontend/views/widgets/custom_app_bar.dart';

class QantuPageLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final double maxWidth;
  final EdgeInsets contentPadding;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const QantuPageLayout({
    super.key,
    required this.title,
    required this.child,
    this.maxWidth = 500,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 8,
    ),
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: CustomHeader(
                  title: title,
                  onBackPressed: onBackPressed,
                  showBackButton: showBackButton,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    padding: contentPadding,
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
