import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/http_client_wrapper.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/domain/usecases/sign_in_use_case.dart';
import 'features/auth/domain/usecases/sign_up_use_case.dart';
import 'features/auth/application/auth_provider.dart';
import 'features/auth/infrastructure/datasources/auth_remote_data_source.dart';
import 'features/auth/infrastructure/datasources/auth_local_data_source.dart';
import 'features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'features/notifications/application/notification_provider.dart';
import 'features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'features/notifications/infrastructure/datasources/notification_remote_data_source.dart';
import 'features/notifications/infrastructure/repositories/notification_repository_impl.dart';
import 'features/notifications/presentation/pages/notifications_page.dart';
import 'features/tasks/presentation/pages/tasks_page.dart';
import 'features/tasks/application/task_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        // 1. Servicios base
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(),
        ),
        Provider<SharedPreferences>.value(value: sharedPreferences),

        // 2. Dependencias de infraestructura
        Provider<HttpClientWrapper>(
          create: (context) => HttpClientWrapper(
            client: context.read<http.Client>(),
            enableLogging: true,
          ),
        ),

        // 3. Data sources
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
          '/tasks': (context) => const TasksPage(),
        },
      ),
    );
  }
}