import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({
    required this.videoEnabled,
    required this.audioEnabled,
    required this.isConnectionFailed,
    required this.onVideoToggle,
    required this.onAudioToggle,
    required this.onReconnect,
    required this.onMeetingEnd,
  });

  final bool videoEnabled;
  final bool audioEnabled;
  final bool isConnectionFailed;
  final VoidCallback onVideoToggle;
  final VoidCallback onAudioToggle;
  final VoidCallback onReconnect;
  final VoidCallback onMeetingEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      height: 60,
      child: Row(
        children: buildControls(),
      ),
    );
  }

  List<Widget> buildControls() {
    if (!isConnectionFailed) {
      return <Widget>[
        IconButton(
          onPressed: onVideoToggle,
          icon: Icon(
            videoEnabled ? Icons.videocam : Icons.videocam_off,
          ),
        ),
        IconButton(
          onPressed: onAudioToggle,
          icon: Icon(
            audioEnabled ? Icons.mic : Icons.mic_off,
          ),
        ),
        const SizedBox(width: 25),
        Container(
          width: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.red),
          child: IconButton(
            onPressed: onMeetingEnd,
            icon: Icon(
              Icons.call_end,
              color: Colors.white,
            ),
          ),
        ),
      ];
    } else {
      return <Widget>[
        FormHelper.submitButton(
          'Reconnect',
          onReconnect,
          btnColor: Colors.red,
          borderRadius: 10,
          width: 200,
          height: 40,
        ),
      ];
    }
  }
}
