class OrderFunctions {
  static separateItemIDs(orderIDs) {
    List<String> separateItemIDsList = [], defaultItemsList = [];

    defaultItemsList = List<String>.from(orderIDs);

    for (int i = 0; i < defaultItemsList.length; i++) {
      String item = defaultItemsList[i].toString();
      var pos = item.lastIndexOf(":");
      String getItemID = (pos != -1) ? item.substring(0, pos) : item;
      separateItemIDsList.add(getItemID);
    }
    return separateItemIDsList;
  }

  static separateItemQtys(orderIDs) {
    List<String> separateItemQtysList = [], defaultItemsList = [];

    defaultItemsList = List<String>.from(orderIDs);

    for (int i = 1; i < defaultItemsList.length; i++) {
      String item = defaultItemsList[i].toString();
      List<String> listItemCharacters = item.split(":").toList();
      int qtyToNumber = int.parse(listItemCharacters[1].toString());

      separateItemQtysList.add(qtyToNumber.toString());
    }
    return separateItemQtysList;
  }
}
