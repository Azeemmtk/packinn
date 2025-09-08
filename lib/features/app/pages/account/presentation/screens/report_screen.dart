import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/services/current_user.dart';

import '../../../../../../core/di/injection.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../../../home/presentation/provider/bloc/report/report_bloc.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String senderId = CurrentUser().uId!;
    return BlocProvider(
      create: (context) => getIt<ReportBloc>()..add(FetchUserReportsEvent(senderId: senderId)),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBarWidget(title: 'My Reports'),
        ),
        body: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReportLoaded) {
              final reports = state.reports;
              if (reports.isEmpty) {
                return const Center(child: Text('No reports submitted yet'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (report.imageUrl != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                report.imageUrl!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (report.imageUrl != null)
                            const SizedBox(height: 12.0),
                          Text(
                            'Message:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            report.message,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'Status:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            report.status,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          if (report.adminAction != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Admin Action:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    report.adminAction!,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ReportError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No reports available'));
          },
        ),
      ),
    );
  }
}
