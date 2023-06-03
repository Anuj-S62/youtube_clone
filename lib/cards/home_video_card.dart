import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/modal/video_modal.dart';
import 'package:youtube_clone/screens/videoplayerscreen.dart';


class HomeVideoCard extends StatefulWidget {
  final videoId;
  final videoTitle;
  final videoThumbnail;
  final profile;
  final channelName;
  HomeVideoCard({required this.videoId,required this.videoTitle,required this.videoThumbnail,required this.profile,required this.channelName});

  @override
  State<HomeVideoCard> createState() => _HomeVideoCardState();
}

class _HomeVideoCardState extends State<HomeVideoCard> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          final VideoModal modal = VideoModal(videoId: widget.videoId, videoTitle: widget.videoTitle, videoThumbnail: widget.videoThumbnail, profile: widget.profile, channelName: widget.channelName);
          // Handle video selection
          FirebaseFirestore.instance.collection('youtube')
              .doc('user')
              .update({
            'history': FieldValue.arrayUnion(
                [{'videoId': widget.videoId, 'videoTitle':widget.videoTitle,'videoThumbnail':widget.videoThumbnail,'profilePic':widget.profile,'channelName':widget.channelName}]),
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
                      backgroundImage: NetworkImage(widget.profile),
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
                                                  [{'videoId': widget.videoId, 'videoTitle':widget.videoTitle,'videoThumbnail':widget.videoThumbnail,'profilePic':widget.profile,'channelName':widget.channelName}]),
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
                                                  [{'videoId': widget.videoId, 'videoTitle':widget.videoTitle,'videoThumbnail':widget.videoThumbnail,'profilePic':widget.profile,'channelName':widget.channelName}]),
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
                                              'videoarray': FieldValue.arrayRemove([{'videoId': widget.videoId, 'videoTitle':widget.videoTitle,'videoThumbnail':widget.videoThumbnail,'profilePic':widget.profile,'channelName':widget.channelName}]),
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
