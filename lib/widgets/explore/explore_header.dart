import 'package:flutter/material.dart';

import '../../resource/colors.dart';

class ExploreHeader extends StatefulWidget {
  const ExploreHeader({super.key});

  @override
  State<ExploreHeader> createState() => _ExploreHeaderState();
}

class _ExploreHeaderState extends State<ExploreHeader> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(height: 10,),
            Text(
              "Explore",
              style: TextStyle(
                  fontSize: 43,
                  color: AppColors.primary,
                  fontFamily: 'poppins-black'),
            ),
          ],
        ),
        const Image(
          image: AssetImage('assets/images/pcpsLogo.png'),
          width: 80,
          height: 30,
          fit: BoxFit.cover,
        )
      ],
    );
  }
}
