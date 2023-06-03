import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_clone/keys.dart';
import 'package:youtube_clone/cards/home_video_card.dart';
import 'package:youtube_clone/cards/playlist_card.dart';
import 'package:youtube_clone/screens/search_screen.dart';
import 'package:youtube_clone/cards/video_history_card.dart';
import 'dart:convert';
import 'get_data_from_db.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance.collection("youtube").doc('user');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(
                  context, '/searchscreen'
              );
            },
            icon: Icon(Icons.search_sharp,color: Colors.white,size: 28,),
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.account_circle_outlined,color: Colors.white,size: 28,),
          )
        ],
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset('images/ytappbar.jpg',width: 100,height: 80,),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: docRef.snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData || snapshot.hasError || snapshot.connectionState==ConnectionState.waiting){
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Center(child: CircularProgressIndicator(color: Colors.white,)),
              );
            }
            Object? data = snapshot.data;
            List itemList = (data as dynamic)['history'];
            List playList = (data as dynamic)['playlist'];
            // print(itemList);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 17,height: 10,),
                      Icon(Icons.history,color: Colors.grey[300],size: 32,),
                      SizedBox(width: 10,),
                      Text("History",style: TextStyle(color: Colors.grey[200],fontSize: 16,letterSpacing: -0.2),)
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 180,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: itemList.map((mp) => VideoHistoryCard(
                                videoId: mp['videoId'],
                                videoTitle: mp['videoTitle'],
                                videoThumbnail: mp['videoThumbnail'],
                                profile: mp['profilePic'],
                                channelName: mp['channelName']
                            )
                            ).toList()
                        ),
                      ),
                      Divider(thickness: 0.2,color: Colors.grey,),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          SizedBox(width: 17,height: 10,),
                          Icon(Icons.playlist_add_check,color: Colors.grey[300],size: 32,),
                          SizedBox(width: 10,),
                          Text("Playlist",style: TextStyle(color: Colors.grey[200],fontWeight: FontWeight.w400,fontSize: 16,letterSpacing: -0.1),)
                        ],

                      ),
                      Container(
                        height: 180,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: playList.map((mp) => PlaylistCard(
                                videoId: mp['videoId'],
                                videoTitle: mp['videoTitle'],
                                videoThumbnail: mp['videoThumbnail'],
                                profile: mp['profilePic'],
                                channelName: mp['channelName']
                            )
                            ).toList()
                        ),
                      ),
                      Divider(thickness: 0.2,color: Colors.grey,),
                      SizedBox(height: 10,),
                      TextButton(
                          onPressed: () async{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GetDataFromDB(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0,10,0,0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Icon(Icons.video_library_sharp,color: Colors.white,size: 25,),
                                  SizedBox(width: 15,),
                                  Text("Show DataBase Videos",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500,letterSpacing: -0.2),),
                                ],
                              ),
                            ),
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400,letterSpacing: -0.2),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: Icon(Icons.search,color:Colors.grey,),
                            hintText: 'Change Key',
                            hintStyle: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w400,letterSpacing: -0.2),
                          ),
                          onSubmitted: (_contrller){
                              setState(() {
                                print(API_KEY);
                                API_KEY = _contrller.toString();
                                print(API_KEY);
                              });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            //   color: Colors.black,
            //   child: Center(child: CircularProgressIndicator(color: Colors.white,)),
            // );
          }
      ),
    );
  }
}

