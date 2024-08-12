//const Gemini_Api_Key = "AIzaSyBq5OoKy6vnalfZhD-niTYwTAUHXCqZ5CE";
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController prompt=TextEditingController();
  bool scanning=false;
  String mytext="";
  XFile? pickedImage;
  final ImagePicker _imagePicker = ImagePicker();

  getImage(ImageSource ourSource) async {
    XFile? result = await _imagePicker.pickImage(source: ourSource);
    print('lululu');
    if (result != null) {
      setState(() {
        pickedImage = result;
      });
    }
  }

  getdata(img,promptValue) async {

  setState(() {
      scanning=true;
      mytext = 'okokokok';
    });


    final model = GenerativeModel(model: 'gemini-1.5-flash',apiKey: "AIzaSyBq5OoKy6vnalfZhD-niTYwTAUHXCqZ5CE",);

    Future<DataPart> fileToPart(String mimeType, String path) async {
      return DataPart(mimeType, await File(path).readAsBytes());
    }

    final prompt = 'tell a social media caption with respect to this pic keeping in mind these points ' + promptValue;
    final image = await fileToPart('image/jpeg',img.path);

    try{  final response = await model.generateContent([Content.multi([TextPart(prompt), image])]);
      if(response.text != null)
        mytext = response.text!;
      print(response.text);
    } catch(error){
      print('Error occured');
    }
  scanning = false;
  setState(() {});
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Caption generator',style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold,fontSize: 30),),
          backgroundColor: Colors.black,
          actions: [
          IconButton(onPressed: (){

          getImage(ImageSource.gallery);

        }, icon: const Icon(Icons.photo,color: Color.fromARGB(255, 85, 225, 50),size: 30,)),const SizedBox(width: 20,)],
      ),
      body: Padding(padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            pickedImage == null
                ? Container(
                  height: 340,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.black,width: 2.0,),),
                  child: Center(child: Text('No Image Selected',style: TextStyle(fontSize: 22),),))
                :
            Container(height:340,child: Center(child: Image.file(File(pickedImage!.path),height: 400,))),              
              
              SizedBox(height: 20),

              TextField(
              controller: prompt,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black,width: 4.0,),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black,width: 4.0,),
                ),
                prefixIcon: const Icon(
                  Icons.pending_sharp,
                  color: Colors.black,
                ),
                hintText: 'Which kind of captions you want??',
              ),
            ),
            const SizedBox(height: 20,),

            ElevatedButton.icon(
              onPressed: (){
                  //prompt.text=" Give me social media captions for the picture with these ${prompt.text}";
                  getdata(pickedImage,prompt.text);
              }, 
              icon: const Icon(Icons.generating_tokens_rounded,color: Colors.white,), 
              label: const Padding(
                padding: EdgeInsets.all(10),
                child: Text('Generate caption',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
               style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 137, 195, 242),),
              ),

          const SizedBox(height: 30),

          scanning?
          const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(child: SpinKitThreeBounce(color: Colors.black,size: 20,)),
          ):
          Text(mytext,textAlign: TextAlign.center,style: const TextStyle(fontSize: 20)),

          ],
        ),
      ),
    );
  }
}

