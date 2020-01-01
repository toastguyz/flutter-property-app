import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_property_app/models/model_propertysell.dart';
import 'package:flutter_property_app/property/property_details.dart';
import 'package:flutter_property_app/property/property_sell.dart';
import 'package:flutter_property_app/utils/method_utils.dart';
import 'package:flutter_property_app/utils/network_utils.dart';

class PropertyListing extends StatefulWidget {
  @override
  _PropertyListingState createState() => _PropertyListingState();
}

class _PropertyListingState extends State<PropertyListing> {
  bool isFetching = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<PropertySellModel> propertySellList = [];

  @override
  void initState() {
    super.initState();

    fetchSellPropertyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Property Listing"),
      ),
      body: isFetching
          ? Center(child: CircularProgressIndicator())
          : _buildPropertyListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, PropertySell.routeName);
        },
        heroTag: null,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPropertyListWidget() {
    if (propertySellList == null || propertySellList.length == 0) {
      return Center(
        child: Text(
          "No data found!!",
          style: TextStyle(fontSize: 20),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 5.0),
      itemCount: propertySellList.length,
      itemBuilder: (BuildContext context, int index) {
        var sellModel = propertySellList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PropertyDetails(sellModel)));
          },
          child: Card(
            margin: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Container(
              height: 120,
              child: Row(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0)),
                      child: _buildImagewidget(sellModel)),
                  Expanded(
                    child: _buildPropertyInfoWidget(sellModel),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagewidget(PropertySellModel sellModel) {
    return Hero(
      tag: sellModel.id,
      child: Container(
        height: 120.0,
        width: 120.0,
        child: sellModel.sellImages == null ||
                sellModel.sellImages.length == 0 ||
                sellModel.sellImages[0].isEmpty
            ? placeHolderAssetWidget()
            : fetchImageFromNetworkFileWithPlaceHolder(sellModel.sellImages[0]),
        /*CachedNetworkImage(
                imageUrl: sellModel.sellImages[0],
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
              ),*/
      ),
    );
  }

  Widget _buildPropertyInfoWidget(PropertySellModel sellModel) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
              child: Text(
                "Rs. ${sellModel.sellPrice}",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                child: Text(
                    "${sellModel.sellBedrooms} BHK ${getPropertyTypeById(sellModel.sellType)}")),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
              child: Text(sellModel.sellCity),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.phone,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(sellModel.sellContact),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  fetchSellPropertyData() async {
    NetworkCheck networkCheck = NetworkCheck();
    networkCheck.checkInternet((isNetworkPresent) async {
      if (!isNetworkPresent) {
        final snackBar = SnackBar(content: Text("Please check your internet connection !!"));

        _scaffoldKey.currentState.showSnackBar(snackBar);
        return;
      } else {
        setState(() {
          isFetching = true;
        });
      }
    });

    try {
      final propertySellReference = FirebaseDatabase.instance.reference().child("Property").child("Sell");

      propertySellReference.onValue.listen((Event event) {
        propertySellList = [];
        if (event.snapshot.value != null) {
          print("value: ${event.snapshot}");
          print("value: ${event.snapshot.key}");
          print("value: ${event.snapshot.value}");
          for (var value in event.snapshot.value.values) {
            print("valueData : ${value}");
            propertySellList.add(PropertySellModel.fromJson(value));
          }
        }

        print("propertySellList : ${propertySellList}");
        print("propertySellList : ${propertySellList.length}");
        setState(() {
          isFetching = false;
        });
      });
    } catch (error) {
      print("catch block : " + error.toString());

      setState(() {
        isFetching = false;
      });
    }
  }
}
