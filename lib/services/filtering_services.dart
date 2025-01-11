import 'package:list_of_productions/enums/access_enum.dart';
import 'package:list_of_productions/enums/category_enum.dart';
import 'package:list_of_productions/enums/streaming_enum.dart';
import 'package:list_of_productions/models/production.dart';

class FilteringServices {
  List<Production> filterByWatched(List<Production> productionList) {
    return productionList.where((production) => production.watched).toList();
  }

  List<Production> filterByUnwatched(List<Production> productionList) {
    return productionList.where((production) => !production.watched).toList();
  }

  List<Production> filterByCategory(List<Production> productionList, CategoryEnum category) {
    return productionList.where((production) => production.category == category).toList();
  }

  List<Production> filterByStreamingService(
      List<Production> productionList, StreamingEnum streamingService) {
    return productionList
        .where((production) => production.streaming
            .any((streaming) => streaming.streamingService == streamingService))
        .toList();
  }

  List<Production> filterByAccessMode(List<Production> productionList, AccessEnum accessMode) {
    return productionList
        .where((production) => production.streaming
            .any((streaming) => streaming.accessMode == accessMode))
        .toList();
  }
}
