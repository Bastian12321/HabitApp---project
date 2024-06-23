import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioPage extends StatefulWidget {
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _filePath;
  double _currentPosition = 0;
  double _totalDuration = 0;
  String _currentTimeString = "00:00,00";
  String _totalTimeString = "00:00,00";

  @override
  void initState() {
    super.initState();
    _audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
          _currentPosition = 0;
          _currentTimeString = _formatDuration(Duration(milliseconds: 0));
        });
      }
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position.inMilliseconds.toDouble();
        _currentTimeString = _formatDuration(Duration(milliseconds: position.inMilliseconds));
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration?.inMilliseconds.toDouble() ?? 0;
        _totalTimeString = _formatDuration(duration ?? Duration.zero);
      });
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitsHundredths = (duration.inMilliseconds.remainder(1000) / 10).floor().toString().padLeft(2, '0');
    return '$twoDigitMinutes:$twoDigitsSeconds,$twoDigitsHundredths';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final bool isPermissionGranted = await _recorder.hasPermission();
    if (!isPermissionGranted) {
      print('Microphone permission not granted!');
      return;
    }
    
    setState(() {
      _currentPosition = 0;
      _currentTimeString = _formatDuration(const Duration(milliseconds: 0));
    });

    final directory = await getApplicationDocumentsDirectory();
    String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _filePath = '${directory.path}/$fileName';
    print('File path: $_filePath');

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      sampleRate: 44100,
      bitRate: 128000,
    );

    await _recorder.start(config, path: _filePath!);
    setState(() {
      _isRecording = true;
    });
    print('Recording started');
    print('');
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    setState(() {
      _isRecording = false;
    });
    print('Recording stopped');
    print('');
  }

  Future<void> _playRecording() async {
    if (_filePath != null && File(_filePath!).existsSync()) {
      await _audioPlayer.setFilePath(_filePath!);

      final duration = await _audioPlayer.duration;
      setState(() {
        _totalDuration = duration?.inMilliseconds.toDouble() ?? 0;
        _totalTimeString = _formatDuration(duration ?? Duration.zero);
      });


      await _audioPlayer.position;
      setState(() {
        _isPlaying = true;
      });

      print('Playing recording');
      print('current position: ${await _audioPlayer.position}');
      print('True: $_isPlaying');
      print('');
      
    } else {
      print('Nothing to play');
    }
  }

  Future<void> _pauseRecording() async {
    await _audioPlayer.pause();
    final position = await _audioPlayer.position;
    setState(() {
      _isPlaying = false;
      _currentPosition = position.inMilliseconds.toDouble();
      _currentTimeString = _formatDuration(position);
    });
    print('Paused recording');
    print('current position: $position');
    print('False: $_isPlaying');
    print('');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Notes'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isRecording
              ? Icons.mic
              : Icons.mic_none,
              size: 100,
              color: _isRecording ? Colors.red : Colors.blue,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRecording
                  ? null
                  : _startRecording,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Record'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRecording
                  ? _stopRecording
                  : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Stop'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: !_isRecording
              ? (_isPlaying ? _pauseRecording : _playRecording)
              : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(_isPlaying
              ? 'Pause'
              : 'Play'),
            ),
            Slider(
              value: _currentPosition.clamp(0.0, _totalDuration),
              max: _totalDuration,
              onChanged: (value) {
                setState(() {
                  _currentPosition = value;
                });
                _audioPlayer.seek(Duration(milliseconds: value.toInt()));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_currentTimeString),
                Text(_totalTimeString),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
