import 'package:flutter/material.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/utils/show_document_alert_dialog.dart';
import '../../../../../../../core/widgets/title_text_widget.dart';

class IdProofSection extends StatelessWidget {
  final String? idProofUrl;
  final String? addressProofUrl;
  final bool isGuardian;

  const IdProofSection({
    super.key,
    required this.idProofUrl,
    required this.addressProofUrl,
    required this.isGuardian,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextWidget(title: isGuardian ? 'Guardian ID proof' : 'Occupant ID proof'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (idProofUrl != null)
              TextButton(
                onPressed: () {
                  showDocumentAlertDialog(
                    context,
                    isGuardian ? 'Guardian ID Proof' : 'Occupant ID Proof',
                    idProofUrl!,
                  );
                },
                child: Text(
                  isGuardian ? 'Guardian ID Proof' : 'Occupant ID Proof',
                  style: TextStyle(color: customGrey),
                ),
              ),
            if (addressProofUrl != null)
              TextButton(
                onPressed: () {
                  showDocumentAlertDialog(
                    context,
                    isGuardian ? 'Guardian Address Proof' : 'Occupant Address Proof',
                    addressProofUrl!,
                  );
                },
                child: Text(
                  isGuardian ? 'Guardian Address Proof' : 'Occupant Address Proof',
                  style: TextStyle(color: customGrey),
                ),
              ),
          ],
        ),
      ],
    );
  }
}