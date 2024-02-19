import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/core/controllers/auth/login_controller.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/view/auth/login/login.dart';
import 'package:sharethought/view/auth/login/state.dart';
import 'package:sharethought/view/createPost/create_post_page.dart';
import 'package:sharethought/view/profile/profile_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../feed/feed_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}


// google navbar 

// class _HomePageState extends State<HomePage> {
//   static const  int currenIndex = 0;

//   final List<Widget> _pages = [FeedPage(), CreatePostPage(), Profile_Page()];
//   final  _items =const  [
//      Icon(Icons.home, size: 30),
//      Icon(Icons.add, size: 30),
//      Icon(Icons.people, size: 30)
//     ];
//         int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, ref, _) {
//       final userState = ref.watch(loginProvider);
//       final userData =
//           userState is LoginSuccessState ? userState.usermodel : null;
//       if (userState is LogoutSuccessState) {
//         return Login();
//       }

//       return Scaffold(
//         // body: _pages[currenIndex],
//         body: selectedPage(index: currenIndex),

//       bottomNavigationBar:const GNav(
//         selectedIndex: currenIndex,
//         onTabChange: (index){
//           setState(() {
//             currenIndex = index;
//           });
//         },
//         tabs:  [
//           GButton(
//             icon: Icons.home,
//             text: "Home",
//           ), 
//           GButton(
//             icon: Icons.add,
//             text: "Post",
//           ), 
//           GButton(
//             icon: Icons.people,
//             text: "Profile",
//           ), 
//         ],
//         gap: 0, 
//         backgroundColor: Colors.black, 
//         color: Colors.white, 
//         activeColor: Colors.white, 
//         tabBackgroundColor: Colors.grey,

//       ),
//         //  bottomNavigationBar: Container(
//         //   color: Kcolor.white,
//         //   padding:EdgeInsets.only(top:10),
//         //    child: BottomNavigationBar(

//         //     currentIndex: currenIndex,
//         //     onTap: (value){
//         //       setState((){
//         //         currenIndex = value ;
//         //       });

//         //     },

//         //     selectedItemColor: Kcolor.secondary,
//         //     unselectedItemColor: const Color.fromARGB(255, 46, 46, 46),
//         //     backgroundColor: Kcolor.white,
//         //     elevation: 0.0,
//         //     items:const [
//         //       BottomNavigationBarItem(
//         //         icon: ImageIcon(

//         //           AssetImage("assets/images/home.png",),
//         //           size: 30,

//         //           )
//         //         , label: ''),
//         //       BottomNavigationBarItem(
//         //         icon: ImageIcon(

//         //           AssetImage("assets/images/add.png",),
//         //           size: 30,

//         //           )
//         //         , label: ''),
//         //       BottomNavigationBarItem(
//         //         icon: ImageIcon(

//         //           AssetImage("assets/images/user.png",),
//         //           size: 30,

//         //           )
//         //         , label: ''),
//         //       // BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
//         //       // BottomNavigationBarItem(icon: Icon(Icons.add) ,label: ''),
//         //       // BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: ''),
//         //     ]
//         //              ),
//         //  ),
//       );
//     });
//   }

//  Widget selectedPage({required int index}) {
//     Widget widget;
//     switch (index) {
//       case 0:
//         widget = const FeedPage();

//         break;
//       case 1:
//         widget = const CreatePostPage();

//         break;
//       case 2:
//         widget = Profile_Page();

//         break;
//       default:
//         widget = const FeedPage();
//     }
//   return widget;
//   }
// }




// ============== google navbar HomePage === 

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    FeedPage(),CreatePostPage(),Profile_Page()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
   
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.15),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[500]!,
              hoverColor: Colors.grey[500]!,
              gap: 8,
              backgroundColor : Colors.white, 
              activeColor: Colors.black,
              iconSize: 24,
              padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration:const  Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs:const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.add,
                  text: 'Add new',
                ),
                GButton(
                  icon: Icons.people,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}


// =======
// curved navbar 
// class _HomePageState extends State<HomePage> {
//   int currenIndex = 0;

//   final List<Widget> _pages = [FeedPage(), CreatePostPage(), Profile_Page()];
//   final  _items =const  [
//      Icon(Icons.home, size: 30),
//      Icon(Icons.add, size: 30),
//      Icon(Icons.people, size: 30)
//     ];

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, ref, _) {
//       final userState = ref.watch(loginProvider);
//       final userData =
//           userState is LoginSuccessState ? userState.usermodel : null;
//       if (userState is LogoutSuccessState) {
//         return Login();
//       }
//       return Scaffold(
//         // body: _pages[currenIndex],
//         body: selectedPage(index: currenIndex),

//         bottomNavigationBar: CurvedNavigationBar(
//           height: 50, 
//           items: _items,

//           onTap: (value) {
//             setState(() {
//               currenIndex = value;
//             });
//           },
          
//           backgroundColor: Kcolor.secondary,
//           animationDuration: Duration(milliseconds: 300),
//         ),

//         //  bottomNavigationBar: Container(
//         //   color: Kcolor.white,
//         //   padding:EdgeInsets.only(top:10),
//         //    child: BottomNavigationBar(

//         //     currentIndex: currenIndex,
//         //     onTap: (value){
//         //       setState((){
//         //         currenIndex = value ;
//         //       });

//         //     },

//         //     selectedItemColor: Kcolor.secondary,
//         //     unselectedItemColor: const Color.fromARGB(255, 46, 46, 46),
//         //     backgroundColor: Kcolor.white,
//         //     elevation: 0.0,
//         //     items:const [
//         //       BottomNavigationBarItem(
//         //         icon: ImageIcon(

//         //           AssetImage("assets/images/home.png",),
//         //           size: 30,

//         //           )
//         //         , label: ''),
//         //       BottomNavigationBarItem(
//         //         icon: ImageIcon(

//         //           AssetImage("assets/images/add.png",),
//         //           size: 30,

//         //           )
//         //         , label: ''),
//         //       BottomNavigationBarItem(
//         //         icon: ImageIcon(

//         //           AssetImage("assets/images/user.png",),
//         //           size: 30,

//         //           )
//         //         , label: ''),
//         //       // BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
//         //       // BottomNavigationBarItem(icon: Icon(Icons.add) ,label: ''),
//         //       // BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: ''),
//         //     ]
//         //              ),
//         //  ),
//       );
//     });
//   }

//  Widget selectedPage({required int index}) {
//     Widget widget;
//     switch (index) {
//       case 0:
//         widget = const FeedPage();

//         break;
//       case 1:
//         widget = const CreatePostPage();

//         break;
//       case 2:
//         widget = Profile_Page();

//         break;
//       default:
//         widget = const FeedPage();
//     }
//   return widget;
//   }
// }






