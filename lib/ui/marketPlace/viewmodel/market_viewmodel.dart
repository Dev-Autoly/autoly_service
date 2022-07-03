import 'dart:convert';

import 'package:autoly_service/ui/marketPlace/model/order.dart';
import 'package:autoly_service/ui/marketPlace/model/product.dart';
import 'package:autoly_service/ui/marketPlace/model/user.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

enum OrderStatus {
  pending,
  processing,
  completed,
}

class MarketViewModel extends BaseViewModel {
  List<Product> allProducts = [];
  List<Order> allOrders = [];
  List<Order> filteredOrdersWithServiceProvider = [];
  bool isBusy = true;
  bool _isLoading = false;
  User _currentUser;
  bool _isCheckingOrders = true;
  SharedPreferences localStorage;
  String token = '';
  String id = '';
  List<Order> allMatchingOrders = [];
  bool _isUpdatingOrder = false;


  void setCurrentUser(User currentUser) {
    _currentUser = currentUser;
    notifyListeners();
  }

  User get currentUser => _currentUser;

  bool get loading => _isLoading;

  bool get checkingOrders => _isCheckingOrders;

  bool get updatingOrder => _isUpdatingOrder;

  bool setLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  bool setCheckingOrders() {
    _isCheckingOrders = !_isCheckingOrders;
    notifyListeners();
  }

  bool setUpdatingOrder() {
    _isUpdatingOrder = !_isUpdatingOrder;
    notifyListeners();
  }

  Future<void> initData(String filterData) async {
    // try to call your api
    // await login(email: "mohamed.ahmed8902@gmail.com", password: "testuser123#");
    //  await getAllProducts();
    print("scan result 1 is $filterData");
    await getAllOrders(filterData);
  }

  void changeBusyState(bool value) {
    isBusy = value;
    notifyListeners();
  }

  Future<void> getAllProducts() async {
    String username = 'ck_b7eba9916a83584a70889381b9f287d80e1e0ad1';
    String password = 'cs_ede70fc67aa49b14d1a4331ea069c59ddce2e8f8';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    var headers = {
      'Authorization':
          'Basic Y2tfYjdlYmE5OTE2YTgzNTg0YTcwODg5MzgxYjlmMjg3ZDgwZTFlMGFkMTpjc19lZGU3MGZjNjdhYTQ5YjE0ZDFhNDMzMWVhMDY5YzU5ZGRjZTJlOGY4'
    };

    try {
      var response = await http.get(
          Uri.parse('https://autoly.io/shop/wp-json/wc/v3/products'),
          headers: headers
          // headers: <String, String>{
          //   'content-type': 'application/json',
          //   'accept': 'application/json',
          //   'authorization': basicAuth},
          );
      if (response.statusCode == 200) {
        print('products list data is ${response.body}');
        allProducts = productFromJson(response.body);
        print('products length is ${allProducts.length}');
        changeBusyState(false);
        notifyListeners();
      } else {
        print('response is: $response');
        changeBusyState(false);
        notifyListeners();
      }
    } catch (e) {
      print('Error:${e.toString()}');
      changeBusyState(false);
      notifyListeners();
    }
  }

  Future<void> getAllOrders(String scanResult) async {
    allOrders.clear();
    await initShared();
    print('id is $id');
    print('token is $token');
    String username = 'ck_b7eba9916a83584a70889381b9f287d80e1e0ad1';
    String password = 'cs_ede70fc67aa49b14d1a4331ea069c59ddce2e8f8';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    var headers = {
      'Authorization':
          'Basic Y2tfYjdlYmE5OTE2YTgzNTg0YTcwODg5MzgxYjlmMjg3ZDgwZTFlMGFkMTpjc19lZGU3MGZjNjdhYTQ5YjE0ZDFhNDMzMWVhMDY5YzU5ZGRjZTJlOGY4'
    };

    try {
      var response = await http.get(
          // Uri.parse('https://autoly.io/shop/wp-json/wc/v3/orders/?customer=$id'),
          // Uri.parse('https://autoly.io/shop/wp-json/wc/v3/orders/?customer=2'),
          Uri.parse('https://autoly.io/shop/wp-json/wc/v3/orders'),
          headers: headers
          // headers: <String, String>{
          //   'content-type': 'application/json',
          //   'accept': 'application/json',
          //   'authorization': basicAuth},
          );
      if (response.statusCode == 200) {
        print('orders list data is ${response.body}');
        allOrders = orderFromJson(response.body);
        print('orders length is ${allOrders.length}');
        // filtering process
        filteredOrdersWithServiceProvider.clear();
        if (allOrders.isNotEmpty) {
          List<OrderMetaDatum> orderMetaDatum = [];
          for (int i = 0; i < allOrders.length; i++) {
            orderMetaDatum = allOrders[i].metaData;
            for (int j = 0; j < orderMetaDatum.length; j++) {
              if (orderMetaDatum[j].key == "service_provider" &&
                  orderMetaDatum[j].value == id) {
                filteredOrdersWithServiceProvider.add(allOrders[i]);
              }
            }
          }
        }
        // for(int i=0; i<allOrders.length; i++){
        //   if(allOrders[i].metaData.)
        // }
        // filteredOrdersWithServiceProvider
        changeBusyState(false);
        print("scan result 2 is $scanResult");
        filteringOrders(scanResult);
        notifyListeners();
      } else {
        print('response is: $response');
        changeBusyState(false);
        notifyListeners();
      }
    } catch (e) {
      print('Error:${e.toString()}');
      changeBusyState(false);
      notifyListeners();
    }
  }

  Future<void> updateOrder(int orderId, OrderStatus orderStatus) async {
    setUpdatingOrder();
    await initShared();
    String currentStatus = "";
    switch (orderStatus) {
      case OrderStatus.pending:
        currentStatus = "processing";
        break;
      case OrderStatus.processing:
        currentStatus = "completed";
        break; //
      case OrderStatus.completed:
        currentStatus = "completed";
        break;
    }

    String username = 'ck_b7eba9916a83584a70889381b9f287d80e1e0ad1';
    String password = 'cs_ede70fc67aa49b14d1a4331ea069c59ddce2e8f8';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    // var headers = {
    //   // 'content-type': 'application/json',
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer $token',
    //   // 'Authorization': 'Basic $token',
    //   // 'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYXV0b2x5LmlvXC9zaG9wIiwiaWF0IjoxNjU1MzYxMzIwLCJuYmYiOjE2NTUzNjEzMjAsImV4cCI6MTY1NTk2NjEyMCwiZGF0YSI6eyJ1c2VyIjp7ImlkIjozMSwiZGV2aWNlIjoiIiwicGFzcyI6IjBiMGU1ZDI5YTEwYzRmMzdmNmE1MGY0ODE1OTE3OTE0In19fQ.dTfqelM3eGCXeFGj-EKazX937WeIr9bExzyjpzmd2tA}',
    //   // 'Authorization': 'Basic eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYXV0b2x5LmlvXC9zaG9wIiwiaWF0IjoxNjU1MzYxMzIwLCJuYmYiOjE2NTUzNjEzMjAsImV4cCI6MTY1NTk2NjEyMCwiZGF0YSI6eyJ1c2VyIjp7ImlkIjozMSwiZGV2aWNlIjoiIiwicGFzcyI6IjBiMGU1ZDI5YTEwYzRmMzdmNmE1MGY0ODE1OTE3OTE0In19fQ.dTfqelM3eGCXeFGj-EKazX937WeIr9bExzyjpzmd2tA}',
    // };

    var headers = {
      'Authorization':
          'Basic Y2tfYjdlYmE5OTE2YTgzNTg0YTcwODg5MzgxYjlmMjg3ZDgwZTFlMGFkMTpjc19lZGU3MGZjNjdhYTQ5YjE0ZDFhNDMzMWVhMDY5YzU5ZGRjZTJlOGY4'
    };

    try {
      var response = await http.put(
          Uri.parse('https://autoly.io/shop/wp-json/wc/v3/orders/$orderId'),
          headers: headers,
          body: {
            "status": currentStatus, // "processing"
          });
      if (response.statusCode == 200) {
        print('order updated successfully');
        // changeBusyState(false);
        setUpdatingOrder();
        notifyListeners();
      } else {
        print('failed to update order');
        // changeBusyState(false);
        // getAllOrders();
        setUpdatingOrder();
        notifyListeners();
      }
    } catch (e) {
      print('Error:${e.toString()}');
      changeBusyState(false);
      notifyListeners();
    }
  }

  Future<void> resetOrder(int orderId) async {
    setUpdatingOrder();
    await initShared();
    String currentStatus = "pending";
    String username = 'ck_b7eba9916a83584a70889381b9f287d80e1e0ad1';
    String password = 'cs_ede70fc67aa49b14d1a4331ea069c59ddce2e8f8';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    // var headers = {
    //   // 'content-type': 'application/json',
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer $token',
    //   // 'Authorization': 'Basic $token',
    //   // 'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYXV0b2x5LmlvXC9zaG9wIiwiaWF0IjoxNjU1MzYxMzIwLCJuYmYiOjE2NTUzNjEzMjAsImV4cCI6MTY1NTk2NjEyMCwiZGF0YSI6eyJ1c2VyIjp7ImlkIjozMSwiZGV2aWNlIjoiIiwicGFzcyI6IjBiMGU1ZDI5YTEwYzRmMzdmNmE1MGY0ODE1OTE3OTE0In19fQ.dTfqelM3eGCXeFGj-EKazX937WeIr9bExzyjpzmd2tA}',
    //   // 'Authorization': 'Basic eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYXV0b2x5LmlvXC9zaG9wIiwiaWF0IjoxNjU1MzYxMzIwLCJuYmYiOjE2NTUzNjEzMjAsImV4cCI6MTY1NTk2NjEyMCwiZGF0YSI6eyJ1c2VyIjp7ImlkIjozMSwiZGV2aWNlIjoiIiwicGFzcyI6IjBiMGU1ZDI5YTEwYzRmMzdmNmE1MGY0ODE1OTE3OTE0In19fQ.dTfqelM3eGCXeFGj-EKazX937WeIr9bExzyjpzmd2tA}',
    // };

    var headers = {
      'Authorization':
          'Basic Y2tfYjdlYmE5OTE2YTgzNTg0YTcwODg5MzgxYjlmMjg3ZDgwZTFlMGFkMTpjc19lZGU3MGZjNjdhYTQ5YjE0ZDFhNDMzMWVhMDY5YzU5ZGRjZTJlOGY4'
    };

    try {
      var response = await http.put(
          Uri.parse('https://autoly.io/shop/wp-json/wc/v3/orders/$orderId'),
          headers: headers,
          body: {
            "status": currentStatus, // "processing"
          });
      if (response.statusCode == 200) {
        print('order updated successfully');
        // changeBusyState(false);
        setUpdatingOrder();
        notifyListeners();
      } else {
        print('failed to update order');
        // changeBusyState(false);
        // getAllOrders();
        setUpdatingOrder();
        notifyListeners();
      }
    } catch (e) {
      print('Error:${e.toString()}');
      changeBusyState(false);
      notifyListeners();
    }
  }

  Future initShared() async {
    localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token');
    id = localStorage.getString('id');
  }

  void filteringOrders(String scanResult) {
    allMatchingOrders.clear();
    if (allOrders.isEmpty) {
      return;
    }

    for (int i = 0; i < allOrders.length; i++) {
      print("scan result $scanResult");
      print("scan result ${allOrders[i].barcodeUrl}");
      if (allOrders[i].barcodeUrl.contains(scanResult)) {
        print("order added $i");
        allMatchingOrders.add(allOrders[i]);
      }
    }

    print("order added $allMatchingOrders");

    setCheckingOrders();
    notifyListeners();
  }

  bool isQrCodeValid(String scanResult) {
    // allMatchingOrders.clear();
    if (allOrders.isEmpty) {
      return false;
    }
    print("all orders length is ${allOrders.length}");
    final target = allOrders.where((item) => item.barcodeUrl.contains(scanResult));
    print("target is $target}");
    if(target == null) {
      return false;
    }else {
      return true;
    }
    // return false;
    // for (int i = 0; i < allOrders.length; i++) {
    //   if (allOrders[i].barcodeUrl.contains(scanResult)) {
    //     print("scan result for $scanResult is true");
    //     return true;
    //   } else {
    //     print("scan result for $scanResult is false");
    //     return false;
    //   }
    // }
    // // setCheckingOrders();
    // // notifyListeners();
  }

  Future<void> setOrderServiceProvider(int orderId, Order order) async {
    setUpdatingOrder();
    await initShared();
    String currentStatus = "pending";
    String username = 'ck_b7eba9916a83584a70889381b9f287d80e1e0ad1';
    String password = 'cs_ede70fc67aa49b14d1a4331ea069c59ddce2e8f8';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    List<OrderMetaDatum> orderMetaData = order.metaData;

    var target =
        orderMetaData.firstWhere((item) => item.key == 'service_provider');
    if (target != null) {
      target.value = "33"; // id;
    }
    print(orderMetaData[1].value.toString());

    print(orderMetaData[1].value.toString());

    var headers = {
      'Authorization':
          'Basic Y2tfYjdlYmE5OTE2YTgzNTg0YTcwODg5MzgxYjlmMjg3ZDgwZTFlMGFkMTpjc19lZGU3MGZjNjdhYTQ5YjE0ZDFhNDMzMWVhMDY5YzU5ZGRjZTJlOGY4'
    };

    print("print ${orderMetaData[1].value.toString()}");

    var body = {
      //  "meta_data": json.encoder.convert(orderMetaData),
      "meta_data": orderMetaData.toList(), // json.encode(orderMetaData),
    };

    try {
      var response = await http.put(
        Uri.parse('https://autoly.io/shop/wp-json/wc/v3/orders/$orderId'),
        headers: headers,
        body: json.encode(body),
        // body: {
        //   "meta_data": json.encoder.convert(orderMetaData),
        //  //  "meta_data": orderMetaData.toList(), // json.encode(orderMetaData),
        // }
      );
      if (response.statusCode == 200) {
        print('order updated successfully');
        // changeBusyState(false);
        setUpdatingOrder();
        notifyListeners();
      } else {
        print('failed to update order');
        // changeBusyState(false);
        // getAllOrders();
        setUpdatingOrder();
        notifyListeners();
      }
    } catch (e) {
      print('Error:${e.toString()}');
      changeBusyState(false);
      notifyListeners();
    }
  }

  Future<void> updateOrderWithDio(
      int orderId, OrderStatus orderStatus, Order order) async {
    setUpdatingOrder();
    String currentStatus = "";
    switch (orderStatus) {
      case OrderStatus.pending:
        currentStatus = "processing";
        break;
      case OrderStatus.processing:
        currentStatus = "completed";
        break; //
      case OrderStatus.completed:
        currentStatus = "completed";
        break;
    }

    await initShared();
    Dio dio = Dio();

    String username = 'ck_b7eba9916a83584a70889381b9f287d80e1e0ad1';
    String password = 'cs_ede70fc67aa49b14d1a4331ea069c59ddce2e8f8';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    List<OrderMetaDatum> orderMetaData = order.metaData;

    var target =
        orderMetaData.firstWhere((item) => item.key == 'service_provider');
    if (target != null) {
      target.value = id;
    }
    print(orderMetaData[1].value.toString());

    var headers = {
      'Authorization':
          'Basic Y2tfYjdlYmE5OTE2YTgzNTg0YTcwODg5MzgxYjlmMjg3ZDgwZTFlMGFkMTpjc19lZGU3MGZjNjdhYTQ5YjE0ZDFhNDMzMWVhMDY5YzU5ZGRjZTJlOGY4'
    };

    print("print ${orderMetaData[1].value.toString()}");

    var body = {
      //  "meta_data": json.encoder.convert(orderMetaData),
      "status": currentStatus,
      "meta_data": orderMetaData.toList(), // json.encode(orderMetaData),
    };

    try {
      var response = await dio.put(
        'https://autoly.io/shop/wp-json/wc/v3/orders/$orderId',
        data: json.encode(body),
        options: Options(headers: headers),
        // headers: headers,
        // body:json.encode(body),
        // body: {
        //   "meta_data": json.encoder.convert(orderMetaData),
        //  //  "meta_data": orderMetaData.toList(), // json.encode(orderMetaData),
        // }
      );
      if (response.statusCode == 200) {
        print('order updated successfully');
        setUpdatingOrder();
        notifyListeners();
      } else {
        print('failed to update order');
        setUpdatingOrder();
        notifyListeners();
      }
    } catch (e) {
      print('Error:${e.toString()}');
      changeBusyState(false);
      notifyListeners();
    }
  }

  bool filteringMatchingOrdersWithZero(Order order) {
    List<OrderMetaDatum> meta = order.metaData;
    for (int j = 0; j < meta.length; j++) {
      if (meta[j].value == "0") {
        return true;
      }
    }
    return false;
  }

  bool filteringMatchingOrders(Order order) {
    // await initShared();
    List<OrderMetaDatum> meta = order.metaData;
    // if(order.status == "pending"){
    //   return true;
    // }
    print("id is $id");
    for (int j = 0; j < meta.length; j++) {
      if (meta[j].value == id || meta[j].value == "0") {
        return true;
      }
    }
    return false;
    // notifyListeners();
  }

  Future<void> updateOrderFromDetails(
      int orderId, OrderStatus orderStatus, Order order) async {
    setUpdatingOrder();
    String currentStatus = "";
    switch (orderStatus) {
      case OrderStatus.pending:
        currentStatus = "processing";
        break;
      case OrderStatus.processing:
        currentStatus = "completed";
        break; //
      case OrderStatus.completed:
        currentStatus = "completed";
        break;
    }

    await initShared();
    Dio dio = Dio();

    String username = 'ck_b7eba9916a83584a70889381b9f287d80e1e0ad1';
    String password = 'cs_ede70fc67aa49b14d1a4331ea069c59ddce2e8f8';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    List<OrderMetaDatum> orderMetaData = order.metaData;

    var target =
    orderMetaData.firstWhere((item) => item.key == 'service_provider');
    if (target != null) {
      target.value = id;
    }
    print(orderMetaData[1].value.toString());

    var headers = {
      'Authorization':
      'Basic Y2tfYjdlYmE5OTE2YTgzNTg0YTcwODg5MzgxYjlmMjg3ZDgwZTFlMGFkMTpjc19lZGU3MGZjNjdhYTQ5YjE0ZDFhNDMzMWVhMDY5YzU5ZGRjZTJlOGY4'
    };

    print("print ${orderMetaData[1].value.toString()}");

    var body = {
      //  "meta_data": json.encoder.convert(orderMetaData),
      "status": currentStatus,
      "meta_data": orderMetaData.toList(), // json.encode(orderMetaData),
    };

    try {
      var response = await dio.put(
        'https://autoly.io/shop/wp-json/wc/v3/orders/$orderId',
        data: json.encode(body),
        options: Options(headers: headers),
        // headers: headers,
        // body:json.encode(body),
        // body: {
        //   "meta_data": json.encoder.convert(orderMetaData),
        //  //  "meta_data": orderMetaData.toList(), // json.encode(orderMetaData),
        // }
      );
      if (response.statusCode == 200) {
        print('order updated successfully');
        setUpdatingOrder();
        notifyListeners();
      } else {
        print('failed to update order');
        setUpdatingOrder();
        notifyListeners();
      }
    } catch (e) {
      print('Error:${e.toString()}');
      changeBusyState(false);
      notifyListeners();
    }
  }
}
