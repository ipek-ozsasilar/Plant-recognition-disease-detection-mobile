import 'package:bitirme_mobile/core/navigation/app_paths.dart';
import 'package:bitirme_mobile/features/about/about_view.dart';
import 'package:bitirme_mobile/features/auth/login/forgot_password_view.dart';
import 'package:bitirme_mobile/features/auth/login/login_view.dart';
import 'package:bitirme_mobile/features/auth/register/register_view.dart';
import 'package:bitirme_mobile/features/disease_detail/disease_detail_view.dart';
import 'package:bitirme_mobile/features/guide/guide_view.dart';
import 'package:bitirme_mobile/features/health_progress/health_progress_view.dart';
import 'package:bitirme_mobile/features/language/language_select_view.dart';
import 'package:bitirme_mobile/features/history/history_view.dart';
import 'package:bitirme_mobile/features/home/home_view.dart';
import 'package:bitirme_mobile/features/more/more_view.dart';
import 'package:bitirme_mobile/features/onboarding/onboarding_view.dart';
import 'package:bitirme_mobile/features/plants/plants_add_view.dart';
import 'package:bitirme_mobile/features/plants/plants_detail_view.dart';
import 'package:bitirme_mobile/features/plants/plants_list_view.dart';
import 'package:bitirme_mobile/features/profile/profile_notifications_view.dart';
import 'package:bitirme_mobile/features/profile/profile_personal_info_view.dart';
import 'package:bitirme_mobile/features/profile/profile_privacy_view.dart';
import 'package:bitirme_mobile/features/profile/profile_view.dart';
import 'package:bitirme_mobile/features/scan/scan_flow_view.dart';
import 'package:bitirme_mobile/features/settings/settings_view.dart';
import 'package:bitirme_mobile/features/shell/main_shell_view.dart';
import 'package:bitirme_mobile/features/splash/splash_view.dart';
import 'package:bitirme_mobile/features/species_detail/species_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Uygulama yönlendirme grafiği.
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((Ref ref) {
  return GoRouter(
    initialLocation: AppPaths.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppPaths.language,
        builder: (BuildContext context, GoRouterState state) =>
            const LanguageSelectView(),
      ),
      GoRoute(
        path: AppPaths.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashView(),
      ),
      GoRoute(
        path: AppPaths.onboarding,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingView(),
      ),
      GoRoute(
        path: AppPaths.login,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginView(),
      ),
      GoRoute(
        path: AppPaths.register,
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterView(),
      ),
      GoRoute(
        path: AppPaths.forgotPassword,
        builder: (BuildContext context, GoRouterState state) =>
            const ForgotPasswordView(),
      ),
      GoRoute(
        path: '${AppPaths.diseaseDetail}/:diseaseKey',
        builder: (BuildContext context, GoRouterState state) {
          final String diseaseKey = state.pathParameters['diseaseKey'] ?? '';
          final String? confidenceRaw = state.uri.queryParameters['confidence'];
          final double confidence = double.tryParse(confidenceRaw ?? '') ?? 0;
          return DiseaseDetailView(
            diseaseKey: diseaseKey,
            confidence: confidence,
          );
        },
      ),
      GoRoute(
        path: '${AppPaths.speciesDetail}/:speciesLabel',
        builder: (BuildContext context, GoRouterState state) {
          final String speciesLabel =
              state.pathParameters['speciesLabel'] ?? '';
          final String? confidenceRaw = state.uri.queryParameters['confidence'];
          final double confidence = double.tryParse(confidenceRaw ?? '') ?? 0;
          return SpeciesDetailView(
            speciesLabel: speciesLabel,
            confidence: confidence,
          );
        },
      ),
      GoRoute(
        path: AppPaths.myPlants,
        builder: (BuildContext context, GoRouterState state) =>
            const PlantsListView(),
        routes: <RouteBase>[
          GoRoute(
            path: 'add',
            builder: (BuildContext context, GoRouterState state) =>
                const PlantsAddView(),
          ),
          GoRoute(
            path: ':plantId',
            builder: (BuildContext context, GoRouterState state) {
              final String plantId = state.pathParameters['plantId'] ?? '';
              return PlantsDetailView(plantId: plantId);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppPaths.scan,
        builder: (BuildContext context, GoRouterState state) =>
            const ScanFlowView(),
      ),
      GoRoute(
        path: AppPaths.guide,
        builder: (BuildContext context, GoRouterState state) =>
            const GuideView(),
      ),
      GoRoute(
        path: AppPaths.profile,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileView(),
        routes: <RouteBase>[
          GoRoute(
            path: 'personal-info',
            builder: (BuildContext context, GoRouterState state) =>
                const ProfilePersonalInfoView(),
          ),
          GoRoute(
            path: 'notifications',
            builder: (BuildContext context, GoRouterState state) =>
                const ProfileNotificationsView(),
          ),
          GoRoute(
            path: 'privacy',
            builder: (BuildContext context, GoRouterState state) =>
                const ProfilePrivacyView(),
          ),
        ],
      ),
      GoRoute(
        path: AppPaths.settings,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsView(),
      ),
      GoRoute(
        path: AppPaths.about,
        builder: (BuildContext context, GoRouterState state) =>
            const AboutView(),
      ),
      GoRoute(
        path: AppPaths.healthProgressPushed,
        builder: (BuildContext context, GoRouterState state) =>
            const HealthProgressView(),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              return MainShellView(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppPaths.home,
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppPaths.history,
                builder: (BuildContext context, GoRouterState state) =>
                    const HistoryView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppPaths.healthProgress,
                builder: (BuildContext context, GoRouterState state) =>
                    const HealthProgressView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppPaths.more,
                builder: (BuildContext context, GoRouterState state) =>
                    const MoreView(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
