import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:list_of_productions/enums/access_enum.dart';
import 'package:list_of_productions/enums/category_enum.dart';
import 'package:list_of_productions/enums/filter_enum.dart';
import 'package:list_of_productions/enums/sort_enum.dart';
import 'package:list_of_productions/enums/streaming_enum.dart';
import 'package:list_of_productions/models/production.dart';
import 'package:list_of_productions/services/filtering_services.dart';
import 'package:list_of_productions/services/sorting_services.dart';
import 'package:list_of_productions/services/storage_services.dart';
import 'package:list_of_productions/widgets/popup_menu_filtering.dart';
import 'package:list_of_productions/widgets/popup_menu_sorting.dart';
import 'package:list_of_productions/widgets/add_production_dialog.dart';
import 'package:list_of_productions/widgets/delete_productions_confirmation_dialog.dart';
import 'package:list_of_productions/widgets/production_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageServices storageServices = StorageServices();
  final SortingServices sortingServices = SortingServices();
  final FilteringServices filteringServices = FilteringServices();

  FilterEnum filter = FilterEnum.all;
  SortEnum sort = SortEnum.creationDate;
  bool ascending = true;

  CategoryEnum filterByCategory = CategoryEnum.absent;
  StreamingEnum filterByStreamingService = StreamingEnum.absent;
  AccessEnum filterByAccessMode = AccessEnum.absent;

  final Map<String, String?> error = {
    'sort': null,
    'filter': null,
  };

  List<Production> productionList = [];

  Production? deletedProduction;
  int? deletedProductionIndex;
  late Locale myLocale;

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      myLocale = Localizations.localeOf(context);
    });

    List<Production> renderedList = productionList;

    renderedList = switch (sort) {
      SortEnum.creationDate => ascending == true
          ? sortingServices.dateOfCreationAscending(productionList)
          : sortingServices.dateOfCreationDescending(productionList),
      SortEnum.watched => ascending == true
          ? sortingServices.watched(productionList)
          : sortingServices.unwatched(productionList),
      SortEnum.alphabeticalOrder => ascending == true
          ? sortingServices.alphabeticalOrderAscending(productionList)
          : sortingServices.alphabeticalOrderDescending(productionList),
      SortEnum.category => ascending == true
          ? sortingServices.categoryAscending(productionList)
          : sortingServices.categoryDescending(productionList),
      SortEnum.streaming => ascending == true
          ? sortingServices.streamingServiceAscending(productionList)
          : sortingServices.streamingServiceDescending(productionList),
      SortEnum.access => ascending == true
          ? sortingServices.accessModeAscending(productionList)
          : sortingServices.accessModeDescending(productionList),
    };

    renderedList = switch (filter) {
      FilterEnum.all => productionList,
      FilterEnum.watched => filteringServices.filterByWatched(productionList),
      FilterEnum.unwatched =>
        filteringServices.filterByUnwatched(productionList),
      FilterEnum.category =>
        filteringServices.filterByCategory(productionList, filterByCategory),
      FilterEnum.streaming => filteringServices.filterByStreamingService(
          productionList, filterByStreamingService),
      FilterEnum.access => filteringServices.filterByAccessMode(
          productionList, filterByAccessMode),
    };

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 220, 232, 255),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.homePageTitle),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.height * 0.002),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 3),
                height: 70.0,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 236, 241, 252),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(blurRadius: 5),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PopupMenuSorting(
                            sort: sort,
                            ascending: ascending,
                            onSelected: (value) {
                              setState(() {
                                if (sort == value) {
                                  ascending = !ascending;
                                  return;
                                }
                                ascending == false ? ascending = true : null;
                                sort = value as SortEnum;
                              });
                            }),
                        PopupMenuFiltering(
                          filter: filter,
                          onSelected: (value) {
                            if (value != FilterEnum.category &&
                                value != FilterEnum.streaming &&
                                value != FilterEnum.access) {
                              setState(() {
                                filter = value as FilterEnum;
                              });
                            }
                          },
                          filterByCategory: filterByCategory,
                          filterByStreamingService: filterByStreamingService,
                          filterByAccessMode: filterByAccessMode,
                          onSelectedByEnum: onSelectedByEnum,
                        )
                      ],
                    ),
                    Text(AppLocalizations.of(context)!.completedTitles(
                        productionList
                            .where((production) => production.watched == true)
                            .length,
                        productionList.length)),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 220, 232, 255),
                    ),
                    child: RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            spacing: 5.0,
                            children: [
                              for (Production production in renderedList)
                                ProductionItem(
                                  production: production,
                                  productionList: productionList,
                                  onChanged: (value) {
                                    setState(() {
                                      productionList
                                          .firstWhere((element) =>
                                              element == production)
                                          .watched = value!;
                                      storageServices.saveData(productionList);
                                    });
                                  },
                                  onDelete: onDelete,
                                  readListOfProductions: () => readData,
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 3),
                height: 70.0,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 236, 241, 252),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(blurRadius: 5),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: showDeleteProductionsConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.all(16),
                        fixedSize: const Size(135, 50),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.clearAll,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: showAddProductionDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.all(16),
                        fixedSize: const Size(135, 50),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.newTitle,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSelectedByEnum(Enum valueEnum, FilterEnum value) {
    setState(() {
      filter = value;
      switch (valueEnum) {
        case CategoryEnum _:
          filterByCategory = valueEnum;
          break;
        case StreamingEnum _:
          filterByStreamingService = valueEnum;
          break;
        case AccessEnum _:
          filterByAccessMode = valueEnum;
          break;
        case _:
          break;
      }
    });
  }

  void onDelete(Production production) {
    deletedProduction = production;
    deletedProductionIndex = productionList.indexOf(production);

    setState(() {
      productionList.remove(production);
      storageServices.saveData(productionList);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.titleRemoved(production.title),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.undo,
          onPressed: () {
            setState(() {
              productionList.insert(
                  deletedProductionIndex!, deletedProduction!);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.actionUndone,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  duration: const Duration(seconds: 2),
                ),
              );
            });
            storageServices.saveData(productionList);
          },
          textColor: Colors.blueAccent,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showAddProductionDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AddProductionDialog(
              productionList: productionList,
              readListOfProductions: () => readData,
              myLocale: myLocale,
            ));
  }

  void showDeleteProductionsConfirmationDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        if (productionList.isEmpty) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.clearAllConfirmation,
            ),
            content: Text(
              AppLocalizations.of(context)!.noTitles,
              textAlign: TextAlign.justify,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ],
          );
        } else {
          return DeleteProductionsConfirmationDialog(
            context: context,
            deleteAllProductions: deleteAllProductions,
            myLocale: myLocale,
          );
        }
      },
    );
  }

  void readData() {
    storageServices.readData().then((data) {
      setState(() {
        if (data != null) {
          // Decodifica a string JSON para uma lista de mapas
          List<dynamic> decodedData = json.decode(data);

          // Mapeia cada mapa para um objeto Production
          productionList =
              decodedData.map((item) => Production.fromJson(item)).toList();
        }
      });
    });
  }

  void deleteAllProductions() {
    setState(() {
      productionList.clear();
      storageServices.saveData(productionList);
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      filter = FilterEnum.all;
      sort = SortEnum.creationDate;
      ascending = true;
      filterByCategory = CategoryEnum.absent;
      filterByStreamingService = StreamingEnum.absent;
      filterByAccessMode = AccessEnum.absent;
      readData();
    });
    return null;
  }
}
