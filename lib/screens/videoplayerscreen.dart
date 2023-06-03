import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../modal/video_modal.dart';

class VideoPlayerScreen extends StatefulWidget {
  // final String videoId;
  final VideoModal modal;
  VideoPlayerScreen({required this.modal});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {


  late final YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.modal.videoId,
      flags: YoutubePlayerFlags(
        // isLive: true,
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String t1 = '';
    String t2 = '';
    print(MediaQuery.of(context).size.width.toString());
    int x = 0;
    for (var i = 0; i < widget.modal.videoTitle.toString().length; i++) {
      if (x > MediaQuery.of(context).size.width.toInt() / 10 - 2) break;
      x++;
      t1 += widget.modal.videoTitle[i];
    }
    int y = x;
    x = 0;
    for (var i = y; i < widget.modal.videoTitle.toString().length; i++) {
      if (x > MediaQuery.of(context).size.width.toInt() / 10 - 2) break;
      x++;
      t2 += widget.modal.videoTitle[i];
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Flex(
            direction: Axis.horizontal, // this is unique
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(13.0, 0, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t1,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    letterSpacing: -0.3,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                t2 + "..",
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    letterSpacing: -0.3,
                                    fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0.0, 4, 0, 14),
                                child: Text(
                                  '78k views 4y ago',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(widget.modal.profile),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    widget.modal.channelName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.2),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    // videoProgressIndicatorColor: Colors.amber,
                    progressColors: ProgressBarColors(
                      playedColor: Colors.amber,
                      handleColor: Colors.amberAccent
                    ),
                  //   onReady () {
                  // _controller.addListener(listener);
                  // },
                  ),
                ],
              ),
              // Text("hell")
            ]
            // child:
            ),
      ),
    );
  }
}
