import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoo_list/bloc/main_bloc.dart';
import 'package:todoo_list/helper/object_box.dart';
import 'package:todoo_list/services/web_services.dart';
import 'package:todoo_list/simple_bloc_observer.dart';
import 'package:todoo_list/theme/theme.dart';
import 'package:todoo_list/view/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final objectBox = await ObjectBox.init();
  final webServices = WebServices(objectBox);
  runApp(MyApp(webServices: webServices));
}

class MyApp extends StatelessWidget {
  final WebServices webServices;

  const MyApp({Key? key, required this.webServices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: light,
      home: BlocProvider(
        create: (context) => MainBloc(webServices: webServices),
        child: DashboardUI(),
      ),
    );
  }
}
