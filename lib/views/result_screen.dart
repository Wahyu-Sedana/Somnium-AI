import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:somnium_ai/utils/assets.dart';
import 'package:somnium_ai/cores/providers/dream_provider.dart';
import 'package:somnium_ai/localization/app_localizations.dart';
import 'package:somnium_ai/utils/session.dart';

class ResultScreen extends StatefulWidget {
  final String question;

  const ResultScreen({super.key, required this.question});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String locale = "";
  String figures = "";
  String imagePath = "";
  String idFigures = "";

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    String? savedLocale = await SessionManager.getLanguageCode();
    String? savedFigures = await SessionManager.getSelectedFigure();
    String? savedImagePath = await SessionManager.getSelectedImage();
    String? savedIdFigures = await SessionManager.getSelectedFigureId();

    if (savedLocale != null && savedFigures != null && savedImagePath != null) {
      setState(() {
        locale = savedLocale;
        figures = savedFigures;
        idFigures = savedIdFigures!;
        imagePath = savedImagePath;
      });

      Future.microtask(() {
        context.read<DreamProvider>().fetchDreamInterpretation(widget.question, locale, idFigures);
      });
    }
  }

  Future<void> _shareResult(String interpretation, BuildContext context) async {
    final appLocalization = AppLocalizations.of(context);

    if (interpretation.isNotEmpty) {
      Share.share(interpretation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalization!.translate("no_interpretation_to_share"))),
      );
    }
  }

  Future<void> _downloadPDF(String interpretation, String loc, BuildContext context) async {
    final appLocalization = AppLocalizations.of(context);

    var loadFont;
    switch (loc) {
      case 'ja_jp':
        loadFont = await rootBundle.load("assets/fonts/NotoSansJP-Regular.ttf");
        break;
      case 'id_id':
        loadFont = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
        break;
      case 'en_us':
        loadFont = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
        break;
      default:
        break;
    }

    if (interpretation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalization!.translate("no_interpretation_to_save"))),
      );
      return;
    }

    final font = pw.Font.ttf(loadFont);
    final pdf = pw.Document();

    final imageData = await rootBundle.load('assets/images/iconapl.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());

    List<String> listText = interpretation.split("/n");

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Header(
            level: 0,
            child: pw.Center(
              child: pw.ClipOval(
                child: pw.Image(image, width: 100, height: 100),
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          ...listText.map((e) => pw.Paragraph(
              text: e,
              style: pw.TextStyle(
                font: font,
                fontSize: 14,
                color: PdfColor.fromHex('202123'),
              ),
              textAlign: pw.TextAlign.justify)),
        ];
      },
    ));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/somnium_ai.pdf");
    final bytes = await pdf.save();
    await file.writeAsBytes(bytes);
    print("path: ${file.path}");
    OpenFilex.open(file.path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(appLocalization!.translate("pdf_saved_successfully"))),
    );

    return;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DreamProvider>();
    final appLocalization = AppLocalizations.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image with Overlay Gradient
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background2),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Avatar with Hero Animation
                Hero(
                  tag: "profile_avatar",
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: imagePath.isNotEmpty
                          ? Image.asset(imagePath, fit: BoxFit.cover)
                          : const Icon(Icons.person, size: 80, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  figures,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            appLocalization!.translate("your_dream_interpretation"),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: provider.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : provider.dreamResponse != null
                                      ? Text(
                                          provider.dreamResponse!.response,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70,
                                          ),
                                        )
                                      : Text(
                                          appLocalization.translate("no_interpretation"),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white54,
                                          ),
                                        ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        icon: const Icon(Icons.download, color: Colors.white),
                        onPressed: () {
                          _downloadPDF(provider.dreamResponse?.response ?? "", locale, context);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          _shareResult(provider.dreamResponse?.response ?? "", context);
                        },
                      ),
                    )
                  ],
                ),
                // Modern Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      fixedSize: const Size(double.maxFinite, 55),
                    ),
                    child: Text(
                      appLocalization.translate("back"),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
