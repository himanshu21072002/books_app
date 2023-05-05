import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'listDataModel.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDatabase();
    }
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart (title TEXT PRIMARY KEY ,cover_image_url TEXT,price_in_dollar REAL,quantity INTEGER)');
  }

  Future<DataModel> insert(DataModel cart) async {
    print(cart.toMap());
    var dbClient = await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<DataModel>> getCartList()async{
    var dbClient = await db ;
    final List<Map<String , Object?>> queryResult =  await dbClient!.query('cart');
    return queryResult.map((e) => DataModel.fromMap(e)).toList();

  }

  Future<int> delete(String? id)async{
    var dbClient = await db ;
    return await dbClient!.delete(
        'cart',
        where: 'id = ?',
        whereArgs: [id]
    );
  }

}
