import 'package:flutter/material.dart';
import 'package:ping_gai_helper/common/otherfun/custom_carousel.dart';

class Swiper extends StatelessWidget {
  const Swiper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCarousel(
      height: 150,
      autoScroll: true,
      autoScrollDuration: const Duration(seconds: 3),
      items: [
        // CarouselItem(
        //   imageUrl:
        //       'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png',
        //   description: '蛇蛇发卡网',
        //   title: '122222',
        //   imageType: ImageType.network,
        //   url: 'https://www.baidu.com',
        // ),
        // CarouselItem(
        //   imageUrl:
        //       'https://www.cdkaa.com/wp-content/uploads/2024/07/1720277239-Snipaste_2024-07-06_22-46-28.png',
        //   title: "999999999999",
        //   description: '发卡网',
        //   imageType: ImageType.network,
        //   url: 'https://example.com/1',
        // ),
        CarouselItem(
          imageUrl: 'assets/images/login_logo.png',
          description: '联系: 1077156509',
          title: "广告招租",
          imageType: ImageType.asset,
          url: 'https://example.com/1',
        ),
        // CarouselItem(
        //   imageUrl:
        //       'https://www.cdkaa.com/wp-content/uploads/2024/07/1720277239-Snipaste_2024-07-06_22-46-28.png',
        //   title: "22222222222",
        //   description: '发卡网',
        //   imageType: ImageType.network,
        //   url: 'https://example.com/1',
        // ),
        // CarouselItem(
        //   imageUrl:
        //       'https://www.cdkaa.com/wp-content/uploads/2024/07/1720277239-Snipaste_2024-07-06_22-46-28.png',
        //   title: "433333333333",
        //   description: '发卡网',
        //   imageType: ImageType.network,
        //   url: 'https://example.com/1',
        // ),
      ],
    );
  }
}
