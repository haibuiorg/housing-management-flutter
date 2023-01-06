import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key, required this.link});
  final String link;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late PdfViewerController _pdfViewerController;
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
                onPressed: () async {
                  await launchUrl(Uri.parse(widget.link));
                },
                icon: const Icon(Icons.download),
                label: const Text('Download')),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: SfPdfViewer.network(
            widget.link,
            controller: _pdfViewerController,
          ),
        ),
      ],
    );
  }
}
