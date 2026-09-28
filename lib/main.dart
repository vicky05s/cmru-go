import 'package:flutter/material.dart';

void main() => runApp(const CmruGoApp());

/// ---------------------------------------------------------------
/// CMRU Go  |  Student Campus App  |  CMR University, Bengaluru
/// Student : Viknesh Sreedevi   USN : 23BBTCS199
/// B.Tech. CSE  |  Semester 7  |  Section D  |  Lakeside Campus
/// ---------------------------------------------------------------

// ============================== THEME ===============================
// ---- CMRU brand colours ----
const Color cmruTeal = Color(0xFF00AFAA);
const Color cmruDarkTeal = Color(0xFF087F7B);
const Color cmruLightTeal = Color(0xFFE0F5F3);
const Color pageBackground = Color(0xFFF4FAF9);
const Color darkText = Color(0xFF173333);
const Color mutedText = Color(0xFF708484);

class C {
  static const teal = cmruTeal;
  static const tealDark = cmruDarkTeal;
  static const tealLight = cmruLightTeal;
  static const mint = pageBackground;
  static const navy = darkText;
  static const muted = mutedText;
  static const border = Color(0xFFD5EBE9);
  static const orange = Color(0xFFF2994A);
  static const red = Color(0xFFE5484D);
}

class T {
  // Main heading
  static const h1 = TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: C.navy, height: 1.2);
  // Sub heading
  static const h2 = TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: C.navy);
  // Body
  static const body = TextStyle(fontSize: 14, color: C.navy, height: 1.4);
  // Muted secondary
  static const muted = TextStyle(fontSize: 12.5, color: C.muted, height: 1.35);
  // Quote (serif, italic)
  static const quote = TextStyle(
      fontFamily: 'serif', fontStyle: FontStyle.italic, fontSize: 15, color: C.navy, height: 1.3);
}

class CmruGoApp extends StatelessWidget {
  const CmruGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMRU Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: C.teal, primary: C.teal),
        scaffoldBackgroundColor: C.mint,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: C.navy),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final page = kRoutes[settings.name] ?? 0;
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 220),
          pageBuilder: (_, __, ___) => HomeShell(page: page),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }
}

// ============================== MODELS ==============================
class Assignment {
  Assignment(this.title, this.course, this.due, this.submitted, this.icon);
  String title, course, due;
  bool submitted;
  IconData icon;
}

class CampusEvent {
  CampusEvent(this.title, this.date, this.time, this.location, this.desc, this.icon);
  String title, date, time, location, desc;
  IconData icon;
  bool registered = false;
  bool fav = false;
}

class Course {
  const Course(this.name, this.code, this.faculty, this.attendance, this.progress, this.icon);
  final String name, code, faculty;
  final int attendance;
  final double progress;
  final IconData icon;
}

// ============================== HELPERS =============================
/// Rounded card with subtle border + shadow and ink-well tap.
Widget appCard({required Widget child, VoidCallback? onTap, EdgeInsets padding = const EdgeInsets.all(16)}) {
  return Card(
    margin: EdgeInsets.zero,
    elevation: 3,
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
    shadowColor: C.teal.withOpacity(0.25),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: C.border),
    ),
    child: InkWell(
      onTap: onTap,
      hoverColor: C.tealLight.withOpacity(0.45),
      splashColor: C.tealLight,
      highlightColor: C.tealLight.withOpacity(0.5),
      child: Padding(padding: padding, child: Align(alignment: Alignment.centerLeft, child: child)),
    ),
  );
}

Widget iconBox(IconData icon, {Color color = C.teal, double size = 44}) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
  child: Icon(icon, color: color, size: size * 0.5),
);

/// Responsive grid. With minH: rows use a minimum height (safe, no overflow).
/// Without minH: every row is stretched to equal height.
Widget grid(double width, List<Widget> kids, int cols, {double gap = 14, double? minH}) {
  if (cols <= 1) {
    return Column(children: [
      for (int i = 0; i < kids.length; i++) Padding(padding: EdgeInsets.only(bottom: i == kids.length - 1 ? 0 : gap), child: kids[i]),
    ]);
  }
  final rows = <Widget>[];
  for (int start = 0; start < kids.length; start += cols) {
    final cells = <Widget>[];
    for (int j = 0; j < cols; j++) {
      if (j > 0) cells.add(SizedBox(width: gap));
      final idx = start + j;
      Widget cell = idx < kids.length ? kids[idx] : const SizedBox.shrink();
      if (minH != null && idx < kids.length) {
        cell = ConstrainedBox(constraints: BoxConstraints(minHeight: minH), child: cell);
      }
      cells.add(Expanded(child: cell));
    }
    final row = minH != null
        ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: cells)
        : IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: cells));
    rows.add(Padding(padding: EdgeInsets.only(bottom: start + cols >= kids.length ? 0 : gap), child: row));
  }
  return Column(children: rows);
}

Widget sectionTitle(String text, {String? action, VoidCallback? onAction}) => Padding(
  padding: const EdgeInsets.only(top: 22, bottom: 12),
  child: Row(children: [
    Expanded(child: Text(text, style: T.h2)),
    if (action != null)
      TextButton(onPressed: onAction, child: Text(action, style: const TextStyle(color: C.teal, fontWeight: FontWeight.w600))),
  ]),
);

/// Logo with graceful fallback.
class Logo extends StatelessWidget {
  const Logo({super.key, this.height = 32, this.maxWidth = 100});
  final double height, maxWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: height),
      child: Image.asset(
        'assets/cmr_university_logo.png',
        height: height,
        fit: BoxFit.contain,
        alignment: Alignment.centerLeft,
        errorBuilder: (_, __, ___) => Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.school_rounded, color: C.teal, size: height * 0.8),
          const SizedBox(width: 4),
          const Text('CMRU', style: TextStyle(fontWeight: FontWeight.w800, color: C.teal)),
        ]),
      ),
    );
  }
}

// ======================== SHARED APP DATA ===========================
/// Data shared by every page so it survives page changes / back navigation.
class AppData extends ChangeNotifier {
  static final AppData i = AppData();
  bool announcementOpen = false;
  int notifications = 3;

  final List<Assignment> assignments = [
    Assignment('DBMS Mini Project', 'Database Management Systems', 'Due: 28 Sep', false, Icons.storage_rounded),
    Assignment('OS Lab Record', 'Operating Systems', 'Due: 30 Sep', false, Icons.memory_rounded),
    Assignment('DSA Problem Set 4', 'Data Structures and Algorithms', 'Due: 03 Oct', false, Icons.account_tree_rounded),
    Assignment('CN Case Study', 'Computer Networks', 'Submitted: 20 Sep', true, Icons.router_rounded),
  ];

  final List<CampusEvent> events = [
    CampusEvent('CMRU Tech & Innovation Event', '25 Sep', '10:00 AM', 'Lakeside Campus',
        'Hackathon demos, project expos and talks from industry mentors.', Icons.rocket_launch_rounded),
    CampusEvent('Student Club Activities', '28 Sep', '2:00 PM', 'Student Activity Area',
        'Meet the cultural, technical and sports clubs and pick your community.', Icons.groups_rounded),
    CampusEvent('Career & Development Session', '02 Oct', '11:00 AM', 'Seminar Hall',
        'Resume clinics, interview tips and placement roadmap for final years.', Icons.work_rounded),
    CampusEvent('CMRU Tech Fest 2025', '20 – 22 Oct', '9:00 AM', 'CMR University, Bengaluru',
        'A week of innovation, creativity and fun with the CMRU community.', Icons.celebration_rounded),
  ];

  void bump() => notifyListeners();
}

/// Route names (these make the browser Back button and Android Back work).
const Map<String, int> kRoutes = {
  '/': 0,
  '/events': 1,
  '/profile': 2,
  '/academics': 3,
  '/assignments': 4,
  '/courses': 5,
  '/services': 6,
};
const List<String> kRouteNames = ['/', '/events', '/profile', '/academics', '/assignments', '/courses', '/services'];

// ============================== SHELL ===============================
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.page = 0});
  final int page;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // page: 0 Home, 1 Events, 2 Profile, 3 Academics, 4 Assignments, 5 Courses, 6 Campus Services
  int get _page => widget.page;
  bool get _announcementOpen => AppData.i.announcementOpen;
  set _announcementOpen(bool v) => AppData.i.announcementOpen = v;
  int get _notifications => AppData.i.notifications;
  set _notifications(int v) => AppData.i.notifications = v;
  List<Assignment> get _assignments => AppData.i.assignments;
  List<CampusEvent> get _events => AppData.i.events;

  @override
  void initState() {
    super.initState();
    AppData.i.addListener(_sync);
  }

  @override
  void dispose() {
    AppData.i.removeListener(_sync);
    super.dispose();
  }

  // keep every open page in sync when shared data changes
  void _sync() {
    if (mounted) super.setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    AppData.i.bump();
  }

  static const List<Course> _courses = [
    Course('Data Structures and Algorithms', 'CS701', 'Dr. Ananya Rao', 92, 0.72, Icons.account_tree_rounded),
    Course('Operating Systems', 'CS702', 'Prof. Suresh Kumar', 85, 0.65, Icons.memory_rounded),
    Course('Database Management Systems', 'CS703', 'Dr. Meera Nair', 88, 0.80, Icons.storage_rounded),
    Course('Computer Networks', 'CS704', 'Prof. Arjun Reddy', 84, 0.60, Icons.router_rounded),
    Course('Software Engineering', 'CS705', 'Dr. Kavitha Iyer', 90, 0.70, Icons.code_rounded),
    Course('Artificial Intelligence', 'CS706', 'Dr. Rohit Sharma', 83, 0.55, Icons.psychology_rounded),
  ];

  int get _pending => _assignments.where((a) => !a.submitted).length;
  int get _registered => _events.where((e) => e.registered).length;
  int get _favs => _events.where((e) => e.fav).length;

  static const _titles = ['Home', 'Events', 'Profile', 'Academics', 'Assignments', 'Courses', 'Campus Services'];

  // ------------------------- actions -------------------------
  void _go(int i) {
    if (i == _page) return;
    final nav = Navigator.of(context);
    if (i == 0) {
      nav.popUntil((r) => r.isFirst);
    } else if (_page == 0) {
      nav.pushNamed(kRouteNames[i]);
    } else {
      nav.pushReplacementNamed(kRouteNames[i]);
    }
  }

  void _snack(String msg, {IconData icon = Icons.check_circle_rounded}) {
    final w = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: C.navy,
        elevation: 6,
        width: w > 600 ? 460 : null,
        margin: w > 600 ? null : const EdgeInsets.fromLTRB(16, 0, 16, 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
        content: Row(children: [
          Icon(icon, color: const Color(0xFF5FE0D6), size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
        ]),
      ));
  }

  void _notify() {
    _snack('You have $_notifications new notifications.', icon: Icons.notifications_active_rounded);
    setState(() => _notifications = 0);
  }

  Future<void> _addAssignment() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (_) => _AddAssignmentDialog(courses: _courses.map((c) => c.name).toList()),
    );
    if (result == null || !mounted) return;
    setState(() {
      _assignments.insert(0, Assignment(result[0], result[1], 'Due: 10 Oct', false, Icons.assignment_rounded));
    });
    _go(4);
    _snack('Assignment added successfully.', icon: Icons.add_task_rounded);
  }

  void _toggleAssignment(Assignment a) {
    setState(() {
      a.submitted = !a.submitted;
      a.due = a.submitted ? 'Submitted: today' : 'Due: 10 Oct';
    });
    _snack(a.submitted ? '"${a.title}" marked as submitted.' : '"${a.title}" moved back to pending.');
  }

  void _toggleRegister(CampusEvent e) {
    setState(() => e.registered = !e.registered);
    _snack(e.registered ? 'Event registered successfully.' : 'Registration cancelled.',
        icon: e.registered ? Icons.event_available_rounded : Icons.event_busy_rounded);
  }

  void _toggleFav(CampusEvent e) {
    setState(() => e.fav = !e.fav);
    _snack(e.fav ? 'Event added to favourites.' : 'Event removed from favourites.',
        icon: e.fav ? Icons.favorite_rounded : Icons.favorite_border_rounded);
  }

  // ---------------------------- build ----------------------------
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final navIndex = _page <= 2 ? _page : 0;

    return Scaffold(
      appBar: _appBar(w),
      drawer: _drawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: KeyedSubtree(key: ValueKey(_page), child: _body()),
          ),
        ),
      ),
      floatingActionButton: w >= 600
          ? FloatingActionButton.extended(
        onPressed: _addAssignment,
        tooltip: 'Add Assignment',
        backgroundColor: C.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Add Assignment', style: TextStyle(fontWeight: FontWeight.w700)),
      )
          : FloatingActionButton(
        onPressed: _addAssignment,
        tooltip: 'Add Assignment',
        backgroundColor: C.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_task_rounded),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        onTap: _go,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 12,
        selectedItemColor: C.teal,
        unselectedItemColor: C.muted,
        selectedIconTheme: const IconThemeData(size: 28),
        unselectedIconTheme: const IconThemeData(size: 24),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event_outlined), activeIcon: Icon(Icons.event_rounded), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _body() {
    switch (_page) {
      case 1:
        return _eventsPage();
      case 2:
        return _profilePage();
      case 3:
        return _academicsPage();
      case 4:
        return _assignmentsPage();
      case 5:
        return _coursesPage();
      case 6:
        return _servicesPage();
      default:
        return _homePage();
    }
  }

  // --------------------------- APP BAR ---------------------------
  PreferredSizeWidget _appBar(double w) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 64,
      elevation: 0,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.transparent,
      shape: const Border(bottom: BorderSide(color: C.border)),
      leadingWidth: 56,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu_rounded, size: 27),
          tooltip: 'Open menu',
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      titleSpacing: 0,
      title: Row(children: [
        Logo(height: 30, maxWidth: w < 420 ? 70 : 100),
        const SizedBox(width: 10),
        Container(width: 1, height: 26, color: C.border),
        const SizedBox(width: 10),
        Flexible(
          child: Text(_page == 0 ? 'CMRU Go' : _titles[_page],
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: C.navy, letterSpacing: 0.2)),
        ),
      ]),
      actions: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: _notify,
          icon: Badge(
            isLabelVisible: _notifications > 0,
            label: Text('$_notifications'),
            backgroundColor: C.red,
            child: const Icon(Icons.notifications_none_rounded, size: 27),
          ),
        ),
        const SizedBox(width: 4),
        InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => _go(2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: C.teal,
                child: Text('VS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
              ),
              if (w >= 720) ...[
                const SizedBox(width: 10),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text('Viknesh Sreedevi', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: C.navy)),
                  Text('B.Tech. CSE', style: TextStyle(fontSize: 11.5, color: C.muted)),
                ]),
                const Icon(Icons.keyboard_arrow_down_rounded, color: C.muted),
              ],
            ]),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ---------------------------- DRAWER ---------------------------
  Widget _drawer() {
    Widget item(IconData icon, String label, int page) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        minLeadingWidth: 24,
        horizontalTitleGap: 14,
        dense: true,
        visualDensity: const VisualDensity(vertical: -1),
        selected: _page == page,
        selectedTileColor: C.tealLight,
        selectedColor: C.teal,
        iconColor: C.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        onTap: () {
          Navigator.pop(context);
          _go(page);
        },
      ),
    );

    Widget extra(IconData icon, String label, String msg) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        minLeadingWidth: 24,
        horizontalTitleGap: 14,
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        iconColor: C.muted,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon),
        title: Text(label),
        onTap: () {
          Navigator.pop(context);
          _snack(msg, icon: icon);
        },
      ),
    );

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(children: [
        DrawerHeader(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: C.border)),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              const Logo(height: 38, maxWidth: 130),
              const SizedBox(height: 10),
              const Text('Viknesh Sreedevi', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: C.navy)),
              const Text('B.Tech. Computer Science Engineering', style: T.muted),
              const Text('USN: 23BBTCS199 • Sem 7 • Sec D', style: T.muted),
              const SizedBox(height: 4),
              Row(mainAxisSize: MainAxisSize.min, children: const [
                Icon(Icons.location_on_rounded, size: 15, color: C.teal),
                SizedBox(width: 3),
                Text('Lakeside Campus, CMR University',
                    style: TextStyle(fontSize: 12.5, color: C.tealDark, fontWeight: FontWeight.w700)),
              ]),
            ]),
          ),
        ),
        Expanded(
          child: ListView(padding: const EdgeInsets.only(top: 8), children: [
            item(Icons.home_rounded, 'Home', 0),
            item(Icons.school_rounded, 'Academics', 3),
            item(Icons.assignment_rounded, 'Assignments', 4),
            item(Icons.event_rounded, 'Events', 1),
            item(Icons.menu_book_rounded, 'Courses', 5),
            item(Icons.dashboard_customize_rounded, 'Campus Services', 6),
            item(Icons.person_rounded, 'Profile', 2),
            const Divider(height: 14, indent: 20, endIndent: 20),
            extra(Icons.rocket_launch_rounded, 'LEAP', 'Opening LEAP programme.'),
            extra(Icons.settings_rounded, 'Settings', 'Opening Settings.'),
            extra(Icons.help_outline_rounded, 'Help Centre', 'Opening Help Centre.'),
            extra(Icons.info_outline_rounded, 'About CMR University', 'CMR University • Nurturing Curious Minds.'),
          ]),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('“Learn Today,\nLead Tomorrow”', style: T.quote),
            SizedBox(height: 8),
            Text('CMR University', style: T.muted),
          ]),
        ),
      ]),
    );
  }

  // ============================ HOME =============================
  Widget _homePage() {
    return LayoutBuilder(builder: (context, box) {
      final pad = box.maxWidth >= 700 ? 24.0 : 16.0;
      final cw = box.maxWidth - pad * 2;
      final cols3 = cw >= 900 ? 3 : (cw >= 560 ? 2 : 1);
      final cols2 = cw >= 760 ? 2 : 1;

      return ListView(padding: EdgeInsets.all(pad), children: [
        _greeting(cw),
        const SizedBox(height: 16),
        _hero(cw),
        const SizedBox(height: 16),
        grid(cw, [_attendanceCard(), _assignmentsCard(), _upcomingClassCard()], cols3, minH: 165),
        const SizedBox(height: 14),
        grid(cw, [_announcementCard(), _upcomingEventsCard()], cols2, minH: 205),
        const SizedBox(height: 14),
        _quickAccess(cw),
        const SizedBox(height: 90),
      ]);
    });
  }

  Widget _greeting(double cw) {
    final left = Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
      Text('Good morning, Viknesh! 👋', style: T.h1),
      SizedBox(height: 6),
      Text('B.Tech. Computer Science Engineering', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: C.navy)),
      SizedBox(height: 2),
      Text('Semester 7 • Section D • USN: 23BBTCS199', style: T.muted),
    ]);
    final campusBadge = Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: C.tealLight, borderRadius: BorderRadius.circular(20)),
      child: const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.location_on_rounded, size: 16, color: C.teal),
        SizedBox(width: 4),
        Text('Lakeside Campus', style: TextStyle(fontWeight: FontWeight.w700, color: C.tealDark, fontSize: 13)),
      ]),
    );
    if (cw >= 720) {
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [left, campusBadge])),
        const SizedBox(width: 16),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('“A better you\nbuilds a brighter tomorrow.”', style: T.quote),
          SizedBox(height: 6),
          Text('CMR University', style: T.muted),
        ]),
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [left, campusBadge]);
  }

  Widget _hero(double cw) {
    final wide = cw >= 820;
    final h = wide ? 270.0 : (cw >= 520 ? 240.0 : 220.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: h,
        width: double.infinity,
        child: Stack(fit: StackFit.expand, children: [
          Image.asset(
            'assets/cmr_campus.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [C.tealDark, C.teal])),
              child: const Center(child: Icon(Icons.apartment_rounded, size: 72, color: Colors.white54)),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xE6173333), Color(0x99173333), Color(0x00000000)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
            ),
          ),
          Positioned(
            left: 22,
            top: 0,
            bottom: 0,
            right: wide ? 300 : 22,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('CMR University',
                  style: TextStyle(color: Colors.white, fontSize: wide ? 34 : 27, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Lakeside Campus, Bengaluru', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              const Text('Learn  |  Explore  |  Grow  |  Belong', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _snack('Opening campus tour.', icon: Icons.location_on_rounded),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: C.navy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                icon: const Text('Explore Campus', style: TextStyle(fontWeight: FontWeight.w700)),
                label: const Icon(Icons.arrow_forward_rounded, size: 18),
              ),
            ]),
          ),
          if (wide)
            Positioned(
              right: 18,
              top: 18,
              bottom: 18,
              width: 250,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xB3173333),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white38),
                ),
                child: const Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  _GlassRow(Icons.school_rounded, 'Knowledge', 'for a better tomorrow'),
                  _GlassRow(Icons.groups_rounded, 'Vibrant', 'Student Community'),
                  _GlassRow(Icons.eco_rounded, 'A Greener', 'Brighter Future'),
                ]),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _attendanceCard() {
    return appCard(
      onTap: () => _go(3),
      child: Row(children: [
        SizedBox(
          width: 86,
          height: 86,
          child: Stack(alignment: Alignment.center, children: const [
            SizedBox(
              width: 86,
              height: 86,
              child: CircularProgressIndicator(value: 0.87, strokeWidth: 9, backgroundColor: C.tealLight, color: C.teal, strokeCap: StrokeCap.round),
            ),
            Text('87%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: C.tealDark)),
          ]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: const [
            Text('Overall Attendance', style: T.h2),
            SizedBox(height: 2),
            Text('52 / 60 classes attended', style: T.muted),
            SizedBox(height: 6),
            Row(children: [
              Icon(Icons.trending_up_rounded, size: 16, color: C.teal),
              SizedBox(width: 4),
              Flexible(child: Text('Attendance is on track', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: C.tealDark))),
            ]),
            SizedBox(height: 4),
            Text('View subject-wise attendance →', style: TextStyle(fontSize: 12, color: C.teal, fontWeight: FontWeight.w600)),
          ]),
        ),
      ]),
    );
  }

  Widget _assignmentsCard() {
    return appCard(
      onTap: () => _go(4),
      child: Row(children: [
        iconBox(Icons.assignment_rounded, size: 56),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            const Text('Assignments Due', style: T.h2),
            const SizedBox(height: 2),
            const Text('Assignments left to submit', style: T.muted),
            const SizedBox(height: 6),
            const Text('View assignments →', style: TextStyle(fontSize: 12, color: C.teal, fontWeight: FontWeight.w600)),
          ]),
        ),
        Text('$_pending', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: C.teal)),
      ]),
    );
  }

  Widget _upcomingClassCard() {
    return appCard(
      onTap: () => _go(3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          iconBox(Icons.calendar_month_rounded, size: 38),
          const SizedBox(width: 10),
          const Expanded(child: Text('Upcoming Class', style: T.h2)),
          const Text('View all', style: TextStyle(color: C.teal, fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: C.mint, borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('Data Structures and Algorithms', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: C.navy)),
            SizedBox(height: 5),
            Row(children: [
              Icon(Icons.calendar_month_rounded, size: 14, color: C.muted),
              SizedBox(width: 5),
              Expanded(child: Text('Today, 10:00 AM – 11:00 AM', style: T.muted)),
            ]),
            SizedBox(height: 2),
            Row(children: [
              Icon(Icons.location_on_rounded, size: 14, color: C.muted),
              SizedBox(width: 5),
              Expanded(child: Text('Block A, Room 302', style: T.muted)),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _announcementCard() {
    return appCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          iconBox(Icons.campaign_rounded, color: C.red, size: 38),
          const SizedBox(width: 10),
          const Expanded(child: Text('Campus Announcement', style: T.h2)),
          const Text('2 hours ago', style: T.muted),
        ]),
        const SizedBox(height: 12),
        const Text('CMRU Tech Fest 2025', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: C.navy)),
        const SizedBox(height: 4),
        const Text('Registrations are open. Join us for innovation, creativity and fun with the CMRU community.', style: T.body),
        if (_announcementOpen)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
                'Three days of hackathons, project showcases, cultural nights and guest talks at Lakeside Campus. Form your team and register through Student Affairs.',
                style: T.muted),
          ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            setState(() => _announcementOpen = !_announcementOpen);
            if (_announcementOpen) _snack('Showing full announcement.', icon: Icons.campaign_rounded);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(_announcementOpen ? 'Show less ↑' : 'Read more →',
                style: const TextStyle(color: C.teal, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }

  Widget _upcomingEventsCard() {
    final e = _events[3];
    return appCard(
      onTap: () => _go(1),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          iconBox(Icons.event_rounded, size: 38),
          const SizedBox(width: 10),
          const Expanded(child: Text('Upcoming Events', style: T.h2)),
          const Text('View all', style: TextStyle(color: C.teal, fontWeight: FontWeight.w600, fontSize: 13)),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Container(
            width: 92,
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [C.tealDark, C.navy], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.celebration_rounded, color: Colors.white70, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(e.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: C.navy)),
              const SizedBox(height: 5),
              Row(children: [
                const Icon(Icons.event_rounded, size: 14, color: C.muted),
                const SizedBox(width: 5),
                Expanded(child: Text('${e.date} October 2025', style: T.muted)),
              ]),
              Row(children: [
                const Icon(Icons.location_on_rounded, size: 14, color: C.muted),
                const SizedBox(width: 5),
                Expanded(child: Text(e.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.muted)),
              ]),
            ]),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: C.tealLight, shape: BoxShape.circle, border: Border.all(color: C.border)),
            child: const Icon(Icons.chevron_right_rounded, color: C.navy),
          ),
        ]),
      ]),
    );
  }

  Widget _quickAccess(double cw) {
    final cards = _serviceCards();
    final head = Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: const [
      Text('Quick Access', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: C.navy)),
      SizedBox(height: 4),
      Text('Everything you need, in one place.', style: T.muted),
    ]);
    final quote = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: C.tealLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: C.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
        const Text('“Same Campus\nBigger Dreams”', style: T.quote),
        const SizedBox(height: 10),
        Container(width: 28, height: 3, color: C.teal),
        const SizedBox(height: 8),
        const Text('CMR University', style: T.muted),
      ]),
    );

    if (cw >= 980) {
      final row = <Widget>[SizedBox(width: 170, child: head)];
      for (final c in cards) {
        row.add(const SizedBox(width: 12));
        row.add(Expanded(child: c));
      }
      return IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(child: appCard(child: Row(children: row))),
          const SizedBox(width: 14),
          SizedBox(width: 220, child: quote),
        ]),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      appCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          head,
          const SizedBox(height: 14),
          grid(cw - 34, cards, cw >= 560 ? 4 : 2, gap: 12),
        ]),
      ),
      const SizedBox(height: 14),
      SizedBox(width: double.infinity, child: quote),
    ]);
  }

  List<Widget> _serviceCards() {
    Widget card(IconData icon, String t, String s, Color c, VoidCallback tap) => appCard(
      onTap: tap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        iconBox(icon, color: c, size: 44),
        const SizedBox(height: 12),
        Text(t, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: C.navy)),
        const SizedBox(height: 2),
        Text(s, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.muted),
      ]),
    );
    return [
      card(Icons.library_books_rounded, 'Library', 'Explore resources', C.teal,
              () => _snack('Opening Library.', icon: Icons.library_books_rounded)),
      card(Icons.calendar_month_rounded, 'Timetable', 'View class schedule', const Color(0xFF3B82F6),
              () => _snack('Opening Timetable.', icon: Icons.calendar_month_rounded)),
      card(Icons.school_rounded, 'My Courses', 'Access materials', C.orange, () => _go(5)),
      card(Icons.location_on_rounded, 'Campus Map', 'Navigate campus', const Color(0xFF8B5CF6),
              () => _snack('Opening Campus Map.', icon: Icons.location_on_rounded)),
    ];
  }

  // =========================== EVENTS ============================
  Widget _eventsPage() {
    return LayoutBuilder(builder: (context, box) {
      final pad = box.maxWidth >= 700 ? 24.0 : 16.0;
      final cw = box.maxWidth - pad * 2;
      final cols = cw >= 900 ? 3 : (cw >= 600 ? 2 : 1);
      return ListView(padding: EdgeInsets.all(pad), children: [
        const Text('Events & Activities', style: T.h1),
        const SizedBox(height: 4),
        Text('$_registered registered • $_favs favourites • ${_events.length} upcoming', style: T.muted),
        const SizedBox(height: 16),
        grid(cw, List.generate(_events.length, _eventCard), cols),
        const SizedBox(height: 90),
      ]);
    });
  }

  Widget _eventCard(int i) {
    final e = _events[i];
    Widget info(IconData ic, String t) => Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(children: [
        Icon(ic, size: 16, color: C.teal),
        const SizedBox(width: 8),
        Expanded(child: Text(t, style: T.body.copyWith(fontSize: 13.5))),
      ]),
    );
    return appCard(
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 112,
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [C.tealDark, C.teal], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Stack(children: [
            Center(child: Icon(e.icon, size: 54, color: Colors.white38)),
            Positioned(
              left: 14,
              top: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Text(e.date, style: const TextStyle(fontWeight: FontWeight.w800, color: C.tealDark, fontSize: 13)),
              ),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: IconButton(
                tooltip: e.fav ? 'Remove from favourites' : 'Add to favourites',
                onPressed: () => _toggleFav(e),
                icon: Icon(e.fav ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: e.fav ? Colors.white : Colors.white70),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.title, style: T.h2),
            const SizedBox(height: 8),
            info(Icons.access_time_rounded, e.time),
            info(Icons.location_on_rounded, e.location),
            const SizedBox(height: 4),
            Text(e.desc, style: T.muted),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: e.registered
                  ? OutlinedButton.icon(
                onPressed: () => _toggleRegister(e),
                icon: const Icon(Icons.check_circle_rounded, size: 18),
                label: const Text('Registered'),
                style: OutlinedButton.styleFrom(foregroundColor: C.tealDark, side: const BorderSide(color: C.teal)),
              )
                  : FilledButton.icon(
                onPressed: () => _toggleRegister(e),
                icon: const Icon(Icons.how_to_reg_rounded, size: 18),
                label: const Text('Register'),
                style: FilledButton.styleFrom(backgroundColor: C.teal),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  // =========================== PROFILE ===========================
  Widget _profilePage() {
    return LayoutBuilder(builder: (context, box) {
      final pad = box.maxWidth >= 700 ? 24.0 : 16.0;
      final cw = box.maxWidth - pad * 2;
      final cols = cw >= 700 ? 2 : 1;

      Widget tile(IconData ic, String label, String value) => appCard(
        child: Row(children: [
          iconBox(ic, size: 42),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(label, style: T.muted),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: C.navy)),
            ]),
          ),
        ]),
      );

      Widget stat(String n, String l) => Expanded(
        child: Column(children: [
          Text(n, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 2),
          Text(l, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ]),
      );

      return ListView(padding: EdgeInsets.all(pad), children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [C.tealDark, C.teal], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(children: [
            const CircleAvatar(
              radius: 46,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 42,
                backgroundColor: C.tealLight,
                child: Text('VS', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: C.tealDark)),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Viknesh Sreedevi', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 4),
            const Text('USN: 23BBTCS199', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                stat('$_pending', 'Pending'),
                stat('$_registered', 'Registered'),
                stat('$_favs', 'Favourites'),
              ]),
            ),
          ]),
        ),
        sectionTitle('Student Information'),
        grid(cw, [
          tile(Icons.school_rounded, 'Programme', 'B.Tech. Computer Science Engineering'),
          tile(Icons.calendar_month_rounded, 'Semester', 'Semester 7'),
          tile(Icons.groups_rounded, 'Section', 'Section D'),
          tile(Icons.badge_rounded, 'USN / Student ID', '23BBTCS199'),
          tile(Icons.location_on_rounded, 'Campus', 'Lakeside Campus'),
          tile(Icons.account_balance_rounded, 'University', 'CMR University, Bengaluru'),
        ], cols),
        sectionTitle('Contact'),
        grid(cw, [
          tile(Icons.email_rounded, 'Email', 'viknesh.s@cmr.edu.in'),
          tile(Icons.phone_rounded, 'Phone', '+91 89213 69431'),
        ], cols),
        const SizedBox(height: 90),
      ]);
    });
  }

  // ========================== ACADEMICS ==========================
  Widget _academicsPage() {
    return LayoutBuilder(builder: (context, box) {
      final pad = box.maxWidth >= 700 ? 24.0 : 16.0;
      final cw = box.maxWidth - pad * 2;
      final cols = cw >= 900 ? 3 : (cw >= 600 ? 2 : 1);
      return ListView(padding: EdgeInsets.all(pad), children: [
        const Text('Academics', style: T.h1),
        const SizedBox(height: 12),
        appCard(
          child: Row(children: [
            iconBox(Icons.school_rounded, size: 54),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Semester 7 • Section D', style: T.h2),
                SizedBox(height: 2),
                Text('B.Tech. Computer Science Engineering', style: T.body),
                SizedBox(height: 2),
                Text('USN: 23BBTCS199', style: T.muted),
              ]),
            ),
          ]),
        ),
        sectionTitle('Courses this semester'),
        grid(cw, _courses.map(_courseCard).toList(), cols),
        const SizedBox(height: 90),
      ]);
    });
  }

  Widget _courseCard(Course c) {
    final good = c.attendance >= 85;
    return appCard(
      onTap: () => _snack('${c.name} • ${c.attendance}% attendance', icon: c.icon),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          iconBox(c.icon, size: 42),
          const SizedBox(width: 12),
          Expanded(child: Text(c.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: C.navy))),
        ]),
        const SizedBox(height: 10),
        Text('${c.code} • ${c.faculty}', style: T.muted),
        const SizedBox(height: 12),
        Row(children: [
          const Text('Course progress', style: T.muted),
          const Spacer(),
          Text('${(c.progress * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w700, color: C.tealDark, fontSize: 13)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: c.progress, minHeight: 8, backgroundColor: C.tealLight, color: C.teal),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: (good ? C.teal : C.orange).withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Attendance ${c.attendance}% • ${good ? 'On track' : 'Needs attention'}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: good ? C.tealDark : C.orange)),
        ),
      ]),
    );
  }

  // ========================= ASSIGNMENTS =========================
  Widget _assignmentsPage() {
    return LayoutBuilder(builder: (context, box) {
      final pad = box.maxWidth >= 700 ? 24.0 : 16.0;
      final cw = box.maxWidth - pad * 2;
      final cols = cw >= 760 ? 2 : 1;
      return ListView(padding: EdgeInsets.all(pad), children: [
        const Text('Assignments', style: T.h1),
        const SizedBox(height: 4),
        Text('$_pending pending • ${_assignments.length - _pending} submitted • Tap a card to toggle status', style: T.muted),
        const SizedBox(height: 16),
        grid(cw, _assignments.map(_assignmentCard).toList(), cols),
        const SizedBox(height: 90),
      ]);
    });
  }

  Widget _assignmentCard(Assignment a) {
    final col = a.submitted ? C.teal : C.orange;
    return appCard(
      onTap: () => _toggleAssignment(a),
      child: Row(children: [
        iconBox(a.icon, color: col, size: 48),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(a.title, style: T.h2),
            const SizedBox(height: 2),
            Text(a.course, maxLines: 1, overflow: TextOverflow.ellipsis, style: T.muted),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.calendar_month_rounded, size: 14, color: C.muted),
              const SizedBox(width: 4),
              Flexible(child: Text(a.due, style: T.muted)),
            ]),
          ]),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: col.withOpacity(0.13), borderRadius: BorderRadius.circular(20)),
          child: Text(a.submitted ? 'Submitted' : 'Pending', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: col)),
        ),
      ]),
    );
  }

  // ============================ COURSES ==========================
  Widget _coursesPage() {
    return LayoutBuilder(builder: (context, box) {
      final pad = box.maxWidth >= 700 ? 24.0 : 16.0;
      final cw = box.maxWidth - pad * 2;
      final cols = cw >= 900 ? 3 : (cw >= 560 ? 2 : 1);
      return ListView(padding: EdgeInsets.all(pad), children: [
        const Text('My Courses', style: T.h1),
        const SizedBox(height: 4),
        Text('${_courses.length} active courses • Semester 7', style: T.muted),
        const SizedBox(height: 16),
        grid(
          cw,
          _courses
              .map((c) => appCard(
            onTap: () => _snack('Opening ${c.name} materials.', icon: Icons.menu_book_rounded),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              iconBox(c.icon, size: 48),
              const SizedBox(height: 12),
              Text(c.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: T.h2),
              const SizedBox(height: 4),
              Text(c.code, style: const TextStyle(color: C.teal, fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 2),
              Text(c.faculty, style: T.muted),
              const SizedBox(height: 10),
              const Text('Open materials →', style: TextStyle(color: C.teal, fontWeight: FontWeight.w600, fontSize: 12.5)),
            ]),
          ))
              .toList(),
          cols,
        ),
        const SizedBox(height: 90),
      ]);
    });
  }

  // ======================== CAMPUS SERVICES ======================
  Widget _servicesPage() {
    return LayoutBuilder(builder: (context, box) {
      final pad = box.maxWidth >= 700 ? 24.0 : 16.0;
      final cw = box.maxWidth - pad * 2;
      final cols = cw >= 900 ? 3 : 2;

      Widget card(IconData icon, String t, String s, Color c, VoidCallback tap) => appCard(
        onTap: tap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          iconBox(icon, color: c, size: 48),
          const SizedBox(height: 12),
          Text(t, style: T.h2),
          const SizedBox(height: 2),
          Text(s, style: T.muted),
        ]),
      );

      return ListView(padding: EdgeInsets.all(pad), children: [
        const Text('Campus Services', style: T.h1),
        const SizedBox(height: 4),
        const Text('Everything you need, in one place.', style: T.muted),
        const SizedBox(height: 16),
        grid(cw, [
          ..._serviceCards(),
          card(Icons.groups_rounded, 'Student Affairs', 'Clubs & activities', const Color(0xFFEC4899),
                  () => _snack('Opening Student Affairs.', icon: Icons.groups_rounded)),
          card(Icons.work_rounded, 'Career Services', 'Placements & internships', const Color(0xFF14B8A6),
                  () => _snack('Opening Career Services.', icon: Icons.work_rounded)),
        ], cols),
        const SizedBox(height: 90),
      ]);
    });
  }
}

// ========================= SMALL WIDGETS ==========================
class _GlassRow extends StatelessWidget {
  const _GlassRow(this.icon, this.title, this.sub);
  final IconData icon;
  final String title, sub;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: Colors.white, size: 26),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
          Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      ),
    ]);
  }
}

/// FAB dialog: Add Assignment (title + course).
class _AddAssignmentDialog extends StatefulWidget {
  const _AddAssignmentDialog({required this.courses});
  final List<String> courses;

  @override
  State<_AddAssignmentDialog> createState() => _AddAssignmentDialogState();
}

class _AddAssignmentDialogState extends State<_AddAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _course = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _course.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(children: const [
        Icon(Icons.add_task_rounded, color: C.teal),
        SizedBox(width: 10),
        Expanded(child: Text('Add Assignment', style: T.h2)),
      ]),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextFormField(
                controller: _title,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Assignment title', prefixIcon: Icon(Icons.assignment_rounded), border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _course,
                decoration: const InputDecoration(labelText: 'Course', prefixIcon: Icon(Icons.menu_book_rounded), border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a course' : null,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 0,
                children: widget.courses
                    .map((c) => ActionChip(
                  label: Text(c, style: const TextStyle(fontSize: 11.5)),
                  onPressed: () => setState(() => _course.text = c),
                ))
                    .toList(),
              ),
            ]),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: C.teal),
          icon: const Icon(Icons.save_rounded, size: 18),
          label: const Text('Save Assignment'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, [_title.text.trim(), _course.text.trim()]);
            }
          },
        ),
      ],
    );
  }
}