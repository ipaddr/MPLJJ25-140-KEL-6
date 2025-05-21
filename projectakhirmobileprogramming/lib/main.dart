import 'package:flutter/material.dart';
import 'package:projectakhirmobileprogramming/screens/admin/tabs/admin_profile_tab.dart';
import 'package:provider/provider.dart';
import 'package:projectakhirmobileprogramming/core/theme/app_theme.dart';

// Import user authentication screens
import 'package:projectakhirmobileprogramming/screens/auth/sign_up_screen.dart';

// Import main user screens
import 'package:projectakhirmobileprogramming/screens/home/home_screen.dart';
import 'package:projectakhirmobileprogramming/screens/home/house_detail_screen.dart';
import 'package:projectakhirmobileprogramming/models/news_model.dart'; // Import News model for routing
import 'package:projectakhirmobileprogramming/screens/home/news_detail_screen.dart';
import 'package:projectakhirmobileprogramming/screens/chat/chat_list_screen.dart';
import 'package:projectakhirmobileprogramming/screens/chat/chat_ai_screen.dart';
import 'package:projectakhirmobileprogramming/screens/profile/user_profile_screen.dart';
import 'package:projectakhirmobileprogramming/screens/bantuan/ajukan_bantuan_screen_1.dart';
import 'package:projectakhirmobileprogramming/screens/bantuan/ajukan_bantuan_screen_2.dart';
import 'package:projectakhirmobileprogramming/screens/bantuan/ajukan_bantuan_screen_3.dart';
import 'package:projectakhirmobileprogramming/screens/bantuan/ajukan_bantuan_screen_4.dart';
import 'package:projectakhirmobileprogramming/screens/bantuan/ajukan_bantuan_screen_riwayat.dart';
import 'package:projectakhirmobileprogramming/screens/auth/admin_sign_in_screen.dart';
import 'package:projectakhirmobileprogramming/screens/auth/admin_sign_up_screen.dart';
import 'package:projectakhirmobileprogramming/screens/auth/sign_in_screen.dart';
import 'package:projectakhirmobileprogramming/screens/admin/requests_screen.dart';
import 'package:projectakhirmobileprogramming/screens/admin/request_detail_screen.dart';
import 'package:projectakhirmobileprogramming/screens/admin/distribution_screen.dart';
import 'package:projectakhirmobileprogramming/screens/admin/admin_profile_screen.dart';
import 'providers/auth_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add other providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final initialRoute = authProvider.isAuthenticated ? '/home' : '/sign-in';

    return MaterialApp(
      title: 'Flutter App',
      theme: appTheme,
      initialRoute: initialRoute,
      routes: {
        // User Authentication Routes
        '/sign-in': (context) => SignInScreen(),
        '/sign-up': (context) { return UserSignUpScreen(); },

        // Main User Screens Routes
        '/home': (context) => const HomeScreen(),
        '/house-detail': (context) => HouseDetailScreen(houseType: ModalRoute.of(context)!.settings.arguments as String),
        '/news-detail': (context) => NewsDetailScreen(article: ModalRoute.of(context)!.settings.arguments as News),
        '/chat-list': (context) => ChatListScreen(),
        '/chat-ai': (context) => ChatAiScreen(),
        '/user-profile': (context) => UserProfileScreen(),
        '/ajukan-bantuan-1': (context) => AjukanBantuanScreen1(),
        '/ajukan-bantuan-2': (context) => AjukanBantuanScreen2(),
        '/ajukan-bantuan-3': (context) => AjukanBantuanScreen3(),
        '/ajukan-bantuan-4': (context) => AjukanBantuanScreen4(),


        '/ajukan-bantuan-riwayat': (context) => AjukanBantuanScreenRiwayat(),
        // Admin Authentication Routes
        '/admin-sign-in': (context) => AdminSignInScreen(),
        '/admin-sign-up': (context) => AdminSignUpScreen(),
        // Admin Screens Routes
        '/admin-requests': (context) => RequestsScreen(),
        '/admin-distribution': (context) => DistributionScreen(),
        '/admin-profile': (context) => AdminProfileScreen(),
        



      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Page Not Found')),
          body: const Center(
            child: Text('Page not found!'),
          ),
        ),
      ),
    );
  }
}