import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:packinn/core/error/failures.dart';

import '../../../../domain/entity/review_entity.dart';
import '../../../../domain/usecases/add_review_use_case.dart';
import '../../../../domain/usecases/get_review_use_case.dart';
part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReviewUseCase addReviewUseCase;
  final GetReviewsUseCase getReviewsUseCase;

  ReviewBloc({
    required this.addReviewUseCase,
    required this.getReviewsUseCase,
  }) : super(ReviewInitial()) {
    on<FetchReviews>(_onFetchReviews);
    on<AddReview>(_onAddReview);
  }

  Future<void> _onFetchReviews(FetchReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final stream = getReviewsUseCase(event.hostelId);
      await for (final reviews in stream) {
        if (!emit.isDone) {
          emit(ReviewLoaded(reviews: reviews));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ReviewError(message: e.toString()));
      }
    }
  }

  Future<void> _onAddReview(AddReview event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    final result = await addReviewUseCase(event.review);
    result.fold(
          (failure) => emit(ReviewError(message: failure.message)),
          (_) => emit(ReviewAdded()),
    );
  }
}