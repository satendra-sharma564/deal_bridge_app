import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: 'Deal Bridge',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
