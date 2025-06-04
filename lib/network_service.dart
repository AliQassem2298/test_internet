// lib/services/network_service.dart

// class NetworkService {
//   final Connectivity _connectivity = Connectivity();
//   final InternetConnectionChecker _internetChecker =
//       InternetConnectionChecker();

//   StreamController<NetworkStatus> networkStatusController =
//       StreamController<NetworkStatus>.broadcast();

//   NetworkService() {
//     _connectivity.onConnectivityChanged.listen((result) async {
//       final hasInternet = await _internetChecker.hasConnection;
//       if (result == ConnectivityResult.none || !hasInternet) {
//         networkStatusController.add(NetworkStatus.offline);
//       } else {
//         networkStatusController.add(NetworkStatus.online);
//       }
//     });
//   }

//   Future<ConnectivityResult> getConnectionType() async {
//     return await _connectivity.checkConnectivity();
//   }

//   Future<bool> hasInternetAccess() async {
//     return await _internetChecker.hasConnection;
//   }
// }

//////////////////////////////////////////////////////
///
///
// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

// class NetworkService {
//   final Connectivity _connectivity = Connectivity();
//   final InternetConnectionChecker _internetChecker =
//       InternetConnectionChecker();

//   StreamController<NetworkStatus> networkStatusController =
//       StreamController<NetworkStatus>.broadcast();

//   NetworkService() {
//     _connectivity.onConnectivityChanged.listen((result) async {
//       _checkStatus();
//     });

//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       _checkStatus();
//     });
//   }

//   Future<void> _checkStatus() async {
//     final result = await _connectivity.checkConnectivity();
//     final hasInternet = await _internetChecker.hasConnection;

//     if (result == ConnectivityResult.none || !hasInternet) {
//       networkStatusController.add(NetworkStatus.offline);
//     } else {
//       networkStatusController.add(NetworkStatus.online);
//     }
//   }

//   Future<ConnectivityResult> getConnectionType() async {
//     return await _connectivity.checkConnectivity();
//   }

//   Future<bool> hasInternetAccess() async {
//     return await _internetChecker.hasConnection;
//   }
// }

// enum NetworkStatus { online, offline }
//////////////////////////////////////////
///
///
///
library;

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internetChecker =
      InternetConnectionChecker();

  StreamController<NetworkStatus> networkStatusController =
      StreamController<NetworkStatus>.broadcast();

  NetworkService() {
    _connectivity.onConnectivityChanged.listen((_) {
      _checkStatus();
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkStatus();
    });
  }

  Future<void> _checkStatus() async {
    final result = await _connectivity.checkConnectivity();
    final hasInternet = await _internetChecker.hasConnection;

    if (result == ConnectivityResult.none || !hasInternet) {
      networkStatusController.add(NetworkStatus.offline);
    } else {
      networkStatusController.add(NetworkStatus.online);
    }
  }

  Future<ConnectivityResult> getConnectionType() async {
    return await _connectivity.checkConnectivity();
  }

  Future<bool> hasInternetAccess() async {
    return await _internetChecker.hasConnection;
  }
}

enum NetworkStatus { online, offline }
