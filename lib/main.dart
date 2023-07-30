// Gerekli paketlerin import edilmesi
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp()); // Uygulamanın başlangıç noktası

class MyApp extends StatelessWidget {
  // Ana Widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Seçici ve API Gönderme',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'PDF Seçici ve API Gönderme'), // Ana sayfanın başlatılması
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Ana Sayfa Widget'ı
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedPDF; // Seçili PDF dosyasını tutan değişken
  final _nameController =
      TextEditingController(); // İsim metin alanı için controller

  @override
  void dispose() {
    _nameController.dispose(); // Metin alanının dispose edilmesi
    super.dispose();
  }

  void _selectPDF() async {
    // PDF seçme işleminin yapıldığı fonksiyon
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      // PDF dosyasının boyutunun kontrolü
      int fileSizeInBytes = await file.length();
      double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if (fileSizeInMB < 5) {
        setState(() {
          _selectedPDF = file; // Seçilen dosyanın durumunun güncellenmesi
        });

        // Binary dönüşümünün yapılması
        List<int> pdfBytes = await file.readAsBytes();
        String pdfBinary = base64Encode(pdfBytes);

        // Binary kodunun loga yazdırılması
        print('Binary: $pdfBinary');

        // Formun API'ye gönderilmesi
        _sendFormToAPI(pdfBinary);
      } else {
        // PDF dosyasının boyutunun 5MB'dan büyük olduğu durumda hata mesajının yazdırılması
        print('Hata: PDF dosyası 5MB\'dan büyük olamaz.');
      }
    } else {
      // Seçimin iptal edildiği veya hata oluştuğu durumlar
    }
  }

  void _sendFormToAPI(String pdfBinary) {
    // Formun API'ye gönderilmesi fonksiyonu
    String name = _nameController.text;

    print('Name: ' + name + ' Binary Code' + pdfBinary);
    // API'ye gönderme işlemleri burada gerçekleştirilir
    // API URL'sini ve diğer istek parametrelerini uygun şekilde ayarlayın
    // Örnek olarak, HTTP POST isteği kullanarak API'ye gönderebilirsiniz
    // http.post(url, body: {'name': name, 'pdf': pdfBinary});
  }

  @override
  Widget build(BuildContext context) {
    // Widget'ın görünümünün belirlendiği bölüm
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: _selectPDF, // PDF seçme fonksiyonunun çağrılması
              child: Text('PDF Seç'),
            ),
            SizedBox(height: 16),
            Text(
              _selectedPDF != null
                  ? 'Seçilen PDF: ${_selectedPDF!.path}' // Seçilen PDF'in yolu
                  : 'PDF seçilmedi', // PDF seçilmediği durum
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController, // İsim metin alanının controller'ı
              decoration: InputDecoration(
                labelText: 'İsim',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedPDF != null) {
                  _sendFormToAPI(''); // Formun API'ye gönderilmesi
                } else {
                  print('Hata: PDF seçilmedi.'); // PDF seçilmediği durum
                }
              },
              child: Text('Formu Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
