import 'package:flutter/material.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // return LoadingBox(animation: animation);
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;
        return ListView.separated(
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: width * .05, right: 20, top: 20),
              // child: PostLoadingShipper(animation: animation),
              child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skelton(animation: animation, radius: 40, height: 80, width: 80),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Skelton(animation: animation, height: 15, width: width * .4),
                const SizedBox(height: 10),
                Skelton(animation: animation, height: 15, width: width * .34),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        // text area
        Skelton(
          animation: animation,
          radius: 10,
          width: width * .9,
          height: height * .1,
        ),
        // likes and message
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skelton(animation: animation, height: 25, width: 60),
            const SizedBox(width: 20),
            Skelton(animation: animation, height: 25, width: 60),
          ],
        ),
      ],
    ),
            );
          },
          itemCount: 4,
          separatorBuilder: (BuildContext context, int index) {
            return const Padding(padding: EdgeInsets.only(top: 20));
          },
        );
      },
      // child: child,
    );
  }
}

class PostLoadingShipper extends StatelessWidget {
  const PostLoadingShipper({
    super.key,
    required this.animation,
  });

  final Animation animation;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skelton(animation: animation, radius: 40, height: 80, width: 80),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Skelton(animation: animation, height: 15, width: width * .4),
                const SizedBox(height: 10),
                Skelton(animation: animation, height: 15, width: width * .34),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        // text area
        Skelton(
          animation: animation,
          radius: 10,
          width: width * .9,
          height: height * .1,
        ),
        // likes and message
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Skelton(animation: animation, height: 25, width: 60),
            const SizedBox(width: 20),
            Skelton(animation: animation, height: 25, width: 60),
          ],
        ),
      ],
    );
  }
}

class Skelton extends StatelessWidget {
  final double height;

  final double width;

  const Skelton({
    super.key,
    required this.animation,
    this.radius = 5.0,
    this.height = 5,
    this.width = 5,
  });

  final Animation animation;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: [
                0.0,
                (animation.value - 0.2).clamp(0.0, 1.0),
                (animation.value + 0.2).clamp(0.0, 1.0)
              ])),
    );
  }
}
