import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';

/// Inspired by ViewPagerCards (Rubens Sousa):
/// A 3D Card Transformer PageView with depth scaling, peak previews, and tactile elevation.
class ViewPagerCards extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index, bool isSelected) itemBuilder;
  final ValueChanged<int>? onPageChanged;
  final int initialPage;
  final double height;
  final double viewportFraction;

  const ViewPagerCards({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onPageChanged,
    this.initialPage = 0,
    this.height = 320,
    this.viewportFraction = 0.82,
  });

  @override
  State<ViewPagerCards> createState() => _ViewPagerCardsState();
}

class _ViewPagerCardsState extends State<ViewPagerCards> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.toDouble();
    _pageController = PageController(
      initialPage: widget.initialPage,
      viewportFraction: widget.viewportFraction,
    );
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.itemCount,
        onPageChanged: widget.onPageChanged,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final pageOffset = (_currentPage - index).abs();
          final isSelected = (_currentPage.round() == index);

          // ViewPagerCards 3D Transformer scaling & depth calculations
          final scale = (1.0 - (pageOffset * 0.12)).clamp(0.85, 1.05);
          final opacity = (1.0 - (pageOffset * 0.35)).clamp(0.65, 1.0);
          final translateY = (pageOffset * 16.0);
          final shadowElevation = (12.0 - (pageOffset * 8.0)).clamp(2.0, 14.0);

          return Transform.translate(
            offset: Offset(0, translateY),
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppConstants.radius20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.divider,
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primaryGreen.withValues(alpha: 0.25)
                            : Colors.black.withValues(alpha: 0.08),
                        blurRadius: shadowElevation,
                        offset: Offset(0, shadowElevation / 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radius20),
                    child: widget.itemBuilder(context, index, isSelected),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
