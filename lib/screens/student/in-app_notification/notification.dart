import 'package:flutter/material.dart';
import '../../../widgets/notification_widget/notification_header.dart';
import '../../../widgets/notification_widget/notification_item.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button
          },
        ),
        title: Center(
          child: Text(
            'Notification',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Handle search
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView(
        children: [
          NotificationHeader(title: 'Today'),
          NotificationItem(
            icon: Icons.notifications,
            title: 'Reminder: "The Alchemist" is due on Feb 7.',
            subtitle: 'Return on time!',
            time: '9:01am',
          ),
          NotificationItem(
            icon: Icons.book,
            title: 'New Arrival: "AI & Future Tech" is now available!',
            subtitle: 'Reserve now.',
            time: '9:01am',
            action: 'SEE',
          ),
          NotificationItem(
            icon: Icons.money_off,
            title: 'You have been fined Rs.200 for late book submission.',
            time: '9:01am',
            action: 'PAY',
          ),
          NotificationHeader(title: 'Yesterday'),
          NotificationItem(
            icon: Icons.check_circle,
            title:
                'Book Reserved: "Harry Potter 4" is ready for pickup until Feb 10.',
            time: '9:01am',
          ),
          NotificationItem(
            icon: Icons.discount,
            title: 'Discount! Return overdue books by Feb 10 for 50% off.',
            time: '9:01am',
            action: 'PAY',
          ),
          NotificationHeader(title: 'This Week'),
          NotificationItem(
            icon: Icons.library_books,
            title: 'Renew Your Membership! Expires Feb 15.',
            subtitle: 'Renew now!',
            time: '9:01am',
          ),
          NotificationItem(
            icon: Icons.emoji_events,
            title: 'Congrats! You\'re the Top Reader of the Month!',
            time: '9:01am',
          ),
        ],
      ),
    );
  }
}
