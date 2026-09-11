import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/api_client.dart';
import 'core/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/auction_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/auction/auction_detail_screen.dart';
import 'screens/auction/create_auction_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/bid/my_bids_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/chat/chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient().init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SneakerHubApp());
}

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/auction/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return AuctionDetailScreen(auctionId: id);
      },
    ),
    GoRoute(
      path: '/create-auction',
      builder: (context, state) => const CreateAuctionScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/my-bids',
      builder: (context, state) => const MyBidsScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);

class SneakerHubApp extends StatelessWidget {
  const SneakerHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AuctionProvider()),
      ],
      child: MaterialApp.router(
        title: 'SneakerHub',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppConstants.bgDark,
          colorScheme: const ColorScheme.dark(
            primary: AppConstants.electricBlue,
            secondary: AppConstants.neonBlue,
            surface: AppConstants.navyBlue,
          ),
          fontFamily: 'SF Pro Display',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: AppConstants.textWhite),
            titleTextStyle: AppConstants.heading2,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppConstants.cardBlue,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              borderSide: const BorderSide(
                  color: AppConstants.electricBlue, width: 1.5),
            ),
            labelStyle: const TextStyle(color: AppConstants.textGrey),
            hintStyle: const TextStyle(color: AppConstants.textGrey),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.electricBlue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}
