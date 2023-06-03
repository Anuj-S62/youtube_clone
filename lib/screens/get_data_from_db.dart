import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_clone/cards/home_video_card.dart';



class GetDataFromDB extends StatelessWidget {
  const GetDataFromDB({Key? key}) : super(key: key);


  // @override
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
            onPressed: (){
              Navigator.pushNamed(
                  context,
                  '/accountscreen'
              );
            },
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
            List itemList = (data as dynamic)['videoarray'];
            print(itemList);
            return itemList.isNotEmpty ? ListView(
                children: itemList.map((mp) => HomeVideoCard(
                    videoId: mp['videoId'],
                    videoTitle: mp['videoTitle'],
                    videoThumbnail: mp['videoThumbnail'],
                    profile: mp['profilePic'],
                    channelName: mp['channelName'])
                ).toList()
            ) : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Center(child: Text("No Data Found",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600,letterSpacing: -0.2),)),
            );
          }
      ),
    );
  }
}
