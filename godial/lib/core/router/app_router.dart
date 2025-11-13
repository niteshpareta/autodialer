import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/contacts/contacts_list_screen.dart';
import '../../presentation/screens/contacts/contact_detail_screen.dart';
import '../../presentation/screens/contacts/add_contact_screen.dart';
import '../../presentation/screens/dialer/dialer_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/contacts',
        builder: (context, state) => const ContactsListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddContactScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => ContactDetailScreen(
              contactId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/dialer',
        builder: (context, state) => const DialerScreen(),
      ),
    ],
  );
});