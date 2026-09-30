import 'package:get_it/get_it.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/blocs/auth_cubit.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  getIt.registerLazySingleton<FirestoreService>(
    () => FirestoreService.instance,
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthService>(),
      getIt<FirestoreService>(),
    ),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<AuthRepository>(),
    ),
  );
}