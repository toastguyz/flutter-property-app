import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_property_app/models/model_propertysell.dart';
import 'package:flutter_property_app/property/property_sell.dart';
import 'package:flutter_property_app/utils/color_utils.dart';
import 'package:flutter_property_app/utils/method_utils.dart';
import 'package:intl/intl.dart';

class PropertyDetails extends StatefulWidget {
  static const routeName = "/property-details";
  final PropertySellModel sellModel;

  PropertyDetails(this.sellModel);

  @override
  State<StatefulWidget> createState() {
    return PropertyDetailsState();
  }
}

class PropertyDetailsState extends State<PropertyDetails> {
  int currentView = 1;
  var dateFormat = DateFormat("dd MMM, yyyy");

  @override
  Widget build(BuildContext context) {
    final propertySellDate = getDateFromDateTimeInSpecificFormat(dateFormat, widget.sellModel.updatedAt);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBarWidget(),
          _buildSliverListBodyWidget(propertySellDate),
        ],
      ),
    );
  }

  Widget _buildSliverAppBarWidget() {
   return SliverAppBar(
      backgroundColor: themeColor,
      pinned: true,
      titleSpacing: 0.0,
      expandedHeight: MediaQuery.of(context).size.height * 0.3,
      flexibleSpace: FlexibleSpaceBar(
        title: Text("Rs. ${widget.sellModel.sellPrice}"),
        background: Hero(
          tag: widget.sellModel.id,
          child: widget.sellModel.sellImages != null &&
                  widget.sellModel.sellImages.length > 0
              ? Stack(
                  children: <Widget>[
                    PageView.builder(
                      onPageChanged: (view) {
                        setState(() {
                          this.currentView = view + 1;
                        });
                      },
                      itemCount: widget.sellModel.sellImages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildImagewidget(
                            widget.sellModel.sellImages[index]);
                      },
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        color: Colors.black,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 3.0, left: 5.0, bottom: 3.0, right: 3.0),
                              child: Text(
                                "${this.currentView}/${widget.sellModel.sellImages.length}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 3.0, right: 5.0, bottom: 3.0),
                              child: Icon(
                                Icons.wallpaper,
                                color: Colors.white,
                                size: 18.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : placeHolderAssetWidget(),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertySell(
                  sellModel: widget.sellModel,
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSliverListBodyWidget(String postedDate) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          padding: EdgeInsets.only(top: 20.0),
          width: double.infinity,
          child: Text(
            getPropertyTypeById(widget.sellModel.sellType),
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.bold, color: themeColor),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          width: double.infinity,
          child: Text(
            "Posted on ${postedDate}",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(fontSize: 16.0, color: themeColor),
          ),
        ),
        _buildPropertyDetailsWidget(),
        PropertyAddressView("Address", widget.sellModel.sellAddress),
        Divider(
          height: 1,
          color: Colors.transparent,
        ),
        PropertyAddressView("City", widget.sellModel.sellCity),
        Divider(
          height: 1,
          color: Colors.transparent,
        ),
        PropertyAddressView("Country", widget.sellModel.sellCountry),
        Divider(
          height: 1,
          color: Colors.transparent,
        ),
        PropertyAddressView("Contact", widget.sellModel.sellContact),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          width: double.infinity,
          child: Text(
            "Description",
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
                fontSize: 16.0, fontWeight: FontWeight.bold, color: themeColor),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          width: double.infinity,
          child: Text(
            widget.sellModel.sellDescription.isEmpty
                ? "-"
                : widget.sellModel.sellDescription,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(fontSize: 16.0, color: themeColor),
          ),
        ),
      ]),
    );
  }

  Widget _buildPropertyDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                Icons.hotel,
                size: 20.0,
              ),
              Text("${widget.sellModel.sellBedrooms} BHK Bedroom"),
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.event_seat,
                size: 20.0,
              ),
              Text("${widget.sellModel.sellBathrooms} Bathroom"),
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.burst_mode,
                size: 20.0,
              ),
              Text("${widget.sellModel.sellBalconies} Balcony"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagewidget(String imageUrl) {
    return Container(
      child: imageUrl.length == 0 || imageUrl.isEmpty
          ? placeHolderAssetWidget()
          : fetchImageFromNetworkFileWithPlaceHolder(imageUrl),
      /*CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) => placeHolderAssetWidget(),
              errorWidget: (context, url, error) => placeHolderAssetWidget(),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.transparent, BlendMode.overlay)),
                ),
              ),
            ),*/
    );
  }

  Widget PropertyAddressView(String label, String Value) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.5),
            child: Text(
              label,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.5),
            child: Text(
              Value,
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
