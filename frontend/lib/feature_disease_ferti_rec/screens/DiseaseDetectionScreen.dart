// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:frontend/feature_disease_ferti_rec/screens/DiseaseAnalysisScreen.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/foundation.dart'; // For kIsWeb
// import 'dart:io';
// import 'dart:typed_data';


// class DiseaseDetectionScreen extends StatefulWidget {
//   @override
//   _DiseaseDetectionScreenState createState() => _DiseaseDetectionScreenState();
// }

// class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
//   CameraController? _cameraController;
//   List<CameraDescription>? cameras;
//   XFile? _capturedImage;
//   Uint8List? _imageBytes;
//   bool _isCameraInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       cameras = await availableCameras();
//       if (cameras!.isNotEmpty) {
//         _cameraController = CameraController(cameras![0], ResolutionPreset.medium);
//         await _cameraController!.initialize();
//         if (!mounted) return;
//         setState(() {
//           _isCameraInitialized = true;
//         });
//       }
//     } catch (e) {
//       print("Error initializing camera: $e");
//     }
//   }

//   Future<void> _captureImage() async {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) return;
//     final XFile image = await _cameraController!.takePicture();
//     setState(() {
//       _capturedImage = image;
//       _imageBytes = null;
//     });
//   }

//   Future<void> _pickFromGallery() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       if (kIsWeb) {
//         final Uint8List bytes = await image.readAsBytes();
//         setState(() {
//           _imageBytes = bytes;
//           _capturedImage = null;
//         });
//       } else {
//         setState(() {
//           _capturedImage = image;
//           _imageBytes = null;
//         });
//       }
//     }
//   }

//   void _proceedToNextScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DiseaseAnalysisScreen(
//           imageBytes: _imageBytes,
//           imagePath: _capturedImage?.path,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("රෝග හඳුනා ගැනීම")),
//       body: Column(
//         children: [
//           Expanded(
//             child: _capturedImage == null
//                 ? _imageBytes != null
//                     ? Image.memory(_imageBytes!, fit: BoxFit.cover)
//                     : _isCameraInitialized
//                         ? CameraPreview(_cameraController!)
//                         : Center(child: CircularProgressIndicator())
//                 : kIsWeb
//                     ? Image.memory(_imageBytes!, fit: BoxFit.cover)
//                     : Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: _captureImage,
//                       icon: Icon(Icons.camera),
//                       label: Text("Take Picture"),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: _pickFromGallery,
//                       icon: Icon(Icons.photo_library),
//                       label: Text("Select from Gallery"),
//                     ),
//                   ],
//                 ),
//                 if (_capturedImage != null || _imageBytes != null) ...[
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _proceedToNextScreen,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                     ),
//                     child: Text("Proceed", style: TextStyle(fontSize: 18)),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io';
import 'dart:typed_data';
import 'DiseaseAnalysisScreen.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  @override
  _DiseaseDetectionScreenState createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  XFile? _capturedImage;
  Uint8List? _imageBytes;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isNotEmpty) {
        _cameraController = CameraController(cameras![0], ResolutionPreset.medium);
        await _cameraController!.initialize();
        if (!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    final XFile image = await _cameraController!.takePicture();
    setState(() {
      _capturedImage = image;
      _imageBytes = null;
    });
  }

  Future<void> _pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        final Uint8List bytes = await image.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _capturedImage = null;
        });
      } else {
        setState(() {
          _capturedImage = image;
          _imageBytes = null;
        });
      }
    }
  }

  void _proceedToNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiseaseAnalysisScreen(
          imageBytes: _imageBytes,
          imagePath: _capturedImage?.path,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("රෝග හඳුනා ගැනීම")),
      body: Column(
        children: [
          Expanded(
            child: _capturedImage == null
                ? _imageBytes != null
                    ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                    : _isCameraInitialized
                        ? CameraPreview(_cameraController!)
                        : Center(child: CircularProgressIndicator())
                : kIsWeb
                    ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                    : Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _captureImage,
                      icon: Icon(Icons.camera),
                      label: Text("Take Picture"),
                    ),
                    ElevatedButton.icon(
                      onPressed: _pickFromGallery,
                      icon: Icon(Icons.photo_library),
                      label: Text("Select from Gallery"),
                    ),
                  ],
                ),
                if (_capturedImage != null || _imageBytes != null) ...[
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _proceedToNextScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: Text("Proceed", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
