import 'package:cours_work/core/theme.dart';
import 'package:cours_work/data/repositories/articles_repository.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:cours_work/navigation/route_generator.dart';
import 'package:cours_work/presentation/home/cubit/articles_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//test
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(

  );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(initSettings);

  final bool? granted = await notificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  debugPrint('Notification permission granted: $granted');

  runApp(const BlueBiteApp());
}

class BlueBiteApp extends StatelessWidget {
  const BlueBiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ArticlesCubit(ArticlesRepository())..loadArticles(),
        ),
      ],
      child: MaterialApp(
        title: 'Magazine',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        initialRoute: AppRoutes.login,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
