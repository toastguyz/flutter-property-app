import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getPropertyTypeById(int index) {
  switch (index) {
    case 1:
      return "Apartment";
      break;
    case 2:
      return "Flat";
      break;
    case 3:
      return "Plot/Land";
      break;
  }
}

// check for web url expression
String urlExpression = r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?';
RegExp regExp = RegExp(urlExpression);

bool checkForFileOrNetworkPath(String path) {
  print("path ${path}");
  bool value = regExp.hasMatch(path);
  print("value : ${value}");
  return value;
}

String getDateFromDateTimeInSpecificFormat(DateFormat dateFormat, String date){
  DateTime mDateTime = DateTime.parse(date);
  return dateFormat.format(mDateTime);
}

Widget fetchImageFromNetworkFileWithPlaceHolder(String imageUrl){
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) => placeHolderAssetWidget(),
    errorWidget: (context, url, error) => placeHolderAssetWidget(),
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.transparent, BlendMode.colorBurn)),
      ),
    ),
  );
}

Widget placeHolderAssetWidget() {
  return Image.asset(
    'assets/images/bg_placeholder.jpg',
    fit: BoxFit.cover,
  );
}

Widget fetchImageFromNetworkFileWithPlaceHolderWidthHeight(double Width,double Height,String imageUrl){
  return CachedNetworkImage(
    imageUrl: imageUrl,
    height: Height,
    width: Width,
    placeholder: (context, url) => placeHolderAssetWithWidthHeightWidget(Width,Height),
    errorWidget: (context, url, error) => placeHolderAssetWithWidthHeightWidget(Width,Height),
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.transparent, BlendMode.colorBurn)),
      ),
    ),
  );
}

Widget placeHolderAssetWithWidthHeightWidget(double Width,double Height) {
  return Image.asset(
    'assets/images/bg_placeholder.jpg',
    fit: BoxFit.cover,
    height: Height,
    width: Width,
  );
}
