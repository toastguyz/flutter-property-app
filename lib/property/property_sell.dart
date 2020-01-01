import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_property_app/models/model_propertysell.dart';
import 'package:flutter_property_app/utils/color_utils.dart';
import 'package:flutter_property_app/utils/method_utils.dart';
import 'package:flutter_property_app/utils/network_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_property_app/main.dart';

class PropertySell extends StatefulWidget {
  final PropertySellModel sellModel;
  static const routeName = "/property-sell";

  PropertySell({this.sellModel});

  @override
  _PropertySellState createState() => _PropertySellState();
}

class _PropertySellState extends State<PropertySell> {
  static int currentPage = 0;
  PageController pageController =
      PageController(viewportFraction: 1, initialPage: currentPage);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController bedroomController = TextEditingController();
  TextEditingController bathroomController = TextEditingController();
  TextEditingController balconyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  int selected = 0;
  List<String> _imageFilesList = [];
  var isUploadingPost = false;
  var isEditInitialised = true;

  @override
  void didChangeDependencies() {
    if (widget.sellModel != null) {
      if (isEditInitialised) {
        addressController.text = widget.sellModel.sellAddress;
        cityController.text = widget.sellModel.sellCity;
        regionController.text = widget.sellModel.sellRegion;
        countryController.text = widget.sellModel.sellCountry;
        priceController.text = widget.sellModel.sellPrice;
        bedroomController.text = widget.sellModel.sellBedrooms;
        bathroomController.text = widget.sellModel.sellBathrooms;
        balconyController.text = widget.sellModel.sellBalconies;
        descriptionController.text = widget.sellModel.sellDescription;
        contactController.text = widget.sellModel.sellContact;
        selected = widget.sellModel.sellType;

        if (widget.sellModel.sellImages != null &&
            widget.sellModel.sellImages.length > 0) {
          _imageFilesList = widget.sellModel.sellImages;

          print("_imageFilesList : ${_imageFilesList.length}");
          print("_imageFilesList : ${_imageFilesList}");
        }

        isEditInitialised = false;
      }
    }

    super.didChangeDependencies();
  }

  _getLocation() async {
    try {
      Geolocator geolocator = Geolocator();
      Position currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);

      if (currentLocation != null) {
        print("country : ${placemark[0].country}");
        print("position : ${placemark[0].position}");
        print("locality : ${placemark[0].locality}");
        print("administrativeArea : ${placemark[0].administrativeArea}");
        print("postalCode : ${placemark[0].postalCode}");
        print("name : ${placemark[0].name}");
        print("subAdministrativeArea : ${placemark[0].subAdministrativeArea}");
        print("isoCountryCode : ${placemark[0].isoCountryCode}");
        print("subLocality : ${placemark[0].subLocality}");
        print("subThoroughfare : ${placemark[0].subThoroughfare}");
        print("thoroughfare : ${placemark[0].thoroughfare}");

        if (placemark[0] != null) {
          if (placemark[0].country.isNotEmpty) {
            countryController.text = placemark[0].country;
          }

          if (placemark[0].administrativeArea.isNotEmpty) {
            regionController.text = placemark[0].administrativeArea;
          }

          if (placemark[0].subAdministrativeArea.isNotEmpty) {
            cityController.text = placemark[0].subAdministrativeArea;
          }

          if (placemark[0].name.isNotEmpty) {
            addressController.text = placemark[0].name;
          }

          setState(() {});
        }
      }
    } on PlatformException catch (error) {
      print(error.message);
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        titleSpacing: 0,
        title: Text("Sell/Rent Property"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildLabel("PROPERTY TYPE"),
                    _buildPropertyTypesWidget(),
                    _buildLabel("PROPERTY PHOTOS"),
                    _buildPropertyPhotosWidget(),
                    _buildLabel("PROPERTY ADDRESS"),
                    _buildPropertyLocationWidget(),
                    _buildLabel("PRICE"),
                    _buildPriceWidget(),
                    _buildLabel("PROPERTY DETAILS"),
                    _buildPropertyDetailsWidget(),
                    _buildLabel("CONTACT DETAILS"),
                    _buildContactDetailsWidget(),
                    _buildLabel("OTHER DETAILS"),
                    _buildOtherDetailsWidget(),
                  ],
                ),
              ),
            ),
          ),
          _buildSubmitPostWidget(),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Text(
        label,
        style: TextStyle(color: TextLabelColor, fontSize: 11.0),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildPropertyTypesWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                selected = selected == 1 ? 0 : 1;
              });
            },
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.business,
                  size: 70,
                  color: selected == 1 ? Colors.red : UnselectedIconColor,
                ),
                Text(
                  "Apartment",
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                selected = selected == 2 ? 0 : 2;
              });
            },
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.home,
                  size: 70,
                  color: selected == 2 ? Colors.green : UnselectedIconColor,
                ),
                Text(
                  "Flat",
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                selected = selected == 3 ? 0 : 3;
              });
            },
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.landscape,
                  size: 70,
                  color: selected == 3 ? Colors.blue : UnselectedIconColor,
                ),
                Text(
                  "Plot/Land",
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyPhotosWidget() {
    return Container(
      color: Colors.white,
      height: 120.0,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Column(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _openImagePicker(context);
                  },
                  icon: Icon(Icons.camera_enhance),
                  color: Colors.grey,
                  iconSize: 65.0,
                ),
                Text(
                  "Add Photos",
                  style: TextStyle(fontSize: 13.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemCount: _imageFilesList.length,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      height: 80.0,
                      width: 80.0,
                      child: Stack(
                        children: <Widget>[
                          ClipOval(
                            child: _imageFilesList[index] != null &&
                                    _imageFilesList[index].isNotEmpty
                                ? checkForFileOrNetworkPath(
                                        _imageFilesList[index])
                                    ? fetchImageFromNetworkFileWithPlaceHolderWidthHeight(
                                        80.0, 80.0, _imageFilesList[index])
                                    /*Image.network(
                                        _imageFilesList[index],
                                        fit: BoxFit.cover,
                                        height: 80.0,
                                        width: 80.0,
                                      )*/
                                    : Image.file(
                                        File(_imageFilesList[index]),
                                        fit: BoxFit.cover,
                                        height: 80.0,
                                        width: 80.0,
                                      )
                                : Image.asset(
                                    "assets/images/transparent_placeholder.png",
                                    fit: BoxFit.cover,
                                    height: 80.0,
                                    width: 80.0,
                                  ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _imageFilesList.removeAt(index);
                              });
                            },
                            child: Container(
                              alignment: Alignment.topRight,
                              child: Image.asset(
                                "assets/images/cancel.png",
                                fit: BoxFit.fitHeight,
                                height: 20.0,
                                width: 20.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    "Select Image",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    _getImage(context, ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        size: 30.0,
                        color: themeColor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                      ),
                      Text(
                        "Use Camera",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: themeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    _getImage(context, ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.camera,
                        size: 30.0,
                        color: themeColor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                      ),
                      Text(
                        "Use Gallery",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: themeColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  _getImage(BuildContext context, ImageSource source) async {
    ImagePicker.pickImage(
      source: source,
      maxWidth: 400.0,
      maxHeight: 400.0,
    ).then((File image) async {
      if (image != null) {
        setState(() {
          _imageFilesList.add(image.path);
          print("_imageFile : ${image}");
          print("filePath : ${image.path}");
          print("fileURI : ${image.uri}");
          /*String filePath = image.path;
          Uri fileURI = image.uri;*/
        });
      }
    });
  }

  Widget _buildPropertyLocationWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _getLocation();
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  child: Icon(
                    Icons.my_location,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Text("Detect Property Location"),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: addressController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: "Address",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              validator: (String address) {
                if (address.isEmpty) {
                  return "Address field is required!!";
                }
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: cityController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: "City",
                labelStyle: TextStyle(color: Colors.grey),
              ),
              validator: (String city) {
                if (city.isEmpty) {
                  return "City field is required!!";
                }
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: regionController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: "Region (Optional)",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              validator: (String country) {
                if (country.isEmpty) {
                  return "Country field is required!!";
                }
              },
              controller: countryController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: "Country",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          validator: (String price) {
            if (price.isEmpty) {
              return "Price field is required!!";
            }
          },
          keyboardType: TextInputType.number,
          controller: priceController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: "Price",
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyDetailsWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              validator: (String bedrooms) {
                if (bedrooms.isEmpty) {
                  return "Bedroom field is required!!";
                }
              },
              controller: bedroomController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: "BedRoom(s)",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: bathroomController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: "BathRoom(s)",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: TextFormField(
              controller: balconyController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: "No. of Balconies",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          validator: (String contact) {
            if (contact.isEmpty) {
              return "Contact field is required!!";
            }
          },
          keyboardType: TextInputType.number,
          maxLength: 10,
          controller: contactController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            counterText: "",
            labelText: "Contact",
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherDetailsWidget() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          controller: descriptionController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: "Additional Property Description",
            labelStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitPostWidget() {
    return GestureDetector(
      onTap: () {
        _submitPropertySellPost();
      },
      child: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.only(top: 10.0),
        margin: EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: 50.0,
        child: Center(
          child: Text(
            isUploadingPost ? "Uploading..." : "Submit Post",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                letterSpacing: 2.0),
          ),
        ),
      ),
    );
  }

  _submitPropertySellPost() async {
    if (selected == 0) {
      final snackBar = SnackBar(content: Text("Select property type!!"));

      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }

    if (!_formKey.currentState.validate()) {
      return;
    }

    NetworkCheck networkCheck = NetworkCheck();
    networkCheck.checkInternet((isNetworkPresent) async {
      if (!isNetworkPresent) {
        final snackBar =
            SnackBar(content: Text("Please check your internet connection !!"));

        _scaffoldKey.currentState.showSnackBar(snackBar);
        return;
      } else {
        setState(() {
          isUploadingPost = true;
        });
      }
    });

    try {
      List<String> imagePaths = [];
      try {
        if (_imageFilesList != null && _imageFilesList.length > 0) {
          imagePaths = await uploadImage(_imageFilesList);
          print("imagePaths : ${imagePaths}");
          print("imagePaths : ${imagePaths.length}");
        }
      } catch (error) {
        print("uploadError : ${error.toString()}");
      }

      final propertySellReference =
          FirebaseDatabase.instance.reference().child("Property").child("Sell");
      print("_imageFilesList : ${_imageFilesList.length}");
      print("imagePaths : ${imagePaths.length}");

      String resourceID = propertySellReference.push().key;

      if (widget.sellModel == null || widget.sellModel.id == null) {
        await propertySellReference.child(resourceID).set({
          "id": resourceID,
          "sellType": selected,
          "sellImages":
              imagePaths != null && imagePaths.length > 0 ? imagePaths : "",
          "sellAddress": addressController.text,
          "sellCity": cityController.text,
          "sellRegion": regionController.text,
          "sellCountry": countryController.text,
          "sellPrice": priceController.text,
          "sellBathrooms": bathroomController.text,
          "sellBedrooms": bedroomController.text,
          "sellBalconies": balconyController.text,
          "sellContact": contactController.text,
          "sellDescription": descriptionController.text,
          "updatedAt": DateTime.now().toIso8601String(),
        });
      } else {
        await propertySellReference.child(widget.sellModel.id).update({
          "id": widget.sellModel.id,
          "sellType": selected,
          "sellImages":
              imagePaths != null && imagePaths.length > 0 ? imagePaths : "",
          "sellAddress": addressController.text,
          "sellCity": cityController.text,
          "sellRegion": regionController.text,
          "sellCountry": countryController.text,
          "sellPrice": priceController.text,
          "sellBathrooms": bathroomController.text,
          "sellBedrooms": bedroomController.text,
          "sellBalconies": balconyController.text,
          "sellContact": contactController.text,
          "sellDescription": descriptionController.text,
          "updatedAt": DateTime.now().toIso8601String(),
        });
      }

      setState(() {
        isUploadingPost = false;
      });

      var propertyName=bedroomController.text+ " BHK "+ getPropertyTypeById(selected) + " is for sale !!";
      var contact="Contact : ${contactController.text}";
      repeatNotification(propertyName,contact);

      Navigator.of(context).pop();
    } catch (error) {
      print("catch block : " + error.toString());

      setState(() {
        isUploadingPost = false;
      });
      final snackBar =
          SnackBar(content: Text("Something went wrong. please try again !!"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future<List<String>> uploadImage(List<String> imageFiles) async {
    List<String> filePaths = [];

    print("filePaths : ${filePaths}");
    for (int i = 0; i < imageFiles.length; i++) {
      if (checkForFileOrNetworkPath(imageFiles[i])) {
        filePaths.add(imageFiles[i]);
        continue;
      }
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("images/sell/${DateTime.now().toIso8601String()}");

      StorageUploadTask uploadTask = firebaseStorageRef.putFile(File(imageFiles[i]));
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String storagePath = await taskSnapshot.ref.getDownloadURL();
      filePaths.add(storagePath);
    }

    print("filePaths : ${filePaths}");
    return filePaths;
  }
}

/*CachedNetworkImage(
imageUrl: _imageFilesList.length == 0
? "file:///storage/emulated/0/Android/data/com.jaym.flutter_property_app/files/Pictures/scaled_Screenshot_20190927-114712.png"
    : "http://via.placeholder.com/200x150",
placeholder: (context, url) => CircularProgressIndicator(),
errorWidget: (context, url, error) => Icon(Icons.error),
imageBuilder: (context, imageProvider) => Container(
decoration: BoxDecoration(
image: DecorationImage(
image: imageProvider,
fit: BoxFit.cover,
colorFilter:
ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
),
),
),*/
