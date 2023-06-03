import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_clone/keys.dart';
import 'package:youtube_clone/screens/search_result_screen.dart';
import 'package:youtube_clone/screens/video_search_screen.dart';


Future<String> getChannelId(String? channelName) async {
  //                     https://www.googleapis.com/youtube/v3/search?part=snippet&q=iphone12&key=AIzaSyB9wJJ10i-77CYQCMClErVFFAOmPMeV_Rs
  final String apiUrl = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&q=$channelName&type=channel&key=$API_KEY';
  final cID = '';
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final channelId = jsonData['items'][0]['id'];
      print(channelId['channelId']);
      return channelId['channelId'];
      // Navigator.pushNamed(context, '/mainscreen',arguments: channelId);
    } else {
      print('Request failed with status: ${response.statusCode}');
      return "Can't Find";
    }
  } catch (error) {
    print('Error occurred: $error');
  }
  return "Can't Find";

}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String error = '';

  TextEditingController _controller = TextEditingController();

  _myfunc()=>getChannelId(_controller as String);

  @override
  Widget build(BuildContext context) {
    String t = '';
    print(_controller);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.0,5.0,20.0,0),
                child: TextField(
                  controller: _controller,
                  style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400,letterSpacing: -0.2),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.search,color:Colors.grey,),
                    hintText: 'Search YouTube',
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.w400,letterSpacing: -0.2),
                  ),
                  onTap: (){
                    setState(() {
                      error = '';
                    });
                  },
                  onChanged: (_controller){
                    t = _controller;
                  },
                  onSubmitted: (_controller)async{
                    final String ID = await getChannelId(_controller.toString());
                    final String cName = _controller as String;
                    if(ID!="Can't Find"){
                      setState(() {
                        error = '';
                      });
                      print(ID);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoSearchScreen(vID: cName),
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
              SizedBox(height: MediaQuery.of(context).size.height/3,),
              Text(error,style: TextStyle(color: Colors.white),)
            ],
          ),

        ),
        floatingActionButton: SizedBox(
          height: 45,
          width: 110,
          child: FloatingActionButton(
            focusColor: Colors.grey[900],
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            child: Text("is Channel?",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,letterSpacing: -0.2),),
            onPressed: ()async{
              final String ID = await getChannelId(t.toString());
              final String cName = t;
              if(ID!="Can't Find"){
                setState(() {
                  error = '';
                });
                print(ID);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultScreen(sID: ID,cName: cName,),
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
      ),
    );
  }
}
