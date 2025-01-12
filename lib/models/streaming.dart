import 'package:list_of_productions/enums/access_enum.dart';
import 'package:list_of_productions/enums/streaming_enum.dart';

class Streaming {
  final StreamingEnum streamingService;
  final AccessEnum accessMode;

  const Streaming({
    required this.streamingService,
    required this.accessMode,
  });

  // Converte o objeto Streaming para um mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'streamingService': streamingService.name,
      'accessMode': accessMode.name,
    };
  }

  // Converte um mapa (JSON) para um objeto Streaming
  factory Streaming.fromJson(Map<String, dynamic> json) {
    return Streaming(
      streamingService:
          StreamingEnum.values.firstWhere((e) => e.name == json['streamingService']),
      accessMode: AccessEnum.values.firstWhere((e) => e.name == json['accessMode']),
    );
  }

  @override
  String toString() {
    return '$streamingService - $accessMode';
  }
}
