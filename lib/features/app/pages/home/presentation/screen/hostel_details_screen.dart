import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/core/widgets/title_text_widget.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/entity/hostel_entity.dart';
import '../provider/bloc/review/review_bloc.dart';
import '../widgets/hostel_details/description_preview_section.dart';
import '../widgets/hostel_details/hostel_facility_name_section.dart';
import '../widgets/hostel_details/review_container.dart';
import '../widgets/hostel_details/review_room_section.dart';
import '../widgets/hostel_details/show_add_review_dialogue.dart';
import '../widgets/report/report_dialog.dart';

class HostelDetailsScreen extends StatelessWidget {
  const HostelDetailsScreen({
    super.key,
    required this.hostel,
  });
  final HostelEntity hostel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReviewBloc>()..add(FetchReviews(hostel.id)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBarWidget(
              title: hostel.name,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                TabBar(
                  tabs: const [
                    Tab(text: 'Details'),
                    Tab(text: 'Review & Rating'),
                  ],
                  labelColor: headingTextColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: mainColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height20,
                            HostelFacilityNameSection(
                              hostel: hostel,
                            ),
                            DescriptionPreviewSection(
                              hostel: hostel,
                            ),
                            ReviewRoomSection(
                              rooms: hostel.rooms
                                  .map((room) => {
                                ...room,
                                'img': hostel.mainImageUrl,
                                'hostelId': hostel.id,
                                'hostelName': hostel.name,
                              })
                                  .toList(),
                            ),
                            height10,
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Builder(
                          builder: (blocContext) => BlocConsumer<ReviewBloc, ReviewState>(
                            listener: (context, state) {
                              if (state is ReviewAdded) {
                                blocContext.read<ReviewBloc>().add(FetchReviews(hostel.id));
                              }
                            },
                            builder: (context, state) {
                              print('Current ReviewBloc state: $state');
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  height20,
                                  const TitleTextWidget(title: 'Review and rating'),
                                  height10,
                                  if (state is ReviewLoading)
                                    const Center(child: CircularProgressIndicator())
                                  else if (state is ReviewLoaded)
                                    state.reviews.isNotEmpty
                                        ? Column(
                                      children: state.reviews
                                          .map((review) => ReviewContainer(review: review))
                                          .toList(),
                                    )
                                        : const Center(child: Text('No reviews yet'))
                                  else if (state is ReviewError)
                                      Center(child: Text('Error: ${state.message}'))
                                    else
                                      const Center(child: Text('No reviews yet')),
                                  height20,
                                  CustomGreenButtonWidget(
                                    name: 'Add Review & Rating',
                                    color: mainColor,
                                    onPressed: () => showAddReviewDialog(blocContext, hostel.id),
                                  ),
                                  height20,
                                  CustomGreenButtonWidget(
                                    name: 'Report',
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ReportDialog(
                                          hostelId: hostel.id,
                                          ownerId: hostel.ownerId,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}