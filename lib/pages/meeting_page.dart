import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:video_conference_with_web_rtc/api/meeting_api.dart';
import 'package:video_conference_with_web_rtc/models/meeting_details.dart';
import 'package:video_conference_with_web_rtc/pages/home_screen.dart';
import 'package:video_conference_with_web_rtc/utils/delete_it/colored_print.dart';
import 'package:video_conference_with_web_rtc/utils/user.utils.dart';
import 'package:video_conference_with_web_rtc/widgets/control_panel.dart';
import 'package:video_conference_with_web_rtc/widgets/remote_connection.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({
    super.key,
    required this.meetingId,
    required this.name,
    required this.meetingDetail,
  });

  final String? meetingId;
  final String? name;
  final MeetingDetail? meetingDetail;

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRenderer = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {
    "audio": true,
    "video": true,
  };
  bool isConnectionFailed = false;
  WebRTCMeetingHelper? meetingHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        onMeetingEnd: onMeetingEnded,
        onReconnect: handleReconnect,
        isConnectionFailed: isConnectionFailed,
      ),
    );
  }

  void startMeeting() async {
    final String userId = await loadUserId();
    coloredPrint('start meeting', userId);
    coloredPrint('start meeting', widget.name);
    coloredPrint('start meeting', widget.meetingId);
    meetingHelper = WebRTCMeetingHelper(
      url: localHost,
      name: widget.name,
      userId: userId,
      meetingId: widget.meetingId,
    );

    MediaStream _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = _localStream;
    meetingHelper!.stream = _localStream;
    coloredPrint('helper connections', meetingHelper?.connections);
    meetingHelper!.on('open', context, (ev, context) {
      coloredPrint('meeting helper oper', ev);
      coloredPrint('meeting helper oper', context);
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on('connection', context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on('user-left', context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on('video-toggle', context, (ev, context) {
      setState(() {});
    });
    meetingHelper!.on('meeting-ended', context, (ev, context) {
      onMeetingEnded();
    });
    meetingHelper!.on('connection-setting-changed', context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on('stream-changed', context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    coloredPrint('helper connections', meetingHelper?.connections);
    setState(() {});
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenderers();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  void onMeetingEnded() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      goToHomePage();
    }
  }

  void handleReconnect() {
    if (meetingHelper != null) {
      meetingHelper!.reconnect();
    }
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      meetingHelper!.toggleVideo();
    }
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children: List.generate(
                  meetingHelper!.connections.length,
                  (index) {
                    return RemoteConnection(
                      renderer: meetingHelper!.connections[index].renderer,
                      connection: meetingHelper!.connections[index],
                    );
                  },
                ),
              )
            : Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Waiting for participants to join the meeting",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
        Positioned(
            bottom: 10,
            right: 0,
            child: SizedBox(
              width: 150,
              height: 200,
              child: RTCVideoView(
                _localRenderer,
              ),
            ))
      ],
    );
  }

  void onAudioToggle() {
    if (meetingHelper != null) {
      meetingHelper!.toggleAudio();
    }
  }

  bool isAudioEnabled() {
    return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
  }

  bool isVideoEnabled() {
    return meetingHelper != null ? meetingHelper!.videoEnabled! : false;
  }

  void goToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }
}
