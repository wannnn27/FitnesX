// lib/view/workout_tracker/workout_in_progress_view.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/view/home/finished_workout_view.dart';

class WorkoutInProgressView extends StatefulWidget {
  final List exercises;
  const WorkoutInProgressView({super.key, required this.exercises});

  @override
  State<WorkoutInProgressView> createState() => _WorkoutInProgressViewState();
}

class _WorkoutInProgressViewState extends State<WorkoutInProgressView> {
  late PageController _pageController;
  VideoPlayerController? _videoController;
  int _currentExerciseIndex = 0;
  Timer? _timer;
  int _countdown = 0;
  bool _isPaused = false;
  final Stopwatch _stopwatch = Stopwatch();
  int _secondsPerExercise = 0;
  
  // State baru untuk memantau status buffer
  bool _isBuffering = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.exercises.isNotEmpty) {
      _secondsPerExercise = (30 * 60) ~/ widget.exercises.length;
      _changeExercise(0, isInitial: true);
      _stopwatch.start();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoController?.dispose();
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer(String videoUrl) async {
    await _videoController?.dispose();
    
    if (videoUrl.startsWith('http://')) {
      videoUrl = videoUrl.replaceFirst('http://', 'https://');
    }

    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    
    // Tambahkan listener untuk memantau status buffering
    _videoController!.addListener(() {
      if (!mounted) return;
      final bool isBuffering = _videoController!.value.isBuffering;
      if (_isBuffering != isBuffering) {
        setState(() {
          _isBuffering = isBuffering;
        });
      }
    });

    try {
      await _videoController!.initialize();
      if (!mounted) return;
      setState(() {
        _videoController!.setLooping(true);
        if (!_isPaused) _videoController!.play();
      });
    } catch (e) {
      print("Error memuat video: $e");
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (_isPaused) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        _goToNextExercise();
      }
    });
  }

  void _changeExercise(int newIndex, {bool isInitial = false}) {
    if (newIndex >= widget.exercises.length) {
      _timer?.cancel();
      _videoController?.dispose();
      _stopwatch.stop();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => FinishedWorkoutView(
              exercisesDone: widget.exercises.length,
              duration: _stopwatch.elapsed,
              caloriesBurned: (widget.exercises.length * 7.5),
            ),
          ),
        );
      }
      return;
    }
    
    final currentExercise = widget.exercises[newIndex];
    final videoUrl = currentExercise['video_url'] as String;

    setState(() {
      _currentExerciseIndex = newIndex;
      _isBuffering = true;
      _isPaused = false;
      _countdown = _secondsPerExercise;
    });
    
    _initializeVideoPlayer(videoUrl).then((_) {
        _startTimer();
    });
  }

  void _togglePausePlay() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _timer?.cancel();
        _videoController?.pause();
        _stopwatch.stop();
      } else {
        _videoController?.play();
        _startTimer();
        _stopwatch.start();
      }
    });
  }

  void _goToNextExercise() => _changeExercise(_currentExerciseIndex + 1);
  void _goToPreviousExercise() => _changeExercise(_currentExerciseIndex - 1);

  @override
  Widget build(BuildContext context) {
    if (widget.exercises.isEmpty) {
      return const Scaffold(body: Center(child: Text("Tidak ada latihan.")));
    }
    
    final currentExercise = widget.exercises[_currentExerciseIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                currentExercise['title'].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: (_videoController?.value.isInitialized ?? false)
                      ? AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: VideoPlayer(_videoController!)
                              ),
                              // Tampilkan indikator loading HANYA saat buffering
                              if (_isBuffering)
                                CircularProgressIndicator(color: TColor.white.withOpacity(0.8)),
                            ],
                          ),
                        )
                      : CircularProgressIndicator(color: TColor.primaryColor1),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Text(
                currentExercise['description'].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.gray, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Column(
                children: [
                  Text(
                    '${(_countdown ~/ 60).toString().padLeft(2, '0')}:${(_countdown % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: (_currentExerciseIndex + 1) / widget.exercises.length,
                    backgroundColor: TColor.lightGray,
                    valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _currentExerciseIndex > 0 ? _goToPreviousExercise : null,
                    icon: const Icon(Icons.skip_previous, size: 40),
                    color: _currentExerciseIndex > 0 ? TColor.gray : Colors.grey.shade300,
                  ),
                  IconButton(
                    onPressed: _togglePausePlay,
                    icon: Icon(
                      _isPaused ? Icons.play_circle_filled : Icons.pause_circle_filled,
                      size: 60,
                      color: TColor.primaryColor1,
                    ),
                  ),
                  IconButton(
                    onPressed: _goToNextExercise,
                    icon: const Icon(Icons.skip_next, size: 40),
                    color: TColor.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}