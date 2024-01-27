import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        camera: firstCamera,
      ),
    ),
  );
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    //to display the current output from the Camera,
    // create a CameraController
    _controller = CameraController(widget.camera,
      ResolutionPreset.medium,
    );

    //Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();

  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // if the Future is complete, display the preview
            return CameraPreview(_controller);
          } else {
            // otherwise, display a loading indicator
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        //provide an onPressed callback
        onPressed: () async {
          try {
            // ensure that the camera is initialized
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!mounted) return;
            final directory = await getApplicationDocumentsDirectory();
            String strFileName = '${directory.path}/img_${DateTime.now()}.jpg';
            await File(image.path).renameSync(strFileName);
            await Gal.putImage(strFileName);
            // saveImage(image.path);
            
            // if the picture was taken, display it on new screen
            await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    imagePath: strFileName,
                  ),
                ),
            );
          } catch (e) {
            //if an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // the image is stored as a file on the device. Use the 'Image.file'
      // constructor with the given path to display the image
      body: Image.file(File(imagePath)),
    );
  }
}


