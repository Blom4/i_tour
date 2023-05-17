import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailCode {
  static const _email_username = "developer.ms@outlook.com";
  static final _smtpServer = SmtpServer('smtp-mail.outlook.com',
      port: 587,
      ignoreBadCertificate: false,
      ssl: false,
      username: _email_username,
      password: "S1oftwares@com");

  static Future sendEmailToOnePerson(
      {required String to,
      required String info,
      required String header,
      required String subject}) async {
    final message = Message()
      ..from = const Address(_email_username, 'Malefetsane Shelile')
      ..recipients.add(to)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = subject
      // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>$header</h1>\n<p>$info</p>";

    try {
      final sendReport = await send(message, _smtpServer);
      print('Message sent: $sendReport');
    } catch (e) {
      print('Message not sent.$e');
      // for (var p in e.problems) {
      //   print('Problem: ${p.code}: ${p.msg}');
      // }
    }
  }
}
