class PropertySellModel {
  String id;
  int sellType;
  List<String> sellImages;
  String sellAddress;
  String sellCity;
  String sellRegion;
  String sellCountry;
  String sellPrice;
  String sellBathrooms;
  String sellBedrooms;
  String sellBalconies;
  String sellDescription;
  String sellContact;
  String updatedAt;

  PropertySellModel(
      {this.id,
      this.sellType,
      this.sellImages,
      this.sellAddress,
      this.sellCity,
      this.sellRegion,
      this.sellCountry,
      this.sellPrice,
      this.sellBathrooms,
      this.sellBedrooms,
      this.sellBalconies,
      this.sellDescription,
      this.updatedAt});

  PropertySellModel.fromJson(var value) {
    this.id = value["id"];
    this.sellType = value["sellType"];
    this.sellAddress = value["sellAddress"];
    this.sellCity = value["sellCity"];
    this.sellRegion = value["sellRegion"];
    this.sellCountry = value["sellCountry"];
    this.sellPrice = value["sellPrice"];
    this.sellBathrooms = value["sellBathrooms"];
    this.sellBedrooms = value["sellBedrooms"];
    this.sellBalconies = value["sellBalconies"];
    this.sellDescription = value["sellDescription"];
    this.sellContact = value["sellContact"];
    this.updatedAt = value["updatedAt"];

    this.sellImages = [];
    try {
      List<String> data = value["sellImages"].cast<String>();
      for (int i = 0; i < data.length; i++) {
        this.sellImages.add(data[i]);
      }
    } catch (error) {
      this.sellImages = [];
    }
  }
}
