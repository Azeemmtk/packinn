import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/entity/hostel_entity.dart';
import '../../domain/repository/hostel_search_repository.dart';
import '../../presentation/provider/cubit/search_filter/search_filter_state.dart';
import '../datasource/hostel_search_remote_data_source.dart';

class HostelSearchRepositoryImpl implements HostelSearchRepository {
  final HostelSearchRemoteDataSource remoteDataSource;

  HostelSearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<HostelEntity>>> searchHostels(
      String query, SearchFilterState filters) async {
    try {
      final hostels = await remoteDataSource.getHostelData();
      return hostels.fold(
            (failure) => Left(failure),
            (hostelList) {
          var filteredHostels = hostelList;

          // Filter by name
          if (query.isNotEmpty) {
            filteredHostels = filteredHostels
                .where((hostel) =>
                hostel.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
          }

          // Filter by facilities
          if (filters.facilities.isNotEmpty) {
            filteredHostels = filteredHostels.where((hostel) {
              return filters.facilities.every((facility) => hostel.facilities.contains(facility));
            }).toList();
          }

          // Filter by room types
          if (filters.roomTypes.isNotEmpty) {
            filteredHostels = filteredHostels.where((hostel) {
              return hostel.rooms.any((room) {
                final roomType = room['type'] as String?;
                return roomType != null && filters.roomTypes.contains(roomType);
              });
            }).toList();
          }

          // Filter by price range
          filteredHostels = filteredHostels.where((hostel) {
            return hostel.rooms.any((room) {
              final price = (room['rate'] as num?)?.toDouble() ?? 0.0;
              return price >= filters.priceRange.start && price <= filters.priceRange.end;
            });
          }).toList();

          return Right(filteredHostels);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to search hostels: $e'));
    }
  }
}