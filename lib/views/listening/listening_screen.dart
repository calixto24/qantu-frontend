import 'dart:async';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

import '../../core/theme/app_colors.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  bool isProcessing = false;
  bool isListening = false;
  double _currentDb = -160.0;

  final List<double> _baseHeights = [
    12.0,
    20.0,
    28.0,
    18.0,
    36.0,
    26.0,
    40.0,
    26.0,
    36.0,
    18.0,
    28.0,
    20.0,
    12.0,
  ];

  @override
  void initState() {
    super.initState();

    // Configuración del controlador: dura 3.5 segundos en ir de 0 a 100
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _startListening();
  }

  Future<void> _startListening() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.pcm16bits,
            sampleRate: 44100,
          ),
          path: '',
        );

        if (mounted) {
          setState(() {
            isListening = true;
          });
        }

        _amplitudeSubscription = _audioRecorder
            .onAmplitudeChanged(const Duration(milliseconds: 40))
            .listen((amplitude) {
              if (mounted) {
                setState(() {
                  _currentDb = amplitude.current;
                });
              }
            });
      }
    } catch (e) {
      debugPrint('Error al activar el micrófono: $e');
    }
  }

  Future<void> _stopListening() async {
    await _amplitudeSubscription?.cancel();
    await _audioRecorder.stop();
    if (mounted) {
      setState(() {
        isListening = false;
        _currentDb = -160.0;
      });
    }
  }

  void _toggleListening() {
    if (isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  // AL PRESIONAR "LISTO": Reinicia la animación a 0 y la arranca inmediatamente
  Future<void> _finishSpeaking() async {
    await _stopListening();
    if (!mounted) return;

    // Resetear obligatoriamente a 0
    _progressController.reset();

    setState(() {
      isProcessing = true;
    });

    // Arrancar la animación progresiva inmediatamente
    _progressController.forward();
  }

  @override
  void dispose() {
    _amplitudeSubscription?.cancel();
    _progressController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  double _getNormalizedVolume() {
    if (_currentDb < -55.0) return 0.1;
    double normalized = (_currentDb + 55.0) / 40.0;
    return normalized.clamp(0.1, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBE6DF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.neutral,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Hablar con Qantu',
                        style: textTheme.headlineMedium?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // CONTENIDO
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: isProcessing
                          ? _buildProcessingCard(textTheme)
                          : _buildListeningCard(textTheme),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // CARD 1: Escuchando
  Widget _buildListeningCard(TextTheme textTheme) {
    double volumeFactor = _getNormalizedVolume();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Te estoy escuchando',
            style: textTheme.headlineMedium?.copyWith(
              color: const Color(0xFFB23415),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Habla con claridad cerca del micrófono\ndel dispositivo.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.neutral.withOpacity(0.7),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 36),

          // Botón del micrófono
          GestureDetector(
            onTap: _toggleListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 60),
              width: 140 + (volumeFactor * 22),
              height: 140 + (volumeFactor * 22),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFCEFEA),
              ),
              child: Center(
                child: Container(
                  width: 105,
                  height: 105,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF7D2C4),
                  ),
                  child: Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isListening
                            ? const Color(0xFFB23415)
                            : AppColors.neutral.withOpacity(0.6),
                      ),
                      child: Icon(
                        isListening ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 36),

          // Ondas
          Container(
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(_baseHeights.length, (index) {
                double calculatedHeight = isListening
                    ? _baseHeights[index] * (volumeFactor * 2.5)
                    : 6.0;

                calculatedHeight = calculatedHeight.clamp(6.0, 44.0);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: 4.5,
                  height: calculatedHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC04828),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _finishSpeaking,
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: const Text('Terminé de hablar (Listo)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB23415),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
                textStyle: textTheme.labelLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CARD 2: Animación de carga progresiva
  Widget _buildProcessingCard(TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        // Garantizar lectura directa del valor de animación en tiempo real
        final double currentVal = _progressAnimation.value;
        final int percentage = (currentVal * 100).toInt();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comprendiendo tu voz',
                style: textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFFB23415),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Espere un momento por favor.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 40),

              // Círculo de carga animado
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFAF1EB),
                      ),
                      child: const Icon(
                        Icons.local_florist,
                        color: Color(0xFFB23415),
                        size: 28,
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: currentVal,
                        strokeWidth: 7,
                        strokeCap: StrokeCap.round,
                        backgroundColor: const Color(0xFFF3ECE6),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFF28132),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Barra horizontal animada
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: currentVal,
                      minHeight: 12,
                      backgroundColor: const Color(0xFFF3ECE6),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFF28132),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reconociendo',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.neutral.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFB23415),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
