import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/error/failures.dart';
import '../../domain/entity/booking_entity.dart';
import '../../domain/repository/booking_repository.dart';
import '../datasourse/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<BookingEntity>>> getMyBookings() async {
    try {
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUid == null) {
        throw const AuthException('User not logged in');
      }
      final occupants = await remoteDataSource.getMyOccupants(currentUid);
      final bookings = <BookingEntity>[];
      for (final occupantModel in occupants) {
        final occupant = occupantModel.toEntity();
        if (occupant.hostelId != null) {
          final hostelModel = await remoteDataSource.getHostelById(occupant.hostelId!);
          final hostel = hostelModel.toEntity();
          final room = hostel.rooms.firstWhere(
                (r) => r['roomId'] == occupant.roomId,
            orElse: () => throw const ServerException('Room not found'),
          );
          bookings.add(BookingEntity(occupant: occupant, hostel: hostel, room: room));
        }
      }
      return Right(bookings);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return Left(NetworkFailure('No internet connection'));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}