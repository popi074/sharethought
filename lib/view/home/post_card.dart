import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';
import 'package:sharethought/core/controllers/comment/comment_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sharethought/core/network/database_constant.dart';
import '../../common_widget/get_time.dart';
import '../../core/controllers/guest/guest_controller.dart';
import '../../model/post_model.dart';
import '../../route/argument_model_classes.dart';
import '../../route/route_generator.dart';
import '../../services/navigator_service.dart';
import '../../styles/kcolor.dart';
import '../../styles/ktext_style.dart';

class PostCard extends StatelessWidget {
  final PostModel postModelData;
  final int index;
  final UserModel userData;
  final bool isProfilePage;
  const PostCard(
      {super.key,
      required this.postModelData,
      required this.index,
      required this.userData,
      this.isProfilePage = false});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      color: Kcolor.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Consumer(builder: (context, ref, _) {
              return InkWell(
                onTap: () {
                  if (!isProfilePage) {
                    ref
                        .read(guestProvider.notifier)
                        .getGeustData(postModelData.userId);
                    NavigatorService.navigateToRouteName(
                        RouteGenerator.guestProfile);
                  }
                },
                child: postModelData.profileUrl.isEmpty
                    ? const CircleAvatar(
                        radius: 25.0,
                        backgroundImage: AssetImage(DatabaseConst.personavater),
                      )
                    : CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(postModelData.profileUrl),
                      ),
              );
            }),

            // user name
            title: Text(
              postModelData.userName,
              style: ktextStyle.font20
                ..copyWith(color: Colors.black..withOpacity(.5)),
            ),
            subtitle: Text(
              formatDateTime(postModelData.publisDate),
              style: ktextStyle.font18
                ..copyWith(color: Colors.black..withOpacity(.5)),
            ),
            // trailing: postModelData.userId == userData.uid?IconButton(
            //   icon: const Icon(Icons.more_vert, size: 20),
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (context) => Dialog(
            //         child: ListView(
            //           padding: const EdgeInsets.symmetric(
            //             vertical: 16,
            //           ),
            //           shrinkWrap: true, // shrinkWrap true work like span
            //           children: ['Delete', 'Edit']
            //               .map(
            //                 (e) => InkWell(
            //                   onTap: () {},
            //                   child: Container(
            //                     padding: const EdgeInsets.symmetric(
            //                         vertical: 12, horizontal: 16),
            //                     child: Text(e),
            //                   ),
            //                 ),
            //               )
            //               .toList(),
            //         ),
            //       ),
            //     );
            //   },
            // ): Container(),
          ),
          // text
          if (postModelData.description!.isNotEmpty) ...{
            Padding(
              padding: EdgeInsets.only(
                  top: height * .02, left: width * .1, right: width * .05),
              child: Text(
                postModelData.description!,
                style: ktextStyle.fontComicNeue18
                  ..copyWith(color: Colors.black..withOpacity(.7)),
              ),
            )
          },

          const SizedBox(height: 10),

          if (postModelData.photoUrlList!.isNotEmpty) ...{
            CarouselSlider(
              options: CarouselOptions(
                animateToClosest: false,
                autoPlayCurve: Curves.fastOutSlowIn,
                height: height * 0.53,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                viewportFraction: 1,
              ),
              items: postModelData.photoUrlList!.map((value) {
                return Builder(
                  builder: (BuildContext context) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (postModelData.photoUrlList.length > 1) ...{
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 2),
                            child: Text(
                              '${postModelData.photoUrlList!.indexOf(value) + 1}/${postModelData.photoUrlList!.length}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                        },
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FullScreenImageGallery(
                                initialIndex:
                                    postModelData.photoUrlList!.indexOf(value),
                                photoUrls:
                                    postModelData.photoUrlList!.cast<String>(),
                              ),
                            ));
                          },
                          child: Image.network(
                            value,
                            width: width,
                            height: height * 0.45,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          },
          // const Divider(color: Kcolor.baseGrey),
          // const Divider(
          //   color: Kcolor.baseBlack,
          //   indent: 20,
          //   endIndent: 20,
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 20,),
            child: Wrap(
              // Spacing between items
              // runSpacing: 8.0, // Spacing between lines
              children: [
                Text("Likes ${postModelData.likes!.length.toString()}"),
                const SizedBox(width: 20),
                Text("comments ${postModelData.commentCount.toString()}"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Wrap(
              // Spacing between items
              // runSpacing: 8.0, // Spacing between lines
              children: [
                Container( 
                  // color:Colors.green,
                   width:40, 
                    height: 40,
                    padding:const EdgeInsets.only(bottom: 10), 
                    alignment: Alignment.center,
                  child: IconButton(
                      onPressed: () async {
                        await CommentService()
                            .likePost(postModelData, userData.uid);
                      },
                      icon: Icon(
                        postModelData.likes!.contains(userData.uid)
                            ? Icons.favorite
                            : Icons.favorite_outline_outlined,
                        size: 30,
                      )),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("/commentsection",
                        arguments: CommentSectionArguments(
                            postModel: postModelData, userData: userData));
                  },
                  // child: Icon(Icons.comment_outlined, size: 30,)
                  child: Container(
                     padding:const EdgeInsets.only(top: 5), 

                    width:40, 
                    height: 40, 
                    alignment: Alignment.center,
                    // child: Image.asset("assets/images/comment.png",
                    child: Image.asset("assets/images/chat-bubble.png",
                        width: 25, height: 25),
                  ),
                ),
              ],
            ),
          ),

          // Image.asset("assets/images/error-image.png")
        ],
      ),
    );
  }
}

class FullScreenImageGallery extends StatelessWidget {
  final int initialIndex;
  final List<String> photoUrls;

  FullScreenImageGallery({required this.initialIndex, required this.photoUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: photoUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(photoUrls[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        backgroundDecoration: BoxDecoration(
            // color: Colors.black,
            ),
        pageController: PageController(initialPage: initialIndex),
        onPageChanged: (index) {
          // Handle page change if needed
        },
        scrollPhysics: BouncingScrollPhysics(),
      ),
    );
  }
}
