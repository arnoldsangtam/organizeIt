import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todoapp/constants/text_styles.dart';

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String taskNumber;
  final IconData icon;
  final Color color;
  final bool animate;
  final void Function()? onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.taskNumber,
    required this.icon,
    required this.color,
    required this.animate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Builder(
          builder: (context) {
            Widget content = Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 11),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      icon,
                      color: const Color(0XFFB4C4FF),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoryName,
                          style: CustomTextStyles.categoryStyle,
                        ),
                        Text(
                          taskNumber,
                          style: CustomTextStyles.categoryStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

            return animate
                ? content
                    .animate(
                      onPlay: (controller) => controller.repeat(), // loop
                    )
                    .shimmer(
                        duration: 2.seconds,
                        delay: 0.seconds,
                        color: const Color.fromRGBO(255, 255, 255, 0.8))
                : content;
          },
        ),
      ),
    );
  }
}
