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
      if(event.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
          _currentPosition = 0;
        });
      }
    });

    // Adding listener to update _currentPosition
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position.inMilliseconds.toDouble() / 1000; // Convert to seconds with fraction
        _currentTimeString = _formatDuration(Duration(milliseconds: position.inMilliseconds));
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration!.inMicroseconds.toDouble() / 1000 ?? 0; // Convert to seconds with fraction
        _totalTimeString = _formatDuration(duration ?? Duration.zero);
      });
    });
  }

  // Helper method to format duration as 'mm:ss'
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitsHundredths = twoDigits((duration.inMilliseconds.remainder(1000) / 10).round());
    return '$twoDigitMinutes:$twoDigitsSeconds,$twoDigitsHundredths';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    //_recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final bool isPermissionGranted = await _recorder.hasPermission();
    if (!isPermissionGranted) {
      print('Microphone permission granted!');
      return;
    } else {
      _currentPosition = 0;
    }
    
    final directory = await getApplicationDocumentsDirectory();
    // Generate a unique file name using the current timestamp
    String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _filePath = '${directory.path}/$fileName';
    print('File path: $_filePath');

    // Define the configuration for the recording
    const config = RecordConfig(
      // Specify the format, encoder, sample rate, etc., as needed
      encoder: AudioEncoder.aacLc, // For example, using AAC codec
      sampleRate: 44100, // Sample rate
      bitRate: 128000, // Bit rate
    );

    // Start recording to file with the specified configuration
    await _recorder.start(config, path: _filePath!);
    setState(() {
      _isRecording = true;
    });
    print('Recording started');
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    setState(() {
      _isRecording = false;
    });
    print('Recording stoppped');
  }

  Future<void> _playRecording() async {
    if (_filePath != null && File(_filePath!).existsSync()) {
      await _audioPlayer.setFilePath(_filePath!);
      final duration = await _audioPlayer.duration;
      print('Playing recording');
      setState(() {
        _totalDuration = duration?.inSeconds.toDouble() ?? 0;
      });

      _audioPlayer.playbackEventStream.listen((event) {
        if(event.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _currentPosition = 0;
          });
        }
      });
      // Seeking to current position before starting playback
      await _audioPlayer.seek(Duration(seconds: _currentPosition.toInt()));
      await _audioPlayer.play();

      setState(() {
        _isPlaying = true;
      });
    } else {
      print('Nothing to play');
    }
  }

  Future<void> _pauseRecording() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
    print('Paused recording');
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
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
              child: Text(_isPlaying ? 'Pause' : 'Play'),
            ),
            Slider(
              value: _currentPosition,
              max: _totalDuration,
              onChanged: (value) {
                setState(() {
                  _currentPosition = value;
                });
                _audioPlayer.seek(Duration(milliseconds: (value * 1000).toInt()));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_currentTimeString),
                Text(_totalTimeString),
              ],
            )
          ],
        ),
      ),
    );
  }
}
