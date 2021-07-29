import 'package:finsim/models/expenditure.dart';

class Asset {
  int id = 0;
  String name = '';
  Expenditure expenditure = Expenditure();

  Map<String, Object> toMap() {
    return {
      //Not passing id in Map so that Sqflite will auto generate new id
      'name': this.name,
      'expenditure_id': expenditure.id,
    };
  }

  static Asset fromMap(Map<String, dynamic> assetMap) {
    var asset = Asset();
    asset.id = assetMap['id'];
    asset.name = assetMap['name'];
    //Expenditure already set and mapped
    return asset;
  }
}
