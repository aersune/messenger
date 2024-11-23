import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';

import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class PinataApi extends StatefulWidget {
  const PinataApi({super.key});

  @override
  State<PinataApi> createState() => _PinataApiState();
}

class _PinataApiState extends State<PinataApi> {
  File? downloadedFile;

  static const token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiIyZGJkMjEyNC0yN2ZlLTRlZWItYTU4Ni02MjBmNGJhMDZhYWQiLCJlbWFpbCI6ImFlcnN1bmVAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInBpbl9wb2xpY3kiOnsicmVnaW9ucyI6W3siZGVzaXJlZFJlcGxpY2F0aW9uQ291bnQiOjEsImlkIjoiRlJBMSJ9LHsiZGVzaXJlZFJlcGxpY2F0aW9uQ291bnQiOjEsImlkIjoiTllDMSJ9XSwidmVyc2lvbiI6MX0sIm1mYV9lbmFibGVkIjpmYWxzZSwic3RhdHVzIjoiQUNUSVZFIn0sImF1dGhlbnRpY2F0aW9uVHlwZSI6InNjb3BlZEtleSIsInNjb3BlZEtleUtleSI6IjIwMWJiYzk4MGMzMDc1NTA5ZjE3Iiwic2NvcGVkS2V5U2VjcmV0IjoiYTA3ZjFmY2RhZTZmZjNhZDdmM2EyZTQ1Nzc5YTYyMWM0N2I2MzliMjdiZjhlYmQ3NGJmYzY2NGUyYmVjZGQzMyIsImV4cCI6MTc2MzczNjUxM30.zms_3_vT1Cpl2FbebZ1Mvv2snBxKtmMe9dCeBDmiJ14";

  static const imageId = "bafkreiapwb32k4gilbda2vontyu6guwscgtvxno2sa5vfqbjpn2kqem74i";

  static const gateway = "chocolate-obvious-cat-763.mypinata.cloud";

  Future<void> mainFunction() async {
    try {
      // Fetch the latest file and make a signed URL for it
      final fileRequest = await http.get(
        Uri.parse("https://api.pinata.cloud/v3/files?limit=1"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      final fileData = jsonDecode(fileRequest.body);
      // Get the CID
      final cid = fileData['data']['files'][0]['cid'];
      // Construct the payload
      final data = jsonEncode({
        "url": "https://$gateway/files/$imageId", // Construct the URL with the gateway and CID of the file
        "date": (DateTime.now().millisecondsSinceEpoch / 1000).floor(), // Current date
        "expires": 180, // Number of seconds the link is valid for
        "method": "GET", // Method for accessing a file
      });
      final signedURLRequest = await http.post(
        Uri.parse("https://api.pinata.cloud/v3/files/sign"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: data,
      );
      // Parse the response and get the signed URL
      final url = jsonDecode(signedURLRequest.body)['data'];
      print(url);
      // Download the image using the signed URL and update the local storage
      await downloadFile(url);
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> downloadFile(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final documentDirectory = await getApplicationDocumentsDirectory();
        final filePath = path.join(documentDirectory.path, 'downloaded_image.png');
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes, flush: true);
        // Overwrite the existing file
        setState(() {
          downloadedFile = file;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadImageFromStorage() async {
    try {
      final documentDirectory = await getApplicationDocumentsDirectory();
      final filePath = path.join(documentDirectory.path, 'downloaded_image.png');
      final file = File(filePath);
      if (await file.exists()) {
        setState(() {
          downloadedFile = file;
        });
      }
    } catch (e) {
      print('Error loading image from storage: $e');
    }
  }

// Future<void> _loadImageFromStorage() async {
//   try {
//     final documentDirectory = await getApplicationDocumentsDirectory();
//     final filePath = path.join(documentDirectory.path, 'downloaded_image.png');
//     final file = File(filePath);
//     if (await file.exists()) {
//       setState(() {
//         downloadedFile = file;
//       });
//     }
//   } catch (e) {
//     print('Error loading image from storage: $e');
//   }
// }

  Future<void> uploadFile(File file) async {
    final url = Uri.parse("https://uploads.pinata.cloud/v3/files");
    final request = http.MultipartRequest("POST", url);
    request.headers['Authorization'] = "Bearer $token";
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded successfully');
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        print('Response: $responseString');
      } else {
        print('File upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      await uploadFile(file);
    } else {
      print('No file selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
