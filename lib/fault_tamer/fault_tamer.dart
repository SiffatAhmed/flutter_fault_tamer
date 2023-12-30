import "dart:io";

import "package:dio/dio.dart" as dio;
import "package:flutter/services.dart";

class FlutterFaultTamer {
  /// Returns data from API call response from dio package or Error String.
  /// network call looks as follows
  /// `() async => await Dio().get('https://dart.dev')`
  networkCallTamer(Future Function() networkCall) async {
    try {
      dio.Response<dynamic> response = await (networkCall.call());
      switch (response.statusCode) {
        case 200:
          return response.data;
        case 400:
          throw (response.statusMessage ?? "When wrong data/parameter is sent to the API.");
        case 401:
          throw (response.statusMessage ?? "You are not authorized to requested data.");
        case 403:
          throw (response.statusMessage ?? "You are not authorized to requested data.");
        case 404:
          throw (response.statusMessage ?? "Server not found.");
        case 408:
          throw (response.statusMessage ?? "Request timed out.");
        case 429:
          throw (response.statusMessage ?? "Too many requests in a certain time frame.");
        case 500:
          throw (response.statusMessage ?? "Triggered when something goes wrong in our system.");
        case 502:
          throw (response.statusMessage ?? "Invalid Request sent to server.");
        default:
          throw (response.statusMessage ?? "An unexpected error occurred. Please try again");
      }
    } on HttpException {
      return "No Internet Connection.";
    } on FormatException {
      return "Invalid data Format.";
    } on SocketException {
      return "No Internet Connection.";
    } catch (e) {
      if (e is dio.DioException) {
        return _dioExceptionHandler(e);
      }
      return e.toString();
    }
  }

  /// Returns data error if any else null
  String? genericCodeTamer(Function() networkCall) {
    try {
      networkCall.call();
      return null;
    } on HttpException {
      return "No Internet Connection.";
    } on FormatException {
      return "Invalid data Format.";
    } on SocketException {
      return "No Internet Connection.";
    } on PlatformException catch (e) {
      return e.message;
    } on FileSystemException catch (e) {
      return e.message;
    } on TlsException catch (e) {
      return e.message;
    } catch (e) {
      if (e is dio.DioException) {
        return _dioExceptionHandler(e);
      }
      if (e.toString().toLowerCase().contains("null check operator used on null")) {
        return "Invalid data format";
      } else if (e.toString().toLowerCase().contains("can't be assigned to a variable of type") || e.toString().toLowerCase().contains("can't be assigned to the parameter type")) {
        return "Invalid data assignment";
      } else if (e.toString().toLowerCase().contains("is not a subtype of type")) {
        return "Invalid data format";
      }
      return e.toString();
    }
  }

  /// Returns data error if any else null
  Future<String?>? genericCodeTamerForFuture(Future Function() networkCall) async {
    try {
      await networkCall.call();
      return null;
    } on HttpException {
      return "No Internet Connection.";
    } on FormatException {
      return "Invalid data Format.";
    } on SocketException {
      return "No Internet Connection.";
    } on PlatformException catch (e) {
      return e.message;
    } on FileSystemException catch (e) {
      return e.message;
    } on TlsException catch (e) {
      return e.message;
    } catch (e) {
      if (e is dio.DioException) {
        return _dioExceptionHandler(e);
      }
      if (e.toString().toLowerCase().contains("null check operator used on null")) {
        return "Invalid data format";
      } else if (e.toString().toLowerCase().contains("can't be assigned to a variable of type") || e.toString().toLowerCase().contains("can't be assigned to the parameter type")) {
        return "Invalid data assignment";
      } else if (e.toString().toLowerCase().contains("is not a subtype of type")) {
        return "Invalid data format";
      }
      return e.toString();
    }
  }

  String _dioExceptionHandler(dio.DioException e) {
    if (e.type == dio.DioExceptionType.sendTimeout)
      return "Request timedout please try again.";
    else if (e.type == dio.DioExceptionType.receiveTimeout)
      return "Request timedout please try again.";
    else if (e.type == dio.DioExceptionType.connectionTimeout)
      return "Request timedout please try again.";
    else if (e.type == dio.DioExceptionType.connectionError)
      return "Network error please check your internet.";
    else if (e.type == dio.DioExceptionType.cancel)
      return "Request cancelled.";
    else if (e.type == dio.DioExceptionType.badResponse)
      return "Invalid Request sent to server.";
    else if (e.type == dio.DioExceptionType.badCertificate)
      return "Invalid server certificate configuration.";
    else
      return "Something went wrong.";
  }
}
