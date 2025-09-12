import 'dart:ui';
import 'package:donut_ui_animation/data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🏠 Main HomePage for Donut Animation
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Controllers
  final PageController _imageSlideController = PageController();
  final PageController _titleSlideController = PageController();
  final PageController _overlaySlideController = PageController(
    initialPage: donutList.length - 1,
  );

  int _currentPage = 0; // track active page index

  /// Handle page change → updates gradient & syncs title
  void _onChangePage(int page) {
    setState(() => _currentPage = page);

    _titleSlideController.animateToPage(
      page,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();

    /// Sync overlay controller with inverse of imageSlide
    _imageSlideController.addListener(() {
      if (_overlaySlideController.hasClients) {
        final maxScroll = _imageSlideController.position.maxScrollExtent;
        final offset = _imageSlideController.offset;
        _overlaySlideController.jumpTo(maxScroll - offset);
      }
    });
  }

  @override
  void dispose() {
    _titleSlideController.dispose();
    _overlaySlideController.dispose();
    _imageSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Background gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.linear,
            width: screen.width,
            height: screen.height,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.3,
                colors: [Colors.white, donutList[_currentPage].color],
              ),
            ),
          ),

          /// 🔹 Donut Title Text
          Positioned(
            top: 160,
            child: SizedBox(
              height: 60,
              width: screen.width,
              child: Center(
                child: DonutTitlePageView(controller: _titleSlideController),
              ),
            ),
          ),

          /// 🔹 Overlay blur donuts
          AnimatedBuilder(
            animation: _overlaySlideController,
            builder: (context, child) {
              return DonutOverlayPageView(controller: _overlaySlideController);
            },
          ),

          /// 🔹 Donut Main Images
          AnimatedBuilder(
            animation: _imageSlideController,
            builder: (context, child) {
              return DonutImagePageView(
                controller: _imageSlideController,
                onPageChanged: _onChangePage,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// 🍩 Donut Title Texts (sync with main page)
class DonutTitlePageView extends StatelessWidget {
  final PageController controller;
  const DonutTitlePageView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: donutList.length,
      controller: controller,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Text(
          donutList[index].name,
          textAlign: TextAlign.center,
          style: GoogleFonts.bebasNeue(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 60,
              letterSpacing: 0.8,
            ),
          ),
        );
      },
    );
  }
}

/// 🍩 Donut Background Overlays (blurred images)
class DonutOverlayPageView extends StatelessWidget {
  final PageController controller;
  const DonutOverlayPageView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: donutList.length,
      scrollDirection: Axis.vertical,
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final image = donutList[donutList.length - index - 1].overlayImage;

        return Stack(
          children: [
            Positioned(
              top: -20,
              left: -30,
              child: _blurredImage(image, 120, sigma: 3),
            ),
            Positioned(
              top: 70,
              right: 40,
              child: Transform.rotate(
                angle: 135,
                child: _blurredImage(image, 70, sigma: 5),
              ),
            ),
            Positioned(
              top: 200,
              left: 40,
              child: Image.asset(image, width: 70),
            ),
            Positioned(
              right: -80,
              bottom: 100,
              child: Transform.rotate(
                angle: 135,
                child: _blurredImage(image, 180, sigma: 4),
              ),
            ),
            Positioned(
              left: -70,
              bottom: -50,
              child: Transform.rotate(
                angle: 80,
                child: _blurredImage(image, 180, sigma: 4),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _blurredImage(String asset, double width, {double sigma = 4}) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: Image.asset(asset, width: width),
    );
  }
}

/// 🍩 Donut Main Images (rotating & scaling)
class DonutImagePageView extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChanged;

  const DonutImagePageView({
    Key? key,
    required this.controller,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: donutList.length,
      scrollDirection: Axis.vertical,
      controller: controller,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        double value = 0.0;

        if (controller.position.haveDimensions) {
          value = index.toDouble() - (controller.page ?? 0);
          value = (value * 0.7).clamp(-1, 1);
        }

        return Transform.rotate(
          angle: value * 5, // rotation
          child: Transform.scale(
            scale: 1.2, // fixed scaling (could also animate)
            child: Image.asset(donutList[index].image),
          ),
        );
      },
    );
  }
}
