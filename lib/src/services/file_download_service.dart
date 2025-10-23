
import 'package:url_launcher/url_launcher.dart';
import 'package:sevyhub/src/utils/exception_util.dart';
import 'package:web/web.dart' as html;

class FileDownloadService {
  Future<void> downloadFile(String url, [String? fileName]) async {
    try {
      if (fileName != null) {

        final anchor = html.HTMLAnchorElement()
          ..href = url
          ..download = fileName
          ..style.display = 'none';
        
        html.document.body?.appendChild(anchor);
        anchor.click();
        html.document.body?.removeChild(anchor);
      } else {
        html.window.open(url, '_blank');
      }
    } catch (e) {

      try {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw AppException('Error downloading file: Could not launch URL');
        }
      } catch (e2) {
        throw AppException('Error downloading file: $e2');
      }
    }
  }
}
