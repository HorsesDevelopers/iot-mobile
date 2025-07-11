import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/aar/presentation/pond-create/pond_create.dart';
import 'package:mobile/sdap/application/task_provider.dart';
import 'package:mobile/sdap/presentation/pages/tasks_page.dart';
import 'package:mobile/sdp/application/sensor_provider.dart';
import 'package:mobile/sdp/infrastructure/sensor_repository.dart';
import 'package:mobile/sdp/presentation/device_page.dart';
import 'package:provider/provider.dart';
import 'package:mobile/common/core/network/http_client_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aar/presentation/pond-list/pond_list_screen.dart';
import 'common/infrastructure/api_constants.dart';
import 'daa/presentation/pond-analytics/pond_analytics.dart';
import 'iam/application/auth_provider.dart';
import 'iam/domain/usecases/sign_in_use_case.dart';
import 'iam/domain/usecases/sign_up_use_case.dart';
import 'iam/infrastructure/datasources/auth_local_data_source.dart';
import 'iam/infrastructure/datasources/auth_remote_data_source.dart';
import 'iam/infrastructure/repositories/auth_repository_impl.dart';
import 'iam/presentation/home_page.dart';
import 'iam/presentation/login_page.dart';
import 'iam/presentation/register_page.dart';
import 'oam/application/notification_provider.dart';
import 'oam/domain/usecases/get_notifications_use_case.dart';
import 'oam/infrastructure/datasources/notification_remote_data_source.dart';
import 'oam/infrastructure/repositories/notification_repository_impl.dart';
import 'oam/presentation/pages/notifications_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(),
        ),
        Provider<SharedPreferences>.value(value: sharedPreferences),

        Provider<HttpClientWrapper>(
          create: (context) => HttpClientWrapper(
            client: context.read<http.Client>(),
            enableLogging: true,
          ),
        ),

        Provider<AuthLocalDataSourceImpl>(
          create: (context) => AuthLocalDataSourceImpl(
            sharedPreferences: context.read<SharedPreferences>(),
          ),
        ),
        Provider<AuthRemoteDataSourceImpl>(
          create: (context) => AuthRemoteDataSourceImpl(
            client: context.read<HttpClientWrapper>(),
          ),
        ),
        Provider<NotificationRemoteDataSourceImpl>(
          create: (context) => NotificationRemoteDataSourceImpl(
            client: context.read<http.Client>(),
            localDataSource: context.read<AuthLocalDataSourceImpl>(),
          ),
        ),

        Provider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSourceImpl>(),
            localDataSource: context.read<AuthLocalDataSourceImpl>(),
          ),
        ),
        Provider<NotificationRepositoryImpl>(
          create: (context) => NotificationRepositoryImpl(
            remoteDataSource: context.read<NotificationRemoteDataSourceImpl>(),
          ),
        ),

        Provider<SignInUseCase>(
          create: (context) => SignInUseCase(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        Provider<SignUpUseCase>(
          create: (context) => SignUpUseCase(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        Provider<GetNotificationsUseCase>(
          create: (context) => GetNotificationsUseCase(
            context.read<NotificationRepositoryImpl>(),
          ),
        ),
        ChangeNotifierProvider<SensorProvider>(
          create: (_) => SensorProvider(
            SensorRepository(kBaseApiUrl),
          ),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            signInUseCase: context.read<SignInUseCase>(),
            signUpUseCase: context.read<SignUpUseCase>(),
          ),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (context) => NotificationProvider(
            getNotificationsUseCase: context.read<GetNotificationsUseCase>(),
          ),
          lazy: false,
        ),
        ChangeNotifierProvider<TaskProvider>(
          create: (context) => TaskProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'FeedGuard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/notifications': (context) => const NotificationsPage(),
          '/ponds': (context) => const PondListScreen(),
          '/ponds-sdp': (context) => PondStatsPage(),
          '/tasks': (context) => const TasksPage(),
          '/pond-create': (context) => const CreatePondPage(),
          '/devices': (context) => const DevicePage(),
        },
      ),
    );
  }
}