import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/data/repositories/profile_repository_impl.dart';
import 'package:connectme_app/domain/repositories/profile_repository.dart';
import 'package:connectme_app/domain/usecases/get_profile.dart';
import 'package:connectme_app/domain/usecases/update_profile_image.dart';
import 'package:connectme_app/presentation/blocs/profile_cubit.dart';
import 'package:connectme_app/services/device_info_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/firestore_post_datasource.dart';
import 'data/datasources/local_post_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/post_repository_factory.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/usecases/create_post.dart';
import 'domain/usecases/get_posts.dart';
import 'presentation/blocs/auth_cubit.dart';
import 'presentation/blocs/post_cubit.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/biometric_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Services

  getIt.registerLazySingleton<AuthService>(() => AuthService());

  getIt.registerLazySingleton<FirestoreService>(
    () => FirestoreService.instance,
  );

  // Authentication

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthService>(), getIt<FirestoreService>()),
  );

  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));

  // Post data sources

  getIt.registerLazySingleton<FirestorePostDataSource>(
    () => FirestorePostDataSource(FirebaseFirestore.instance),
  );

  getIt.registerLazySingleton<LocalPostDataSource>(() => LocalPostDataSource());

  // Factory Pattern

  getIt.registerLazySingleton<PostDataSourceFactory>(
    () => PostDataSourceFactory(
      getIt<FirestorePostDataSource>(),
      getIt<LocalPostDataSource>(),
    ),
  );

  // Repository

  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(getIt<PostDataSourceFactory>()),
  );

  // Use Cases

  getIt.registerLazySingleton<GetPosts>(
    () => GetPosts(getIt<PostRepository>()),
  );

  getIt.registerLazySingleton<CreatePost>(
    () => CreatePost(getIt<PostRepository>()),
  );

  // Cubit

  getIt.registerFactory<PostCubit>(
    () => PostCubit(getIt<CreatePost>(), getIt<GetPosts>()),
  );

  getIt.registerLazySingleton<BiometricService>(() => BiometricService());

  getIt.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      getIt<FirestoreService>(),
      FirebaseStorage.instance,
    ),
  );

  getIt.registerLazySingleton<GetProfile>(
    () => GetProfile(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<UpdateProfileImage>(
    () => UpdateProfileImage(getIt<ProfileRepository>()),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getIt<GetProfile>(),
      getIt<UpdateProfileImage>(),
      getIt<DeviceInfoService>(),
    ),
  );
}
