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
        Provider(
          create: (_) => HttpClientWrapper(client: http.Client()),
        ),
        Provider(
          create: (context) => AuthRemoteDataSourceImpl(
            client: context.read<HttpClientWrapper>(),
          ),
        ),
        Provider(
          create: (context) => AuthLocalDataSourceImpl(
            sharedPreferences: sharedPreferences,
          ),
        ),
        Provider(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSourceImpl>(),
            localDataSource: context.read<AuthLocalDataSourceImpl>(),
          ),
        ),
        Provider(
          create: (context) => SignInUseCase(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        Provider(
          create: (context) => SignUpUseCase(
            context.read<AuthRepositoryImpl>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            signInUseCase: context.read<SignInUseCase>(),
            signUpUseCase: context.read<SignUpUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'FeedGuard DDD',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}