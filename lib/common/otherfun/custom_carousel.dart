import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

enum ImageType { asset, network, placeholder }

class CarouselItem {
  final String imageUrl;
  final ImageType imageType;
  final String title;
  final String description;
  final String url;

  CarouselItem({
    required this.imageUrl,
    required this.imageType,
    required this.title,
    required this.description,
    required this.url,
  });
}

class CustomCarousel extends StatefulWidget {
  final List<CarouselItem> items;
  final double height;
  final bool autoScroll;
  final Duration autoScrollDuration;

  const CustomCarousel({
    super.key,
    required this.items,
    this.height = 200,
    this.autoScroll = true,
    this.autoScrollDuration = const Duration(seconds: 3),
  });

  @override
  CustomCarouselState createState() => CustomCarouselState();
}

class CustomCarouselState extends State<CustomCarousel>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    if (widget.autoScroll) {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(widget.autoScrollDuration, (_) {
      if (_currentPage < widget.items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildImage(CarouselItem item) {
    switch (item.imageType) {
      case ImageType.asset:
        return Image.asset(item.imageUrl, fit: BoxFit.cover);
      case ImageType.network:
        return Image.network(
          item.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error, color: Colors.red),
        );
      case ImageType.placeholder:
        return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              '广告位招租',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              '联系我们预定您的广告位',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (int page) {
              setState(() => _currentPage = page);
              _animationController.reset();
              _animationController.forward();
            },
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return GestureDetector(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(item.url))) {
                    await launchUrl(Uri.parse(item.url));
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(item),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.items.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
