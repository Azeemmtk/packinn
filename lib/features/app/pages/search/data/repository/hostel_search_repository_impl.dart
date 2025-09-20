import 'package:dartz/dartz.dart';
import '../../../../../../core/entity/hostel_entity.dart';
import '../../../../../../core/error/failures.dart';
import '../../../../../../core/error/exceptions.dart';
import '../../../../../../core/services/ds/trie.dart';
import '../../domain/repository/hostel_search_repository.dart';
import '../../presentation/provider/cubit/search_filter/search_filter_state.dart';
import '../datasource/hostel_search_remote_data_source.dart';

class HostelSearchRepositoryImpl implements HostelSearchRepository {
  final HostelSearchRemoteDataSource remoteDataSource;
  final Trie _searchTrie = Trie();

  HostelSearchRepositoryImpl(this.remoteDataSource) {
    _loadHostelsIntoTrie();
  }

  Future<void> _loadHostelsIntoTrie() async {
    final result = await remoteDataSource.getHostelData();
    result.fold(
          (failure) => null, // Handle failure silently or log
          (hostels) {
        for (var hostel in hostels) {
          _searchTrie.insert(hostel.name, hostel.id);
          if (hostel.placeName.isNotEmpty) {
            _searchTrie.insert(hostel.placeName, hostel.id);
          }
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<HostelEntity>>> searchHostels(String query, SearchFilterState filters) async {
    try {
      final hostels = await remoteDataSource.getHostelData();
      return hostels;
    } catch (e) {
      return Left(ServerFailure('Failed to fetch hostels: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAutocompleteSuggestions(String query) async {
    try {
      final suggestions = _searchTrie.search(query);
      return Right(suggestions);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch suggestions: $e'));
    }
  }
}