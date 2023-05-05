class DataModel{
  String? title;
  String? cover_image_url;
  double? price_in_dollar;
  double? finalPrice;
  int? quantity;
  int? id;


  DataModel({this.title,this.cover_image_url,this.price_in_dollar, this.quantity,this.id,this.finalPrice});

  DataModel.fromMap(Map<String,dynamic> json){

    title=json["title"];
    cover_image_url=json["cover_image_url"];
    price_in_dollar=json["price_in_dollar"];
    quantity= json["quantity"];
    id=json['id'];
    finalPrice=json['finalPrice'];

  }

  Map<String,dynamic> toMap(){
    return{
      'title':title,
      'cover_image_url':cover_image_url,
      'price_in_dollar':price_in_dollar,
      'quantity':quantity,
      'id':id,
      'finalPrice':finalPrice
    };
  }


}

