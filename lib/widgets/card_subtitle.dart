import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/message.dart';
import '../utils/colors.dart';

class CardSubtitle extends StatelessWidget {
  final Stream stream;

  const CardSubtitle({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var document = snapshot.data!.docs.last;
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            Message message = Message.fromJson(data);
            return Row(
              children: [
                Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.light.withOpacity(.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('hh:mm').format(message.timestamp.toDate()),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: AppColors.light.withOpacity(.7)),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return Text(
            'no messages',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 15,
              color: AppColors.light.withOpacity(.7),
              fontWeight: FontWeight.w400,
            ),
          );
        });
  }
}
