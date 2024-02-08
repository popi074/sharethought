import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';
import 'package:sharethought/route/argument_model_classes.dart';
import 'package:sharethought/route/route_generator.dart';
import 'package:sharethought/services/navigator_service.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/styles/ktext_style.dart';
import 'package:sharethought/view/auth/login/state.dart';

import '../../common_widget/loading/k_circularloading.dart';
import '../../common_widget/loading/k_post_shimmer.dart';
import '../../core/controllers/auth/login_controller.dart';
import '../../core/controllers/feed/feed_controller.dart';
import '../../model/post_model.dart';
import '../auth/userdata/user_data_provider.dart';
import '../home/post_card.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => FeedPageState();
}

class FeedPageState extends ConsumerState<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(loginProvider);
    final userData =
        userState is LoginSuccessState ? userState.usermodel : null;
    final feedData = ref.watch(feedDataProvider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 235, 235),
      appBar: AppBar(
        // title:  Text("Sharethought",style: ktextStyle.font20.copyWith(color: Kcolor.secondary),),
       
       title: Hero(
    tag: 'feedPageTitle', // Same tag as in the source page
    child: Text("Sharethought", style: ktextStyle.font20.copyWith(color: Kcolor.secondary)),
  ),
       
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Kcolor.white,
        // backgroundColor: const Color.fromARGB(255, 247, 107, 174),
        foregroundColor: Kcolor.baseBlack,
        actions: [
          Consumer(builder: (context, ref, _) {
            return InkWell(
              onTap: () {
                if (userData != null) {
                  NavigatorService.navigateToRouteName(
                      RouteGenerator.chatListPage,
                      arguments: ChatUserArguments(userData: userData));
                }
              },
              child: SizedBox(
                height: 40,
                width: 40,
                child: Stack(
                  children: [
                    Image.asset("assets/images/messenger.png",
                      width: 30, height: 30),
                    // Icon(Icons.message_outlined,
                    //     size: 30, color: Kcolor.grey350),
                    // Positioned(
                    //   right: 0,
                    //   top: 0,
                    //   child: Text(
                    //     "4",
                    //     style: ktextStyle.smallText
                    //       ..copyWith(color: Colors.black..withOpacity(.7)),
                    //   ),
                    // )
                  ],
                ),
              ),
            );
          })
        ],
      ),
      body: Consumer(builder: (context, ref, _) {
        if (userData == null) {
          // return const Center(child: Text("Not Found UserData"));
          return const KcircularLoading();
        } else {
          return feedData.when(data: (value) {
            if (value.isEmpty) {
              return const KcircularLoading();
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return PostCard(
                      postModelData: value[index],
                      index: index,
                      userData: userData);
                },
              );
            }
          }, loading: () {
            // return const LoadingShimmer();
            return const KcircularLoading();
          }, error: (error, stack) {
            // return const  LoadingShimmer();
            return const KcircularLoading();
          });
        }
      }),
    );
  }
}
