import '../database_helper/data_fetcher.dart';
import '../models/area_model/area.dart';
import '../models/category_model/category.dart';
import '../models/favorite_model/favorite_shop.dart';
import '../models/product_model/product.dart';
import '../models/review_model/shop_review.dart';
import '../models/search_model/search.dart';
import '../models/shop_model/shop.dart';
import '../models/user_model/user.dart';

class GlobalData {
  static List<User> users = [];
  static List<Shop> shops = [];
  static List<Area> areas = [];
  static List<Category> categories = [];
  static List<Product> products = [];
  static List<FavoriteShop> favoriteShops = [];
  static List<Search> searches = [];
  static List<ShopReview> shopReviews = [];
}

void fetchDataAndStore() async {
  DataFetcher dataFetcher = DataFetcher();

  // Fetch data from DB
  List<User> users = await dataFetcher.fetchAllUsers();
  List<Shop> shops = await dataFetcher.fetchAllShops();
  List<Area> areas = await dataFetcher.fetchAllAreas();
  List<Category> categories = await dataFetcher.fetchAllCategories();
  List<Product> products = await dataFetcher.fetchAllProducts();
  List<FavoriteShop> favoriteShops = await dataFetcher.fetchAllFavoriteShops();
  List<Search> searches = await dataFetcher.fetchAllSearches();
  List<ShopReview> shopReviews = await dataFetcher.fetchAllShopReviews();

  // Store data in global variables
  GlobalData.users = users;
  GlobalData.shops = shops;
  GlobalData.areas = areas;
  GlobalData.categories = categories;
  GlobalData.products = products;
  GlobalData.favoriteShops = favoriteShops;
  GlobalData.searches = searches;
  GlobalData.shopReviews = shopReviews;

  print("Data fetched and stored successfully! ");
}
