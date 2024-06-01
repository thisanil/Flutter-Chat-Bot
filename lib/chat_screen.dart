
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  @override
   List<Messages>_message=[];
  static const apiKay="your gemini Api_Key";
  dynamic model=GenerativeModel(model: 'gemini-pro', apiKey: apiKay);
  Future<void>sendmsg() async {
    var msg=_controller.text;
    _controller.clear();
    setState(() {
      _message.add(Messages(isUser: true, message: msg, date: DateTime.now()));
    });
    var contant=[Content.text(msg)];
    var respons=await model.generateContent(contant);
    setState(() {
      _message.add(Messages(isUser: false, message: respons.text??"", date: DateTime.now()));
    });
  }
  final _controller=TextEditingController();
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/ai.jpg",),
          fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text("ChaT BoT",style:  GoogleFonts.notoSans(
            color:Colors.white,
            fontSize: 25.sp,
            fontWeight: FontWeight.w600,
              letterSpacing:1

          ),),

        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: ListView.builder(
                 itemCount: _message.length,
                 shrinkWrap: true,
                 itemBuilder: (context,index){
                  final msg=_message[index];
                  return Message(
                      isUser: msg.isUser,
                      message: msg.message,
                      data: DateFormat('HH:mm a').format(msg.date)
                  );
                })
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.h),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child:
                    SizedBox(
                      height: 45.h,
                      child: TextFormField(
                        style: GoogleFonts.notoSans(
                          color:Colors.black54,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: Colors.black45,
                        cursorWidth: 2,
                        controller: _controller,

                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              sendmsg();
                            },
                            icon: Icon(Icons.send,color: Colors.black45,),

                          ),
                          fillColor: Colors.grey.shade300,
                          filled: true,
                            contentPadding:  EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),

                            hintText: "Enter Massage",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(color: Colors.transparent)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                              borderSide: BorderSide(color: Colors.transparent)
                          ),
                          disabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.r),
                              borderSide: BorderSide(color: Colors.transparent)
                          ),

                         // label: const Text("Enter Message"),
                          labelStyle:GoogleFonts.notoSans(
                          color:Colors.black,
                          fontSize: 16.sp,
                        )
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final bool isUser;
  final String message;
  final String data;
  const Message({super.key, required this.isUser, required this.message, required this.data});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:isUser?Alignment.centerRight: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 15.w),
        margin: EdgeInsets.symmetric(vertical: 10.h).copyWith(
         left: 10.w,
          right: 10.w
        ),
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.r),
              topLeft: Radius.circular(15.r),
              bottomLeft: isUser?Radius.circular(15.r):Radius.zero,
              bottomRight: isUser?Radius.zero:Radius.circular(15.r),

            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUser?"You":"ChatBot",style: GoogleFonts.notoSans(
              color:Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),),
            SizedBox(height: 4.sp,),
            Text(
              message,
              style:  GoogleFonts.notoSans(
                color:Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
            ),
              maxLines: 1000,
              overflow: TextOverflow.ellipsis,

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  data,
                  style: GoogleFonts.notoSans(
                    color:Colors.black,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,


                  ),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class Messages{
  final bool isUser;
  final String message;
  final DateTime date;
  Messages(
      {
        required this.isUser,
        required this.message,
        required  this.date
      }

      );
}