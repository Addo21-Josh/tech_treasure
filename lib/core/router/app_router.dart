import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/content/presentation/screens/script_studio_screen.dart';
import '../../features/content/presentation/screens/teleprompter_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/pipeline/presentation/screens/pipeline_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/treasures/presentation/screens/add_edit_treasure_screen.dart';
import '../../features/treasures/presentation/screens/search_screen.dart';
import '../../features/treasures/presentation/screens/treasure_detail_screen.dart';
import '../../features/treasures/presentation/screens/treasures_list_screen.dart';
import '../widgets/main_shell_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Declarative router provider powering Tech Treasure navigation.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // Tab 2: Treasures List & Detail Sub-Routes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/treasures',
                builder: (context, state) => const TreasuresListScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const AddEditTreasureScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => TreasureDetailScreen(
                      treasureId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => AddEditTreasureScreen(
                          treasureId: state.pathParameters['id'],
                        ),
                      ),
                      GoRoute(
                        path: 'studio',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => ScriptStudioScreen(
                          treasureId: state.pathParameters['id']!,
                        ),
                      ),
                      GoRoute(
                        path: 'teleprompter',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) => TeleprompterScreen(
                          treasureId: state.pathParameters['id']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Tab 3: Content Pipeline (Kanban)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pipeline',
                builder: (context, state) => const PipelineScreen(),
              ),
            ],
          ),

          // Tab 4: Search
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),

          // Tab 5: Settings & Backup
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
