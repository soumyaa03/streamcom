import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:streamcom/config/agoraid.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:streamcom/controller/firestore_methods.dart';
import 'package:streamcom/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:streamcom/responsive/layout.dart';
import 'dart:convert';

import 'package:streamcom/view/screens/home_screen.dart';
import 'package:streamcom/view/widgets/chats_widget.dart';
import 'package:streamcom/view/widgets/custom_button.dart';

class LiveStreaming extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;
  const LiveStreaming({
    Key? key,
    required this.isBroadcaster,
    required this.channelId,
  }) : super(key: key);

  @override
  State<LiveStreaming> createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStreaming> {
  late final RtcEngine _rtcEngine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;
  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  void _initEngine() async {
    _rtcEngine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    _addListeners();

    await _rtcEngine.enableVideo();
    await _rtcEngine.startPreview();
    await _rtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      _rtcEngine.setClientRole(ClientRole.Broadcaster);
    } else {
      _rtcEngine.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }

  String baseUrl = "https://twitch-tutorial-server.herokuapp.com";

  String? token;

  Future<void> getToken() async {
    final res = await http.get(
      Uri.parse(
          '$baseUrl/rtc/${widget.channelId}/publisher/userAccount/${Provider.of<UserProvider>(context, listen: false).user.uid}/'),
    );

    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

  void _joinChannel() async {
    // await getToken();
    // if (token != null) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _rtcEngine.joinChannelWithUserAccount(
      tempToken,
      'testing',
      Provider.of<UserProvider>(context, listen: false).user.uid,
    );
    // }
  }

  void _switchCamera() {
    _rtcEngine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((err) {
      debugPrint('switchCamera $err');
    });
  }

  void onToggleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _rtcEngine.muteLocalAudioStream(isMuted);
  }

  _leaveChannel() async {
    await _rtcEngine.leaveChannel();
    if ('${Provider.of<UserProvider>(context, listen: false).user.uid}${Provider.of<UserProvider>(context, listen: false).user.username}' ==
        widget.channelId) {
      await FirestoreMethods().endLiveStream(widget.channelId);
    } else {
      await FirestoreMethods().updateViewCount(widget.channelId, false);
    }
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  void _addListeners() {
    _rtcEngine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {},
      userJoined: (uid, elapsed) {
        setState(() {
          remoteUid.add(uid);
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          remoteUid.clear();
        });
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return WillPopScope(
      onWillPop: () async {
        await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: widget.isBroadcaster
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: CustomButton(
                  text: 'End Stream',
                  onTap: _leaveChannel,
                ),
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ResponsiveLatout(
            desktopBody: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _renderVideo(user),
                    ],
                  ),
                ),
                Chat(channelId: widget.channelId),
              ],
            ),
            mobileBody: Column(
              children: [
                _renderVideo(user),
                if ("${user.uid}${user.username}" == widget.channelId)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: _switchCamera,
                        child: const Text('Switch Camera'),
                      ),
                      InkWell(
                        onTap: onToggleMute,
                        child: Text(isMuted ? 'Unmute' : 'Mute'),
                      ),
                    ],
                  ),
                Expanded(
                  child: Chat(
                    channelId: widget.channelId,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _renderVideo(user) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: "${user.uid}${user.username}" == widget.channelId
          ? const RtcLocalView.SurfaceView(
              zOrderMediaOverlay: true,
              zOrderOnTop: true,
            )
          : remoteUid.isNotEmpty
              ? kIsWeb
                  ? RtcRemoteView.SurfaceView(
                      uid: remoteUid[0],
                      channelId: widget.channelId,
                    )
                  : RtcRemoteView.TextureView(
                      uid: remoteUid[0],
                      channelId: widget.channelId,
                    )
              : Container(),
    );
  }
}
