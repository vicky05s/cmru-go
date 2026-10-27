import 'package:flutter/material.dart';

/// Demonstration-only campus content for the Campus Content Lists and Grids lab.
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.preview,
    required this.detail,
    required this.icon,
  });

  final String id;
  final String title;
  final String category;
  final String date;
  final String preview;
  final String detail;
  final IconData icon;
}

class CampusService {
  const CampusService({
    required this.id,
    required this.label,
    required this.icon,
    required this.destination,
    required this.description,
    required this.location,
    required this.hours,
  });

  final String id;
  final String label;
  final IconData icon;
  final String destination;
  final String description;
  final String location;
  final String hours;
}

const List<Announcement> demoAnnouncements = [
  Announcement(id: 'ann-001', title: 'Semester Registration Reminder', category: 'Academic', date: '27 Oct 2026', preview: 'Complete your semester registration before the deadline.', detail: 'Demonstration data: Students should review their registered courses and confirm semester registration by 31 October 2026. Contact the academic office if any course is missing.', icon: Icons.school_rounded),
  Announcement(id: 'ann-002', title: 'Library Extended Hours', category: 'Library', date: '26 Oct 2026', preview: 'The central library will remain open later during assessment week.', detail: 'Demonstration data: The central library is scheduled to stay open until 9:00 PM during assessment week. Carry your student ID and follow the library quiet-zone guidelines.', icon: Icons.local_library_rounded),
  Announcement(id: 'ann-003', title: 'Career Readiness Workshop', category: 'Career', date: '25 Oct 2026', preview: 'Register for a practical session on CVs and interview preparation.', detail: 'Demonstration data: The Career Services team will host a CV and interview preparation workshop on 30 October at 2:00 PM in Seminar Hall 2. Registration is limited and should be completed in advance.', icon: Icons.work_outline_rounded),
  Announcement(id: 'ann-004', title: 'Campus Shuttle Update', category: 'Transport', date: '24 Oct 2026', preview: 'A temporary change affects the evening shuttle pickup point.', detail: 'Demonstration data: The evening shuttle pickup point will temporarily move to the east gate from 28 to 30 October. Please arrive ten minutes early and check campus notices for updates.', icon: Icons.directions_bus_rounded),
  Announcement(id: 'ann-005', title: 'Innovation Club Meetup', category: 'Student Life', date: '23 Oct 2026', preview: 'Meet fellow makers and share project ideas at the next club meetup.', detail: 'Demonstration data: Innovation Club meets on 29 October at 4:00 PM in the Project Lab. Bring a project idea or join a team. New members are welcome.', icon: Icons.lightbulb_outline_rounded),
  Announcement(id: 'ann-006', title: 'Sports Trials Registration', category: 'Sports', date: '22 Oct 2026', preview: 'Sign up for campus team trials before registration closes.', detail: 'Demonstration data: Sports team trials are planned for the first week of November. Register with the Sports Centre and bring your student ID, sportswear and water bottle.', icon: Icons.sports_basketball_rounded),
  Announcement(id: 'ann-007', title: 'IT Helpdesk Maintenance', category: 'IT Services', date: '21 Oct 2026', preview: 'Some campus Wi-Fi services may briefly disconnect overnight.', detail: 'Demonstration data: Scheduled network maintenance is planned from 11:30 PM to 12:30 AM on 28 October. Save your work before the maintenance window. Report persistent issues to the IT Helpdesk.', icon: Icons.wifi_rounded),
  Announcement(id: 'ann-008', title: 'Wellbeing and Counselling Hours', category: 'Student Support', date: '20 Oct 2026', preview: 'Students can book confidential wellbeing support sessions.', detail: 'Demonstration data: The Counselling Centre offers confidential appointments on weekdays. Visit the Student Support desk to request an appointment or ask about available session times.', icon: Icons.favorite_border_rounded),
];

const List<CampusService> demoCampusServices = [
  CampusService(id: 'svc-library', label: 'Library', icon: Icons.local_library_rounded, destination: 'Library Services', description: 'Explore study spaces, borrowing guidance and library support.', location: 'Central Library, Ground Floor', hours: 'Mon–Sat, 8:00 AM–9:00 PM'),
  CampusService(id: 'svc-counselling', label: 'Counselling', icon: Icons.support_rounded, destination: 'Counselling Centre', description: 'Find wellbeing resources and appointment information.', location: 'Student Wellness Centre', hours: 'Mon–Fri, 9:00 AM–5:00 PM'),
  CampusService(id: 'svc-accommodation', label: 'Accommodation', icon: Icons.apartment_rounded, destination: 'Accommodation Office', description: 'Get guidance about hostel facilities and accommodation queries.', location: 'Student Affairs Block, Room 104', hours: 'Mon–Fri, 9:30 AM–4:30 PM'),
  CampusService(id: 'svc-career', label: 'Career Services', icon: Icons.work_outline_rounded, destination: 'Career Services', description: 'Explore placement preparation, workshops and career guidance.', location: 'Career Development Centre', hours: 'Mon–Fri, 9:00 AM–5:00 PM'),
  CampusService(id: 'svc-sports', label: 'Sports', icon: Icons.sports_soccer_rounded, destination: 'Sports Centre', description: 'View sports facilities, trial information and activity support.', location: 'Campus Sports Complex', hours: 'Daily, 6:00 AM–8:00 PM'),
  CampusService(id: 'svc-it', label: 'IT Helpdesk', icon: Icons.computer_rounded, destination: 'IT Helpdesk', description: 'Get help with Wi-Fi, student accounts and campus technology.', location: 'IT Services Desk, Block B', hours: 'Mon–Sat, 8:30 AM–5:30 PM'),
];
