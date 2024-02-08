import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharethought/core/controllers/auth/login_controller.dart';
import 'package:sharethought/core/controllers/auth/model/usermodel.dart';
import 'package:sharethought/styles/kcolor.dart';
import 'package:sharethought/view/auth/login/login.dart';
import 'package:sharethought/view/auth/login/state.dart';
import 'package:sharethought/view/createPost/create_post_page.dart';
import 'package:sharethought/view/profile/profile_page.dart';

import '../feed/feed_page.dart';

class HomePage extends StatefulWidget {
  
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {
  int currenIndex = 0 ;
  
  final List<Widget> _pages = [
    FeedPage(), 
    CreatePostPage(), 
    Profile_Page() 
  ];  

  @override
  Widget build(BuildContext context) {
    
    return Consumer(
      
      builder: (context,ref,_) {
        final userState = ref.watch(loginProvider);
    final userData =
        userState is LoginSuccessState ? userState.usermodel : null;
        if(userState is LogoutSuccessState){
          return Login();
        }
        return Scaffold(
          body: _pages[currenIndex], 
          
           bottomNavigationBar: Container( 
            color: Kcolor.white,
            padding:EdgeInsets.only(top:10), 
             child: BottomNavigationBar(
                       
              currentIndex: currenIndex,
              onTap: (value){
                setState((){
                  currenIndex = value ;
                });
               
                
              },
              
              selectedItemColor: Kcolor.secondary, 
              unselectedItemColor: const Color.fromARGB(255, 46, 46, 46),
              backgroundColor: Kcolor.white,
              elevation: 0.0,
              items:const [
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    
                    AssetImage("assets/images/home.png",), 
                    size: 30, 
                    
                    )
                  , label: ''), 
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    
                    AssetImage("assets/images/add.png",), 
                    size: 30, 
                    
                    )
                  , label: ''), 
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    
                    AssetImage("assets/images/user.png",), 
                    size: 30, 
                    
                    )
                  , label: ''), 
                // BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''), 
                // BottomNavigationBarItem(icon: Icon(Icons.add) ,label: ''), 
                // BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: ''), 
              ]
                       ),
           ),
        );
    
    
      }
    );
  }
}