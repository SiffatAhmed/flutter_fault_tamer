# Overview

FlutterFaultTamer is a Flutter package designed to streamline error handling in your Dart and Flutter projects, especially when dealing with network calls using the Dio package. It provides a set of functions to tame and handle errors gracefully, making your code more robust and user-friendly.


# Installation

To use FlutterFaultTamer in your Flutter project, add the following dependency to your `pubspec.yaml` file:

    dependencies:
	    flutter_fault_tamer: ^1.0.0
**OR**

    flutter pub get flutter_fault_tamer


## Usage

To use FlutterFaultTamer, import the package and create an instance of the `FlutterFaultTamer` class:

    import 'package:package:flutter_fault_tamer/flutter_fault_tamer.dart';
    FlutterFaultTamer faultTamer = FlutterFaultTamer();

## Error Handling

FlutterFaultTamer handles various types of errors, including network errors, data types errors, general errors and Dio-specific errors. It provides meaningful error messages to help you identify and resolve issues efficiently.

## Example Codes:

```import  'dart:developer';
  
import  'package:dio/dio.dart';
import  'package:flutter/material.dart';
import  'package:flutter_fault_tamer/flutter_fault_tamer.dart';
  
void  main() {
runApp(const  MyApp());
}
  
class  MyApp  extends  StatelessWidget {
const  MyApp({super.key});

@override
Widget  build(BuildContext  context) {
	return  MaterialApp(
		title: 'Flutter Demo',
		theme: ThemeData(
			colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
			useMaterial3: true,
		),
		home: const  MyHomePage(),
		);
	}
}

class  MyHomePage  extends  StatefulWidget {
const  MyHomePage({super.key});
  
@override
State<MyHomePage> createState() => _MyHomePageState();
}

class  _MyHomePageState  extends  State<MyHomePage> {

final  faultTamer = FlutterFaultTamer();

networkCall() async {
	// Returns data from API call response from dio package or Error String.
	var  result = await  faultTamer.networkCallTamer(() async => await (Dio().get('https://dart.dev')));

	log(result.toString());

	result = await  faultTamer.networkCallTamer(() async => await (Dio().get('https://dart.de')));

	log(result.toString());  

	log("=======================================================");

	genericExceptionHandlingCall();

	log("=======================================================");
	genericExceptionHandlingCallFuture();
}

  

genericExceptionHandlingCall() {
	int  number = 5;
		
	// This will not throw error
	var  result = faultTamer.genericCodeTamer(() => number = 6);
		
	log(result.toString());

	// This will throw error of unsupported operation as division by zero is not allowed.
	result = faultTamer.genericCodeTamer(() {
		number = number ~/ 0;
	});
		
	log(result.toString());
}

  

genericExceptionHandlingCallFuture() async {

	// This will not throw error
	var  result = await  faultTamer.genericCodeTamerForFuture(() async => await (Dio().get('https://dart.dev')));

	log(result.toString());

	// This will throw error of unsupported operation as division by zero is not allowed.
	result = await  faultTamer.genericCodeTamerForFuture(() async => await (Dio().get('https://dart.dv')));

	log(result.toString());
}

  

@override
void  initState() {
	networkCall();
	super.initState();
}

  

@override
Widget  build(BuildContext  context) {
		return  const  Scaffold();
	}
}
