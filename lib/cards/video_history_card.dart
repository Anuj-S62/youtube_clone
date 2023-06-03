import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/modal/video_modal.dart';
import 'package:youtube_clone/screens/videoplayerscreen.dart';

class VideoHistoryCard extends StatefulWidget {
  final videoId;
  final videoTitle;
  final videoThumbnail;
  final profile;
  final channelName;
  VideoHistoryCard(
      {required this.videoId,
      required this.videoTitle,
      required this.videoThumbnail,
      required this.profile,
      required this.channelName});

  @override
  State<VideoHistoryCard> createState() => _VideoHistoryCardState();
}

class _VideoHistoryCardState extends State<VideoHistoryCard> {
  @override
  Widget build(BuildContext context) {
    String title = '';
    String name = '';
    int x = 0;
    for (int i = 0; i < widget.videoTitle.toString().length; i++) {
      if (x > 20) break;
      x++;
      title += widget.videoTitle[i];
    }
    title += "..";
    x = 0;
    for (int i = 0; i < widget.channelName.toString().length; i++) {
      if (x > 20) break;
      x++;
      name += widget.channelName[i];
    }
    if (x < widget.channelName.toString().length) {
      name += "..";
    }
    return InkWell(
      onTap: () {
        final VideoModal modal = VideoModal(
            videoId: widget.videoId,
            videoTitle: widget.videoTitle,
            videoThumbnail: widget.videoThumbnail,
            profile: widget.profile,
            channelName: widget.channelName);
        // Handle video selection
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(modal: modal),
          ),
        );
      },
      child: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.9,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.videoThumbnail)),
              ),
              // child: Image.network(widget.videoThumbnail,width: 150,height: 150)
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.1),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          letterSpacing: -0.1),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.more_vert,color: Colors.white,),
                  onPressed: () {
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
                            height: 115,
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
                                            Icon(Icons.add_box_outlined,color: Colors.black,size: 25,),
                                            SizedBox(width: 15,),
                                            Text("Save to playlist",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500,letterSpacing: -0.2),),
                                          ],
                                        ),
                                      ),
                                    )
                                ),
                                TextButton(
                                    onPressed: () async{
                                      FirebaseFirestore.instance.collection('youtube').doc('user').update({
                                        'history': FieldValue.arrayRemove([{'videoId': widget.videoId, 'videoTitle':widget.videoTitle,'videoThumbnail':widget.videoThumbnail,'profilePic':widget.profile,'channelName':widget.channelName}]),
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
                                            Text("Remove form watch history",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500,letterSpacing: -0.2),),
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          );
                        });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
