class DataModel{
  String? title;
  String? cover_image_url;
  double? price_in_dollar;
  int? quantity;


  DataModel({this.title,this.cover_image_url,this.price_in_dollar, this.quantity});

  DataModel.fromMap(Map<String,dynamic> json){

    title=json["title"];
    cover_image_url=json["cover_image_url"];
    price_in_dollar=json["price_in_dollar"];
    quantity= json["quantity"];

  }

  Map<String,dynamic> toMap(){
    return{
      'title':title,
      'cover_image_url':cover_image_url,
      'price_in_dollar':price_in_dollar,
      'quantity':quantity

    };
  }


}

