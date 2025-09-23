import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/colors.dart';
import '../constants/const.dart';

class MainImageContainer extends StatefulWidget {
  const MainImageContainer({
    super.key,
    required this.images,
  });

  final List<String> images;

  @override
  State<MainImageContainer> createState() => _MainImageContainerState();
}

class _MainImageContainerState extends State<MainImageContainer> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: height * 0.3,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1.0,
            scrollPhysics: const BouncingScrollPhysics(),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.images.isEmpty
              ? [
            Container(
              height: height * 0.3,
              color: textFieldColor,
              child: const Center(child: Text('No Image')),
            )
          ]
              : widget.images.map((img) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                img,
                width: double.infinity,
                height: height * 0.3,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: child,
                    );
                  }
                  return Shimmer.fromColors(
                    baseColor: secondaryColor,
                    highlightColor: mainColor,
                    direction: ShimmerDirection.ltr,
                    child: Container(
                      width: double.infinity,
                      height: height * 0.3,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: height * 0.3,
                  color: textFieldColor,
                  child: const Center(child: Text('No Image')),
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.images.isNotEmpty) ...[
          SizedBox(height: height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(
                  entry.key,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: _currentIndex == entry.key ? 40.0 : 15.0,
                  height: 5.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: _currentIndex == entry.key ? mainColor : Colors.grey.withOpacity(0.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}