import 'package:flutter/material.dart';

class ChannelCard extends StatelessWidget {
  final String channelName;
  final String profilePic;
  ChannelCard({required this.channelName,required this.profilePic});

  @override
  Widget build(BuildContext context) {
    // final String channelName= "Technical Guruji";
    // final String profilePic = "https://yt3.ggpht.com/ytc/AGIKgqNW-a_Zw3PVxbqxxYNhGQuYVHjUSGVqutrN_m5wVPo=s88-c-k-c0x00ffffff-no-rj";
    String cName = '@';
    for(int i = 0;i<channelName.length;i++){
      if(channelName[i]!=' '){
        cName += channelName[i];
      }
    }

    return channelName!="" ? Container(
      color: Colors.black,
      width: double.infinity,
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0,40,35,0),
                child: CircleAvatar(backgroundImage: NetworkImage(profilePic),radius: 30,),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50,),
                  Text(channelName,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600,letterSpacing: -0.1),),
                  SizedBox(height: 3,),
                  Text(cName,style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w500)),
                  SizedBox(height: 3,),
                  Text('10.5M subscribers',style: TextStyle(color: Colors.grey,fontSize: 12,fontWeight: FontWeight.w500,letterSpacing: -0.2),),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0,40,0,0),
            child: Expanded(child: Text("Latest form ${channelName}",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w700),)),
          )
        ],
      ),
    ) : Container(color: Colors.black,);
  }
}
