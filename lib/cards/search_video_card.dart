import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/keys.dart';
import 'package:youtube_clone/modal/video_modal.dart';
import 'package:youtube_clone/screens/videoplayerscreen.dart';


class SearchVideoCard extends StatefulWidget {
  final videoId;
  final videoTitle;
  final videoThumbnail;
  final channelName;
  final cID;
  SearchVideoCard({required this.videoId,required this.videoTitle,required this.videoThumbnail,required this.channelName,required this.cID});

  @override
  State<SearchVideoCard> createState() => _SearchVideoCardState();
}

class _SearchVideoCardState extends State<SearchVideoCard> {
  final apiKey = API_KEY;
  String channelProfilePicture = '';

  @override
  void initState() {
    super.initState();
    fetchChannelProfilePicture();
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchChannelProfilePicture() async {
    // final String apiUrl = 'https://www.google.com/youtube/v3/channels?part=snippet&id=$channelId&key=$apiKey';
    final String apiUrl = 'https://www.googleapis.com/youtube/v3/channels?part=snippet&id=${widget.cID}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final channelData = jsonData['items'][0];
        final profilePictureUrl = channelData['snippet']['thumbnails']['default']['url'];
        final name = channelData['snippet']['title'];
        setState(() {
          print("hello anuj");
          print(profilePictureUrl);
          channelProfilePicture = profilePictureUrl;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        // error = response.statusCode.toString();
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final VideoModal modal = VideoModal(videoId: widget.videoId, videoTitle: widget.videoTitle, videoThumbnail: widget.videoThumbnail, profile: channelProfilePicture, channelName: widget.channelName);
        // Handle video selection
        FirebaseFirestore.instance.collection('youtube')
            .doc('user')
            .update({
          'history': FieldValue.arrayUnion(
              [{'videoId': widget.videoId, 'videoTitle':widget.videoTitle,'videoThumbnail':widget.videoThumbnail,'profilePic':channelProfilePicture,'channelName':widget.channelName}]),
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(modal: modal),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0,5,0,5),
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Image.network(widget.videoThumbnail,width: MediaQuery.of(context).size.width,height: 300,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0,4,8,0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(channelProfilePicture),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.videoTitle,style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600,letterSpacing: -0.1),),
                            Text(widget.channelName,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 12,letterSpacing: -0.1),),
                            SizedBox(height: 5,)
                          ],
                        )

                    ),
                    IconButton(
                        onPressed: (){
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  // <-- SEE HERE
                                  Radius.circular(25.0),
                                ),
                              ),
                              builder: (context) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 170,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[

                                      TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance.collection('youtube')
                                                .doc('user')
                                                .update({
                                              'playlist': FieldValue.arrayUnion(
                                                  [{'videoId': widget.videoId, 'videoTitle':widget.videoTitle,'videoThumbnail':widget.videoThumbnail,'profilePic':channelProfilePicture,'channelName':widget.channelName}]),
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8.0,10,0,0),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: [
                                                  Icon(Icons.playlist_add,color: Colors.black,size: 25,),
                                                  SizedBox(width: 15,),
                                                  Text("Save to playlist",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500,letterSpacing: -0.2),),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                      TextButton(
                                          onPressed: () async{
                                            FirebaseFirestore.instance.collection('youtube')
                                                .doc('user')
                                                .update({
                                              'videoarray': FieldValue.arrayUnion(
                                                  [{'videoId': widget.videoId, 'videoTitle':widget.videoTitle,'videoThumbnail':widget.videoThumbnail,'profilePic':channelProfilePicture,'channelName':widget.channelName}]),
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8.0,10,0,0),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: [
                                                  Icon(Icons.add_box_outlined,color: Colors.black,size: 25,),
                                                  SizedBox(width: 15,),
                                                  Text("Save to database",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500,letterSpacing: -0.2),),
                                                ],
                                              ),
                                            ),
                                          )),
                                      TextButton(
                                          onPressed: () async{
                                            FirebaseFirestore.instance.collection('youtube').doc('user').update({
                                              'videoarray': FieldValue.arrayRemove([{'videoId': widget.videoId, 'videoTitle':widget.videoTitle,'videoThumbnail':widget.videoThumbnail,'profilePic':channelProfilePicture,'channelName':widget.channelName}]),
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(8.0,10,0,0),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete_outline_sharp,color: Colors.black,size: 25,),
                                                  SizedBox(width: 15,),
                                                  Text("Remove form database",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500,letterSpacing: -0.2),),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        icon:  Icon(Icons.more_vert,color: Colors.white,)
                    )

                  ],
                ),
              )
            ],

          ),
        ),
      ),
    );
  }
}
