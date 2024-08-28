import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  List<LocaleName> locales = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    locales = await _speechToText.locales();
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, localeId: 'en_US');
    WakelockPlus.enable();
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    WakelockPlus.disable();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    // If listening is active, show the recognized words
                    _speechToText.isListening
                        ? _lastWords
                        : _speechEnabled
                            ? 'Tap the microphone to start listening...'
                            : 'Speech not available',
                    textAlign: TextAlign.center, // Center the text horizontally
                    style: const TextStyle(
                      fontSize: 24, // Increase the font size
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Container(
          height: 60.0,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Locale Selector Button
              IconButton(
                icon: const Icon(Icons.language),
                onPressed: () {
                  // Implement your locale selection logic here
                },
              ),
              // Microphone Button (Centered)
              FloatingActionButton(
                onPressed: _speechToText.isNotListening
                    ? _startListening
                    : _stopListening,
                tooltip: 'Listen',
                child: Icon(
                    _speechToText.isNotListening ? Icons.mic_off : Icons.mic),
              ),
              // Keyboard Button
              IconButton(
                icon: const Icon(Icons.keyboard),
                onPressed: () {
                  // Implement your typing interface logic here
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
