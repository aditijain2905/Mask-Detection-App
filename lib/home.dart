
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

//import 'package:tflite/tflite.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   bool _loading=true;
  late File _image;
  final imagepicker = ImagePicker();
   XFile? imageFile;
   List _predictions =[];

  void initState(){
     super.initState();
     loadmodel();

   }

   loadmodel() async{
    await Tflite.loadModel(model: 'assets/model.tflite' , labels :'assets/labels.txt');

   }

   detect_image(File image) async{
     var prediction = await Tflite.runModelOnImage(
         path: image.path,
         numResults: 2,
         threshold: 0.6,
         imageMean: 127.5,
         imageStd: 127.5);

     setState(() {
       _predictions = prediction!;
     //  _output = prediction;
      _loading = false;
     });
   }


   @override
   void dispose(){
     super.dispose();
   }

  Future<void> load_image_gallery() async {
    try {
      final image = await imagepicker.pickImage(source: ImageSource.gallery);
      if (image != null) {

        _image = File(image.path);
      } else {
        return null;
      }
      detect_image(_image);
    } catch(e){}
  }





  load_image_camera()async{
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if(image==null){
      return null;
    }else{

      _image = File(image.path);
      detect_image(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.height;

    return  Scaffold(
      appBar: AppBar(
        title: Text('ML Classifier',style: GoogleFonts.roboto(

        )),
      ),
      body: Container(
          height: h,
        width: w,
        color: Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 180,
              width: 200,
              padding: EdgeInsets.all(10),
             // color: Colors.tealAccent,
              child:  Image.asset('assets/mask.png'),
            ),
            Container(
              child: Text('ML Classifier' , style: GoogleFonts.raleway(
                fontSize: 30,
                fontWeight: FontWeight.w400
              )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width:double.infinity,
              height: 50,
              padding: EdgeInsets.all(10),
              child: ElevatedButton(onPressed: (){
                load_image_gallery();
              },

                style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.teal,
                  shape:
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side : BorderSide(color: Colors.white),



                  )
                ),

                child: Text('Camera', style: GoogleFonts.raleway(
                    fontSize: 20,
                    fontWeight: FontWeight.w400
                )),),
            ),
            Container(
              width:double.infinity,
              height: 50,
              padding: EdgeInsets.all(10),
              child: ElevatedButton(onPressed: (){
                load_image_gallery();
              },

                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side : BorderSide(color: Colors.white),



                    )
                ),

                child: Text('Gallery', style: GoogleFonts.raleway(
                    fontSize: 20,
                    fontWeight: FontWeight.w400
                )),),
            ),
            _loading == false? Container(

              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.file(_image),
                  ),
                  Text(_predictions[0].toString())
                ],
              ),
            ):Container(),
          ],
        ),
      ),
    );
  }
}
