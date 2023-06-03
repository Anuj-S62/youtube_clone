import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_clone/cards/search_video_card.dart';
import 'package:youtube_clone/keys.dart';
import 'package:youtube_clone/screens/accounts_screen.dart';
import 'package:youtube_clone/cards/home_video_card.dart';
import 'package:youtube_clone/screens/search_screen.dart';
import 'dart:convert';
import 'get_data_from_db.dart';


class VideoSearchScreen extends StatefulWidget {
  late final String vID;
  VideoSearchScreen({required this.vID});

  @override
  _VideoSearchScreenState createState() => _VideoSearchScreenState();
}

class _VideoSearchScreenState extends State<VideoSearchScreen> {
  final String videoTitle = '';
  final String apiKey = API_KEY; // Replace with your YouTube API key
  String? channelId; // Replace with your YouTube channel ID
  List<dynamic> videos = [];
  List<dynamic> channel = [];
  String nextPageToken = '';
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  String error = '';

  // final db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    searchYouTubeVideos();

    channelId = widget.vID;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        searchYouTubeVideos();
      }
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> searchYouTubeVideos() async {
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    final apiKey = API_KEY;
    final apiUrl = 'https://www.googleapis.com/youtube/v3/search?part=snippet&q=${widget.vID}&key=$apiKey';


    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          videos.addAll(jsonData['items']);
          nextPageToken = jsonData['nextPageToken'] ?? '';
          isLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          error = response.statusCode.toString();
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error occurred: $error');
      setState(() {
        isLoading = false;
      });
    }
  }


  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // print(channelProfilePicture);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.account_circle_outlined,color: Colors.white,size: 28,),
          )
        ],
        backgroundColor: Colors.black,
        title: TextField(
          controller: _controller,
          // focusedBorder: InputBorder.none,
          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400,letterSpacing: -0.2),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            // prefixIcon: Icon(Icons.search,color:Colors.grey,),
            hintText: widget.vID,
            hintStyle: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400,letterSpacing: -0.2),
          ),
          onSubmitted: (_controller)async{
            final String ID = await getChannelId(_controller.toString());
            final String cName = _controller as String;
            if(ID!="Can't Find"){
              print(ID);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoSearchScreen(vID: _controller.toString()),
                ),
              );
            }
            else{
              setState(() {
                error = "Can't Find the Channel";
              });
            }
          },
        ),
      ),
      body: ListView.builder(
        itemCount: videos.length + 1,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index < videos.length) {
            final video = videos[index];
            final videoId = video['id']['videoId'];
            final videoTitle = video['snippet']['title'];
            final videoThumbnail = video['snippet']['thumbnails']['high']['url'];
            return SearchVideoCard(videoId: videoId, videoTitle: videoTitle, videoThumbnail: videoThumbnail,channelName:video['snippet']["channelTitle"],cID: video['snippet']['channelId'],);
            // return Container();
          } else if (isLoading) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Center(child: CircularProgressIndicator(color: Colors.white,)),
            );
          } else if(error=='404' || error=='403' || error=='402' || error=='400'){
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height/3,),
                    Text('Request failed with status: ${error}',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500,letterSpacing: -0.5),),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GetDataFromDB(),
                            ),
                          );
                        },
                        child: Text("Fetch From DB",style: TextStyle(color: Colors.black,fontSize: 18,letterSpacing: -0.6),))
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
