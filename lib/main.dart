import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<ByteData?> _loadAsset(String key) async {
    try {
      return await rootBundle.load(key);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Uint8List> _generatePDF() async {
    final baseFontData = await _loadAsset("fonts/Arial-Regular.ttf");

    List<pw.Font> fontFallbacks = [];
    final ubuntuFallbackData = await _loadAsset("fonts/Ubuntu-Regular.ttf");
    if (ubuntuFallbackData != null) {
      // add ubuntu font also as font fallback
      fontFallbacks.add(pw.Font.ttf(ubuntuFallbackData));
    }

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(
        base: baseFontData != null ? pw.Font.ttf(baseFontData) : null,
        fontFallback: fontFallbacks,
      ),
    );

    doc.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [pw.Text('\b')];
        },
      ),
    );

    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (format) => _generatePDF(),
      ),
    );
  }
}
