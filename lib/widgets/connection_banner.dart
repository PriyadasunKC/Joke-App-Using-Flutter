import 'package:flutter/material.dart';

class ConnectionBanner extends StatelessWidget {
  final bool isOffline;
  final VoidCallback onDismiss;

  const ConnectionBanner({
    Key? key,
    required this.isOffline,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          )),
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          ),
        );
      },
      child: !isOffline
          ? const SizedBox.shrink()
          : Material(
              key: const ValueKey<String>('banner'),
              elevation: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFDF6B2).withOpacity(0.95),
                      const Color(0xFFFEF3C7).withOpacity(0.95),
                    ],
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFD97706).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  maintainBottomViewPadding: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        // Status Icon Container
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFD97706).withOpacity(0.2),
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.wifi_rounded,
                                color: const Color(0xFFD97706),
                                size: 22,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDC2626),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Message Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'No Internet Connection',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Color(0xFF92400E),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDC2626)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'OFFLINE',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFDC2626),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'You\'re viewing cached content. Some features may be limited.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      const Color(0xFF92400E).withOpacity(0.8),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Action Buttons
                        Row(
                          children: [
                            // Retry Button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Implement retry logic here
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    color: const Color(0xFF92400E)
                                        .withOpacity(0.8),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Dismiss Button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onDismiss,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: const Color(0xFF92400E)
                                        .withOpacity(0.8),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
