import 'package:watchlist_plus/models/production.dart';

class SortingServices {
  List<Production> dateOfCreationAscending(List<Production> productionList) {
    productionList.sort((a, b) => a.date.compareTo(b.date));
    return productionList;
  }

  List<Production> dateOfCreationDescending(List<Production> productionList) {
    productionList.sort((a, b) => b.date.compareTo(a.date));
    return productionList;
  }

  List<Production> alphabeticalOrderAscending(List<Production> productionList) {
    productionList
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return productionList;
  }

  List<Production> alphabeticalOrderDescending(List<Production> productionList) {
    productionList
        .sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    return productionList;
  }

  List<Production> watched(List<Production> productionList) {
    productionList.sort((a, b) {
      if (!a.watched && b.watched) {
        return 1;
      } else if (a.watched && !b.watched) {
        return -1;
      } else {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });
    return productionList;
  }

  List<Production> unwatched(List<Production> productionList) {
    productionList.sort((a, b) {
      if (a.watched && !b.watched) {
        return 1;
      } else if (!a.watched && b.watched) {
        return -1;
      } else {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });
    return productionList;
  }

  List<Production> categoryAscending(List<Production> productionList) {
    productionList.sort((a, b) => a.category
        .toString()
        .toLowerCase()
        .compareTo(b.category.toString().toLowerCase()));
    return productionList;
  }

  List<Production> categoryDescending(List<Production> productionList) {
    productionList.sort((a, b) => b.category
        .toString()
        .toLowerCase()
        .compareTo(a.category.toString().toLowerCase()));
    return productionList;
  }

  List<Production> streamingServiceAscending(List<Production> productionList) {
    productionList.sort((a, b) => a.streaming.first
        .toString()
        .toLowerCase()
        .compareTo(b.streaming.first.toString().toLowerCase()));
    return productionList;
  }

  List<Production> streamingServiceDescending(List<Production> productionList) {
    productionList.sort((a, b) => b.streaming.first
        .toString()
        .toLowerCase()
        .compareTo(a.streaming.first.toString().toLowerCase()));
    return productionList;
  }

  List<Production> accessModeAscending(List<Production> productionList) {
    productionList.sort((a, b) => a.streaming.first
        .toString()
        .split(' - ')[1]
        .toLowerCase()
        .compareTo(b.streaming.first.toString().split(' - ')[1].toLowerCase()));
    return productionList;
  }

  List<Production> accessModeDescending(List<Production> productionList) {
    productionList.sort((a, b) => b.streaming.first
        .toString()
        .split(' - ')[1]
        .toLowerCase()
        .compareTo(a.streaming.first.toString().split(' - ')[1].toLowerCase()));
    return productionList;
  }
}
