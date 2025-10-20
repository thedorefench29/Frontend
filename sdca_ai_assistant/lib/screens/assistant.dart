import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui_web' as ui;
import '../services/auth_service.dart';

class _TopNav extends StatefulWidget {
  const _TopNav();

  @override
  State<_TopNav> createState() => _TopNavState();
}

class _TopNavState extends State<_TopNav> with SingleTickerProviderStateMixin {
  bool _menuOpen = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 620;
 

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A0A0A),
            const Color(0xFF0F0505),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 24,
                vertical: isMobile ? 6 : 10,
              ),
              child: Row(
                mainAxisAlignment:
                    isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/Logo_white.png',
                    height: isMobile ? 45 : 50,
                  ).animate().fadeIn(duration: 400.ms).moveY(begin: -8, end: 0, curve: Curves.easeOut),

                  if (!isMobile) ...[
                    const Spacer(),
                    _NavButton(
                      label: 'Home',
                      onTap: () {
                        if (ModalRoute.of(context)?.settings.name != '/') {
                          Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    if (_authService.isLoggedIn) ...[
                      Text(
                        'Welcome, ${_authService.userName ?? "Audrey Maven"}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _NavButton(
                        label: 'Logout',
                        onTap: () {
                          _authService.logout();
                          Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
                        },
                      ),
                    ] else
                      _NavButton(
                        label: 'Account',
                        onTap: () => Navigator.pushNamed(context, '/login'),
                      ),
                  ] else
                    // mobile menu icon
                    IconButton(
                      icon: Icon(_menuOpen ? Icons.close : Icons.menu, color: Colors.white),
                      onPressed: () => setState(() => _menuOpen = !_menuOpen),
                    ),
                ],
              ),
            ),

            // MOBILE DROPDOWN
            if (isMobile)
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: _menuOpen ? 200 : 0,
                  ),
                  child: SingleChildScrollView(
                    // prevent overflow if many items
                    physics: _menuOpen ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                    child: Opacity(
                      opacity: _menuOpen ? 1 : 0,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B0000).withValues(alpha:0.95),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha:0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _DropdownItem(
                              label: 'Home',
                              onTap: () {
                                setState(() => _menuOpen = false);
                                Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                              },
                            ),
                            if (_authService.isLoggedIn) ...[
                              const Divider(height: 1, color: Colors.white24),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Text(
                                  'Welcome, ${_authService.userName ?? "Audrey Maven"}!',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const Divider(height: 1, color: Colors.white24),
                              _DropdownItem(
                                label: 'Logout',
                                onTap: () {
                                  setState(() => _menuOpen = false);
                                  _authService.logout();
                                  Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
                                },
                              ),
                            ] else ...[
                              const Divider(height: 1, color: Colors.white24),
                              _DropdownItem(
                                label: 'Account',
                                onTap: () {
                                  setState(() => _menuOpen = false);
                                  Navigator.pushNamed(context, '/login');
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DropdownItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DropdownItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  const _NavButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? Colors.white.withValues(alpha:0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ).animate(target: _hovered ? 1 : 0).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.04, 1.04),
              duration: 120.ms,
            ),
      ),
    );
  }
}


class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final List<_ChatMessage> _messages = <_ChatMessage>[];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _scrolled = false;

  late final Map<String, _AssistantResponse> _responses = <String, _AssistantResponse>{
    'apply': _AssistantResponse(
      reply:
          'To apply to SDCA: \n\n1.) Fill out the online application form, \n\n2.) Submit your PSA birth certificate and report card, \n\n3.) Pay the ₱500 application fee, \n\n4.) Wait for the confirmation email within 3-5 business days.',
      buttons: const [
        _QuickButton(label: 'Apply Now', icon: Icons.rocket_launch_outlined, action: 'apply'),
        _QuickButton(label: 'Admission Checklist', icon: Icons.checklist_outlined, action: 'apply/checklist'),
        _QuickButton(label: 'Contact Admissions', icon: Icons.support_agent_outlined, action: 'contact/admissions'),
      ],
      followUp: 'Would you like to see the complete admission requirements?',
    ),
    'programs': _AssistantResponse(
      reply:
          'SDCA offers diverse programs including: \n\n🩺 BS Nursing, \n\n💼 BS Business Administration, \n\n💻 BS Computer Science, \n\n👨‍🏫 BS Education, \n\n🏨 BS Hospitality Management, \n\nand more. Each program is designed with industry-relevant curriculum and experienced faculty.',
      buttons: const [
        _QuickButton(label: 'View All Programs', icon: Icons.menu_book_outlined, action: 'programs'),
        _QuickButton(label: 'Program Details', icon: Icons.description_outlined, action: 'programs/details'),
        _QuickButton(label: 'Career Paths', icon: Icons.cases_outlined, action: 'programs/careers'),
      ],
      followUp: 'Which program interests you? I can provide specific details!',
    ),
    'fees': _AssistantResponse(
      reply:
          'Tuition fees vary by program: \n\nBS Nursing ₱40,000–₱50,000/sem, \n\nBS Computer Science ₱35,000–₱45,000/sem, \n\nBS Business Administration ₱30,000–₱40,000/sem. \n\nFees include lab costs and may have payment plan options.',
      buttons: const [
        _QuickButton(label: 'View Full Fee Breakdown', icon: Icons.savings_outlined, action: 'fees'),
        _QuickButton(label: 'Payment Schedule', icon: Icons.schedule_outlined, action: 'fees/payment'),
        _QuickButton(label: 'Scholarships', icon: Icons.workspace_premium_outlined, action: 'scholarship'),
      ],
      followUp: 'Would you like information about scholarships and payment plans?',
    ),
    'location': _AssistantResponse(
      reply:
          'St. Dominic College of Asia is located at EMILIO AGUINALDO HIGHWAY TALABA III, CITY OF BACOOR, PHILIPPINES 4102. \n\nWe\'re easily accessible via public transportation and have ample parking for students and visitors. (Use View Map for directions.)',
      buttons: const [
        _QuickButton(label: 'View Map', icon: Icons.map_outlined, action: 'location/map'),
        _QuickButton(label: 'Transportation Guide', icon: Icons.directions_bus_outlined, action: 'transport'),
        _QuickButton(label: 'Contact Us', icon: Icons.call_outlined, action: 'contact'),
      ],
      followUp: 'Need directions or transportation options from your area?',
    ),
    'transport': _AssistantResponse(
      reply:
          '🚌 Transportation Guide\n\nFrom Dasmariñas Bayan:\n• Ride a tricycle or jeepney to Golden City Subdivision.\n• Stop at St. Dominic College of Asia.\n\nFrom Imus or Bacoor:\n• Ride a jeepney or bus going to Dasmariñas.\n• Transfer to a tricycle going to Golden City Subdivision.\n\n🚗 Private Vehicle:\n• Enter via Salawag Road and follow signs to SDCA.',
      buttons: const [
        _QuickButton(label: 'View Map', icon: Icons.map_outlined, action: 'location/map'),
        _QuickButton(label: 'Contact Us', icon: Icons.call_outlined, action: 'contact'),
      ],
      followUp: 'Would you like help with specific directions from your area?',
    ),
    'enrollment': _AssistantResponse(
      reply:
          'Enrollment process: 1) Complete admission requirements and get accepted, 2) Submit enrollment forms to the Registrar, 3) Pay tuition fees at the Finance Office, 4) Receive your class schedule, 5) Attend orientation. Enrollment periods are typically 2-3 weeks before each semester.',
      buttons: const [
        _QuickButton(label: 'Enrollment Guide', icon: Icons.menu_book_outlined, action: 'enroll'),
        _QuickButton(label: 'Requirements List', icon: Icons.checklist_outlined, action: 'enroll/requirements'),
        _QuickButton(label: 'Important Dates', icon: Icons.calendar_month_outlined, action: 'calendar'),
      ],
      followUp: 'Need help with a specific enrollment step?',
    ),
    'schedule': _AssistantResponse(
      reply:
          'Class schedules are available through the Student Portal after enrollment. You can view your schedule, room assignments, instructor details, and any schedule changes online. For schedule concerns or conflicts, contact the Registrar\'s Office.',
      buttons: const [
        _QuickButton(label: 'Student Portal', icon: Icons.desktop_windows_outlined, action: 'portal'),
        _QuickButton(label: 'Contact Registrar', icon: Icons.contact_phone_outlined, action: 'contact/registrar'),
        _QuickButton(label: 'Academic Calendar', icon: Icons.calendar_month_outlined, action: 'calendar'),
      ],
      followUp: 'Do you need help accessing the Student Portal?',
    ),
    'contact': _AssistantResponse(
      reply:
          '📞 Contact Information\n\nBasic Education\n📱 +63 998 551 7972\n✉️ bedadmission@sdca.edu.ph\n\nHigher Education\n📱 +63 998 551 8001\n✉️ hedadmission@sdca.edu.ph\n\nSchool of Medicine\n📱 +63 998 551 8021\n✉️ som_admission@sdca.edu.ph\n\n🕐 Office Hours\nMon–Fri: 8:00 AM – 5:00 PM\nSat: 8:00 AM – 12:00 PM\n\n🏫 Visit the Admin Building for in-person assistance.',
      buttons: const [
        _QuickButton(label: 'Send Message', icon: Icons.mail_outline, action: 'message'),
        _QuickButton(label: 'Social Media', icon: Icons.share_outlined, action: 'social'),
      ],
      followUp: 'Which office would you like to contact?',
    ),
    'scholarship': _AssistantResponse(
      reply:
          'SDCA offers various scholarships: Academic Excellence (based on grades), Athletic Scholarships, Financial Assistance, Employee Dependents, and External Scholarships. Requirements vary by scholarship type. Applications are typically reviewed each semester.',
      buttons: const [
        _QuickButton(label: 'Scholarship Programs', icon: Icons.workspace_premium_outlined, action: 'scholarship'),
        _QuickButton(label: 'Application Form', icon: Icons.assignment_outlined, action: 'scholarships/apply'),
        _QuickButton(label: 'Contact Financial Aid', icon: Icons.support_agent_outlined, action: 'contact/financial-aid'),
      ],
      followUp: 'Which scholarship program would you like to know more about?',
    ),
    'default': _AssistantResponse(
      reply:
          "I'm here to help with admissions, enrollment, tuition, schedules, programs, and campus services. Could you please clarify your question? You can ask about applications, view programs, check fees, or get contact information.",
      buttons: const [
        _QuickButton(label: 'View FAQs', icon: Icons.help_outline, action: 'faq'),
        _QuickButton(label: 'Contact Support', icon: Icons.support_agent_outlined, action: 'contact'),
        _QuickButton(label: 'Visit Homepage', icon: Icons.home_outlined, action: 'home'),
      ],
      followUp: 'What specific information do you need?',
    ),
  };

  @override
  void initState() {
    super.initState();
    _seedGreeting();
    _scrollController.addListener(() {
      final nowScrolled = _scrollController.hasClients && _scrollController.offset > 2;
      if (nowScrolled != _scrolled) {
        setState(() => _scrolled = nowScrolled);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(jump: true));
  }

  void _seedGreeting() {
    _messages.add(
      _ChatMessage(
        fromUser: false,
        text:
            "Hi there! 👋  Welcome to St. Dominic College of Asia. I'm your virtual assistant, here to help with admissions, enrollment, tuition fees, class schedules, campus services, and contact information. How can I assist you today?",
        buttons: const [
          _QuickButton(label: 'Apply to SDCA', icon: Icons.bolt_outlined, action: 'apply'),
          _QuickButton(label: 'View Programs', icon: Icons.menu_book_outlined, action: 'programs'),
          _QuickButton(label: 'Tuition & Fees', icon: Icons.savings_outlined, action: 'fees'),
        ],
        followUp: 'What would you like to explore next?',
        confidence: 'high',
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(fromUser: true, text: trimmed));
    });
    _controller.clear();
    _respond(trimmed);
    _scrollToBottom();
  }

  void _respond(String userText) {
    final intent = _detectIntent(userText);
    
    // show typing bubble immediately
    setState(() {
      _messages.add(const _ChatMessage(fromUser: false, isTyping: true));
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _messages.removeWhere((m) => m.isTyping == true);
        
        // Handle map intent
        if (intent == 'location/map') {
          _messages.add(const _ChatMessage(fromUser: false, text: 'Campus Map', webViewType: 'map'));
        } else {
          // Handle other intents
          final r = _responses[intent] ?? _responses['default']!;
          _messages.add(_ChatMessage(
            fromUser: false,
            text: r.reply,
            buttons: r.buttons,
            followUp: r.followUp,
            confidence: intent == 'apply' ? 'high' : 'medium',
          ));
        }
      });
      _scrollToBottom();
    });
  }

  String _detectIntent(String message) {
    final msg = message.toLowerCase();
    if (msg.contains('apply') || msg.contains('application') || msg.contains('admission')) return 'apply';
    if (msg.contains('program') || msg.contains('course') || msg.contains('degree') || msg.contains('major')) return 'programs';
    if (msg.contains('fee') || msg.contains('tuition') || msg.contains('cost') || msg.contains('payment') || msg.contains('price')) return 'fees';
    if (msg.contains('map') || msg.contains('google map') || msg.contains('view map')) return 'location/map';
    if (msg.contains('location') || msg.contains('address') || msg.contains('where') || msg.contains('direction')) return 'location';
    if (msg.contains('enroll') || msg.contains('registration') || msg.contains('register')) return 'enrollment';
    if (msg.contains('schedule') || msg.contains('class') || msg.contains('time') || msg.contains('timetable')) return 'schedule';
    if (msg.contains('contact') || msg.contains('phone') || msg.contains('email') || msg.contains('call')) return 'contact';
    if (msg.contains('scholarship') || msg.contains('financial aid') || msg.contains('discount')) return 'scholarship';
    return 'default';
  }

  void _scrollToBottom({bool jump = false}) {
    if (!_scrollController.hasClients) return;
    final target = _scrollController.position.maxScrollExtent + 120;
    if (jump) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      return;
    }
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _handleAction(String action) {
    final normalized = action.trim().toLowerCase();
    
    // Handle external URL navigation
    if (normalized == 'home' && kIsWeb) {
      html.window.open('https://stdominiccollege.edu.ph/', '_blank');
      return;
    }
    
    String? key;
    if (_responses.containsKey(normalized)) {
      key = normalized;
    } else if (normalized.contains('/')) {
      final first = normalized.split('/').first;
      if (_responses.containsKey(first)) key = first;
    }

    if (key != null || normalized == 'location/map') {
      // show typing then answer from map
      setState(() => _messages.add(const _ChatMessage(fromUser: false, isTyping: true)));
      _scrollToBottom();
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        setState(() {
          _messages.removeWhere((m) => m.isTyping == true);
          if (normalized == 'location/map') {
            _messages.add(const _ChatMessage(fromUser: false, text: 'Campus Map', webViewType: 'map'));
          } else {
            final r = _responses[key!]!;
            _messages.add(_ChatMessage(
              fromUser: false,
              text: r.reply,
              buttons: r.buttons,
              followUp: r.followUp,
              confidence: 'medium',
            ));
          }
        });
        _scrollToBottom();
      });
    } else {
      setState(() {
        _messages.add(const _ChatMessage(
          fromUser: false,
          text: "⚠️ Sorry, I couldn't find that section.",
        ));
      });
      _scrollToBottom();
    }
  }

  

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFB71C1C);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 620;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Column(
        children: [
          // Fixed navbar at top
          const _TopNav(),
          
          // Main chat interface
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1A0A0A),
                    const Color(0xFF0F0505),
                  ],
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 8 : 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF140708).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFB71C1C).withValues(alpha: 0.15),
                              blurRadius: 40,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header bar with glass effect
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              height: isMobile ? 72 : 88,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primaryRed,
                                    primaryRed.withValues(alpha: 0.9),
                                  ],
                                ),
                                boxShadow: _scrolled
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.25),
                                          blurRadius: 16,
                                          offset: const Offset(0, 6),
                                        )
                                      ]
                                    : [],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Image.asset(
                                      'lib/assets/logo-header.png',
                                      height: isMobile ? 28 : 36,
                                    ),
                                  ),
                                  SizedBox(width: isMobile ? 10 : 14),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'SDCA Virtual Assistant',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isMobile ? 16 : 22,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'St. Dominic College of Asia',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: isMobile ? 11 : 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            // Chat area with enhanced background
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF1A1016),
                                      const Color(0xFF121016),
                                    ],
                                  ),
                                ),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.fromLTRB(
                                    isMobile ? 12 : 24,
                                    isMobile ? 12 : 24,
                                    isMobile ? 12 : 24,
                                    12,
                                  ),
                                  itemCount: _messages.length,
                                  itemBuilder: (context, i) {
                                    final m = _messages[i];
                                    return Align(
                                      alignment: m.fromUser
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: _ChatBubble(
                                        message: m,
                                        onAction: _handleAction,
                                      ),
                                    ).animate().fadeIn(duration: 220.ms).moveY(
                                          begin: 6,
                                          end: 0,
                                        );
                                  },
                                ),
                              ),
                            ),

                            // Quick actions - Mobile Scrollable / Desktop Wrap
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF2A1718),
                                    const Color(0xFF221718),
                                  ],
                                ),
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 12 : 14,
                              ),
                              height: isMobile ? 70 : 80,
                              child: isMobile
                                  ? ListView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      children: const [
                                        _SuggestionChip(
                                          label: 'How do I apply?',
                                          icon: Icons.lightbulb_outline,
                                          query: 'How do I apply?',
                                        ),
                                        SizedBox(width: 8),
                                        _SuggestionChip(
                                          label: 'Programs',
                                          icon: Icons.menu_book_outlined,
                                          query: 'Programs',
                                        ),
                                        SizedBox(width: 8),
                                        _SuggestionChip(
                                          label: 'Tuition',
                                          icon: Icons.savings_outlined,
                                          query: 'Tuition',
                                        ),
                                        SizedBox(width: 8),
                                        _SuggestionChip(
                                          label: 'Location',
                                          icon: Icons.location_on_outlined,
                                          query: 'Location',
                                        ),
                                        SizedBox(width: 8),
                                        _SuggestionChip(
                                          label: 'Contact',
                                          icon: Icons.call_outlined,
                                          query: 'Contact',
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        alignment: WrapAlignment.center,
                                        children: const [
                                          _SuggestionChip(
                                            label: 'How do I apply?',
                                            icon: Icons.lightbulb_outline,
                                            query: 'How do I apply?',
                                          ),
                                          _SuggestionChip(
                                            label: 'Programs',
                                            icon: Icons.menu_book_outlined,
                                            query: 'Programs',
                                          ),
                                          _SuggestionChip(
                                            label: 'Tuition',
                                            icon: Icons.savings_outlined,
                                            query: 'Tuition',
                                          ),
                                          _SuggestionChip(
                                            label: 'Location',
                                            icon: Icons.location_on_outlined,
                                            query: 'Location',
                                          ),
                                          _SuggestionChip(
                                            label: 'Contact',
                                            icon: Icons.call_outlined,
                                            query: 'Contact',
                                          ),
                                        ],
                                      ),
                                    ),
                            ),

                            // Enhanced input bar
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF2A1718),
                                    const Color(0xFF1F1314),
                                  ],
                                ),
                              ),
                              padding: EdgeInsets.all(isMobile ? 14 : 18),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF2B2021),
                                            const Color(0xFF352628),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.08),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 16 : 20,
                                      ),
                                      height: isMobile ? 52 : 56,
                                      alignment: Alignment.center,
                                      child: TextField(
                                        controller: _controller,
                                        onSubmitted: _sendMessage,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          decoration: TextDecoration.none,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Ask me anything about SDCA...',
                                          hintStyle: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 15,
                                          ),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                          filled: false,
                                        ),
                                        cursorColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isMobile ? 10 : 14),
                                  _SendButton(
                                    onPressed: () => _sendMessage(_controller.text),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatefulWidget {
  const _SendButton({required this.onPressed});
  final VoidCallback onPressed;
  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 620;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: isMobile ? 52 : 56,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _hovered
                  ? [
                      const Color(0xFFD32F2F),
                      const Color(0xFFB71C1C),
                    ]
                  : [
                      const Color(0xFFB71C1C),
                      const Color(0xFF8B0000),
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.redAccent.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Send',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: isMobile ? 14 : 15,
                ),
              ),
              SizedBox(width: isMobile ? 6 : 8),
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: isMobile ? 18 : 20,
              ),
            ],
          ),
        ).animate(target: _hovered ? 1 : 0).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.05, 1.05),
              duration: 120.ms,
            ),
      ),
    );
  }
}

class _SuggestionChip extends StatefulWidget {
  const _SuggestionChip({required this.label, required this.icon, required this.query});
  final String label;
  final IconData icon;
  final String query;
  
  @override
  State<_SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<_SuggestionChip> {
  bool _hovered = false;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 620;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          final state = context.findAncestorStateOfType<_AssistantPageState>();
          state?._sendMessage(widget.query);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 18,
            vertical: isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _hovered
                  ? [
                      const Color(0xFF8B1515),
                      const Color(0xFF6E1111),
                    ]
                  : [
                      const Color(0xFF3A2F32),
                      const Color(0xFF2B2021),
                    ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? Colors.red.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: isMobile ? 18 : 20,
              ),
              SizedBox(width: isMobile ? 8 : 10),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 13 : 14,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ).animate(target: _hovered ? 1 : 0).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.05, 1.05),
              duration: 150.ms,
              curve: Curves.easeOut,
            ),
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.fromUser,
    this.text,
    this.buttons = const [],
    this.followUp,
    this.confidence,
    this.isTyping = false,
    this.webViewType,
  });
  final bool fromUser;
  final String? text;
  final List<_QuickButton> buttons;
  final String? followUp;
  final String? confidence;
  final bool isTyping;
  final String? webViewType; // for web-only iframe content
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.onAction});
  final _ChatMessage message;
  final void Function(String action) onAction;

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFB71C1C);
    final isUser = message.fromUser;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 620;

    return Container(
      margin: EdgeInsets.symmetric(vertical: isMobile ? 6 : 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: isMobile ? 36 : 40,
              height: isMobile ? 36 : 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFD32F2F),
                    primaryRed,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryRed.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: isMobile ? 20 : 22,
              ),
            ),
          if (!isUser) SizedBox(width: isMobile ? 8 : 10),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                gradient: message.isTyping
                    ? LinearGradient(
                        colors: [
                          const Color(0xFF1E1C25),
                          const Color(0xFF252230),
                        ],
                      )
                    : isUser
                        ? LinearGradient(
                            colors: [
                              const Color(0xFF9E1515),
                              const Color(0xFF7E1111),
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              const Color(0xFF2A2632),
                              const Color(0xFF1E1C25),
                            ],
                          ),
                borderRadius: BorderRadius.circular(isMobile ? 14 : 18),
                border: Border.all(
                  color: isUser
                      ? Colors.red.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? Colors.red.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(
                isMobile ? 12 : 16,
                isMobile ? 10 : 14,
                isMobile ? 12 : 16,
                isMobile ? 10 : 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isTyping) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        _Dot(),
                        SizedBox(width: 4),
                        _Dot(delayMs: 150),
                        SizedBox(width: 4),
                        _Dot(delayMs: 300),
                      ],
                    ),
                  ] else if (message.text != null) ...[
                    Text(
                      message.text!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 14 : 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                  if (!kIsWeb && message.webViewType == 'map') ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Map is only available on web preview.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (kIsWeb && message.webViewType == 'map') ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: isMobile ? 250 : 300,
                        width: double.infinity,
                        child: _WebMapView(),
                      ),
                    ),
                  ],
                  if (message.buttons.isNotEmpty) ...[
                    SizedBox(height: isMobile ? 10 : 12),
                    Wrap(
                      spacing: isMobile ? 6 : 10,
                      runSpacing: isMobile ? 6 : 10,
                      children: [
                        for (final b in message.buttons)
                          _PrimaryPill(
                            label: b.label,
                            icon: b.icon,
                            onTap: () => onAction(b.action),
                          ),
                      ],
                    ),
                  ],
                  if (message.followUp != null) ...[
                    SizedBox(height: isMobile ? 8 : 10),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      child: Text(
                        message.followUp!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 13 : 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) SizedBox(width: isMobile ? 8 : 10),
          if (isUser)
            Container(
              width: isMobile ? 36 : 40,
              height: isMobile ? 36 : 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFE57F),
                    Color(0xFFFFD700),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(
                Icons.person,
                color: Colors.black87,
                size: isMobile ? 20 : 22,
              ),
            ),
        ],
      ),
    );
  }
}

class _PrimaryPill extends StatefulWidget {
  const _PrimaryPill({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  State<_PrimaryPill> createState() => _PrimaryPillState();
}

class _PrimaryPillState extends State<_PrimaryPill> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 620;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 14,
            vertical: isMobile ? 10 : 12,
          ),
          decoration: BoxDecoration(
            gradient: _hovered
                ? LinearGradient(
                    colors: [
                      const Color(0xFF8B1515),
                      const Color(0xFF6E1111),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      const Color(0xFF3A2F32),
                      const Color(0xFF2B2021),
                    ],
                  ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? Colors.red.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.08),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.3),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: isMobile ? 16 : 18,
              ),
              SizedBox(width: isMobile ? 6 : 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: isMobile ? 13 : 14,
                ),
              ),
            ],
          ),
        ).animate(target: _hovered ? 1 : 0).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.02, 1.02),
              duration: 120.ms,
            ),
      ),
    );
  }
}

class _QuickButton {
  const _QuickButton({required this.label, required this.icon, required this.action});
  final String label;
  final IconData icon;
  final String action;
}

class _AssistantResponse {
  const _AssistantResponse({
    required this.reply,
    this.buttons = const [],
    this.followUp,
  });
  final String reply;
  final List<_QuickButton> buttons;
  final String? followUp;
}

class _Dot extends StatefulWidget {
  const _Dot({this.delayMs = 0});
  final int delayMs;
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = ((_c.value + (widget.delayMs/900)) % 1.0);
        final dy = 2.0 * (t < 0.5 ? t : 1 - t);
        return Transform.translate(
          offset: Offset(0, -dy * 4),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
          ),
        );
      },
    );
  }
}

class _WebMapView extends StatefulWidget {
  @override
  State<_WebMapView> createState() => _WebMapViewState();
}

class _WebMapViewState extends State<_WebMapView> {
  static final String _viewTypeId = 'sdca-map-iframe-0';
  static bool _registered = false;
  @override
  void initState() {
    super.initState();
    if (kIsWeb && !_registered) {
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(_viewTypeId, (int viewId) {
        final element = html.IFrameElement()
          ..src = 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1680.742180791518!2d120.9608615876372!3d14.458723786036577!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3397cd9273416e43%3A0x96542d86e50a4106!2sSt.%20Dominic%20College%20of%20Asia!5e1!3m2!1sen!2sph!4v1760434574047!5m2!1sen!2sph'
          ..style.border = '0'
          ..style.borderRadius = '10px'
          ..width = '100%'
          ..height = '300'
          ..allowFullscreen = true
          ..referrerPolicy = 'no-referrer-when-downgrade';
        return element;
      });
      _registered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();
    return HtmlElementView(viewType: _viewTypeId);
  }
}