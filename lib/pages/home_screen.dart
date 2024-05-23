import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:video_conference_with_web_rtc/api/meeting_api.dart';
import 'package:video_conference_with_web_rtc/models/meeting_details.dart';
import 'package:video_conference_with_web_rtc/pages/join_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String meetingId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting app'),
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
            Text(
              "Wellcome to Web RTC Meeting app",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 20),
            FormHelper.inputFieldWidget(
              context,
              'meetingId',
              'Enter your Meeting Id',
              (val) {
                if (val.isEmpty) {
                  return 'Meeting Id can not be empty';
                }
                return null;
              },
              (onSaved) {
                meetingId = onSaved;
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
                    'Join Meeting',
                    () {
                      if (validateAndSave()) {
                        validateMeeting(meetingId);
                      }
                    },
                  ),
                ),
                Flexible(
                  child: FormHelper.submitButton(
                    'Start Meeting',
                    () async {
                      var response = await startMeetingg();
                      final body = jsonDecode(response!.body);
                      final meetId = body['data'];
                      print('meeting id: $meetId');
                      validateMeeting(meetId);
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

  void validateMeeting(String meetingId) async {
    try {
      final response = await joinMeeting(meetingId);
      var data = jsonDecode(response.body);
      final meetingDetails = MeetingDetail.fromJson(data['data']);

      goToJoinScreen(meetingDetails);
    } catch (e) {
      FormHelper.showSimpleAlertDialog(
        context,
        'Meeting app',
        'Invalid Meeting Id',
        "OK",
        () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  goToJoinScreen(MeetingDetail meetingDetail) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => JoinScreen(
          meetingDetail: meetingDetail,
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
