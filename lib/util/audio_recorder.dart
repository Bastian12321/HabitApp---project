import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorder extends StatefulWidget {
  const AudioRecorder({super.key});

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initialize();
  }

  Future<void> _initialize() async {
    await _recorder!.openRecorder();
    await Permission.microphone.request();
    await _player!.openPlayer();
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _player!.closePlayer();
    super.dispose();
  }

  Future<void> _checkPermissionAndStartRecording() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        print('Microphone permission not granted');
        return;
      }
    }

    // Start recording
    _recordedFilePath = 'audio.aac'; // Replace with your desired file path and format

    try {
      await _recorder!.startRecorder(toFile: _recordedFilePath);
      setState(() {
        _isRecording = true;
      });
      print('Recording started');
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.status;
    if(!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        print('Microphone permission not granted');
        return;
      }
    }
    _recordedFilePath = 'audio.aac';
    await _recorder!.startRecorder(toFile: _recordedFilePath);
    setState(() {
      _isRecording = true;
    });
    print('Recording started');
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    //_recordedFilePath = await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    print('Recording stopped');

    // To check if an audio file exists and has content
    if(_recordedFilePath != null) {
      File recordedFile = File(_recordedFilePath!);
      if(await recordedFile.exists()){
        print('Recording saved: ${recordedFile.path}');
        print('File size: ${await recordedFile.length()} bytes');
      } else {
        print('Recording failed: File does not exist');
      }
    }
  }

  Future<void> _startPlayback() async {
    if (_recordedFilePath != null) {
      await _player!.startPlayer(fromURI: _recordedFilePath);
      setState(() {
        _isPlaying = true;
      });

      _player!.onProgress!.listen((event) {
        if (event.position >= event.duration) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
      print('Playback started');
    }
  }

  Future<void> _stopPlayback() async {
    await _player!.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
    print('Playback stopped');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (_isRecording) {
              await _stopRecording();
            } else {
              await _checkPermissionAndStartRecording();
            }
          },
          child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_isPlaying) {
              await _stopPlayback();
            } else {
              await _startPlayback();
            }
          },
          child: Text(_isPlaying ? 'Stop Playing' : 'Play Recording'),
        ),
      ],
    );
  }
}