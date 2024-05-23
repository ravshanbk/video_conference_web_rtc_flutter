import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:video_conference_with_web_rtc/models/meeting_details.dart';
import 'package:video_conference_with_web_rtc/pages/meeting_page.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key, required this.meetingDetail});

  final MeetingDetail meetingDetail;

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Meeting'),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key: globalKey,
        child: formUi(),
      ),
    );
  }

  formUi() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            FormHelper.inputFieldWidget(
              context,
              'userId',
              'Enter your name',
              (val) {
                if (val.isEmpty) {
                  return 'Name can not be empty';
                }
                return null;
              },
              (onSaved) {
                userName = onSaved;
              },
              borderRadius: 10,
              borderFocusColor: Colors.redAccent,
              borderColor: Colors.redAccent,
              hintColor: Colors.grey,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: FormHelper.submitButton(
                    'Join',
                    () {
                      if (validateAndSave()) {
                        final v = widget.meetingDetail;
                        final vv = userName;
                        print('meeting detalils: ${v}');
                        print('user name: ${vv}');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingPage(
                              meetingId: widget.meetingDetail.id,
                              name: userName,
                              meetingDetail: widget.meetingDetail,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
