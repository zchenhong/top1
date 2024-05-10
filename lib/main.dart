import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
//匯入相機套件模組
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DeliverySystemApp());
}

class DeliverySystemApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/package_order': (context) => PackageOrderPage(),
        '/history': (context) => HistoryPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登入'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.indigo],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '無人寄件系統',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '帳號',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密碼',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/package_order');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: Text('登入', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('註冊帳號', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('註冊帳號'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.indigo],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '建立新帳號',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '帳號',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密碼',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '使用者名稱',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Add registration logic here
                  Navigator.pop(
                      context); // Navigate back to login page after registration
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: Text('註冊', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PackageOrderPage extends StatefulWidget {
  @override
  _PackageOrderPageState createState() => _PackageOrderPageState();
}

class _PackageOrderPageState extends State<PackageOrderPage> {
  late dynamic cameras;
  late CameraController _controller;

  bool isInit = false;

  var image;

  @override
  void initState() {
    super.initState();
    cameraInit();
  }

  void cameraInit() async {
    cameras = await availableCameras();
    print(cameras.length);
    _controller = CameraController(cameras[0], ResolutionPreset.high);

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isInit = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle camera access denied error
            break;
          default:
            // Handle other errors
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<XFile?> takePic() async {
    if (_controller.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await _controller.takePicture();
      return file;
    } on CameraException catch (e) {
      print('拍照錯誤: $e');
      return null;
    }
  }

  void toggleCamera() async {
    int cameraIndex = _controller.description.lensDirection.index;
    cameraIndex = cameraIndex = (cameraIndex + 1) % 2;
    CameraDescription selectedCamera = cameras[cameraIndex];
    await _controller.dispose();
    _controller = CameraController(selectedCamera, ResolutionPreset.high);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('訂單資訊'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('訂單資訊'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/package_order');
              },
            ),
            ListTile(
              title: Text('歷史紀錄'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              title: Text('登出'),
              onTap: () {
                // Add logout logic here
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: '寄件者',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: '寄件人地址',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: '收件人',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: '收件人地址',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text('訊息欄', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: '',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 350.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: !isInit
                  ? Center(child: CircularProgressIndicator())
                  : CameraPreview(_controller),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    toggleCamera();
                  },
                  child: Text('切換鏡頭'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle length button press
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                  ),
                  child: Text('體積', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle volume button press
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                  child: Text('重量', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle order submission
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text('送出', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (isInit) {
                  image = await takePic();
                  setState(() {});
                }
              },
              child: Text('拍照'),
            ),
            SizedBox(height: 16.0),
            image != null ? Image.file(File(image.path)) : Container(),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  // Sample data for the list
  final List<Map<String, dynamic>> orders = [
    {'orderNumber': '001', 'date': '2024-04-01', 'status': 'Delivered'},
    {'orderNumber': '002', 'date': '2024-04-02', 'status': 'In Transit'},
    {'orderNumber': '003', 'date': '2024-04-03', 'status': 'Pending'},
    // Add more sample data as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('歷史資料'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Order Number: ${orders[index]['orderNumber']}'),
              subtitle: Text(
                  'Date: ${orders[index]['date']}\nStatus: ${orders[index]['status']}'),
              onTap: () {
                // Handle tap on order tile
              },
            ),
          );
        },
      ),
    );
  }
}
