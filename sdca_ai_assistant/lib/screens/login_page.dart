import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/auth_service.dart';

class _TopNav extends StatefulWidget {
  const _TopNav();

  @override
  State<_TopNav> createState() => _TopNavState();
}

class _TopNavState extends State<_TopNav> with SingleTickerProviderStateMixin {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 620;
 

    return SafeArea(
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
                  _NavButton(
                    label: 'Account',
                    onTap: () => Navigator.pushNamed(context, '/login'),
                  ),
                ] else
                  IconButton(
                    icon: Icon(_menuOpen ? Icons.close : Icons.menu, color: Colors.white),
                    onPressed: () => setState(() => _menuOpen = !_menuOpen),
                  ),
              ],
            ),
          ),

        
          if (isMobile)
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                 
                  maxHeight: _menuOpen ? 200 : 0,
                ),
                child: SingleChildScrollView(
                  
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
                          const Divider(height: 1, color: Colors.white24),
                          _DropdownItem(
                            label: 'Account',
                            onTap: () {
                              setState(() => _menuOpen = false);
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ],
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



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController(text: "");
  //final TextEditingController _passwordController =
      //TextEditingController(text: "");
  String? _message;
  bool _isError = false;
  //bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    //_passwordController.dispose();
    super.dispose();
  }

  final Map<String, Map<String, String>> _users = {
    "20210145@sdca.edu.ph": { "name": "Audrey Concepcion"},
    "20215489@sdca.edu.ph": { "name": "Michelle Bautista"},
    "20218765@sdca.edu.ph": { "name": "Jessa Lim"},
    "20221234@sdca.edu.ph": { "name": "Renz Dela Cruz"},
  };

  void _submit() {
    final email = _emailController.text.trim();
    //final password = _passwordController.text;
    final userData = _users[email];
    //final isValid = userData != null && userData['password'] == password;

    if (userData != null) {
      final userName = userData['name'];
      setState(() {
        _isError = false;
        _message = 'Welcome SDCA University! $userName';
      });

      // Store login state
      AuthService().login(userName!);

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/assistant'); // Navigate to home page
      });
    } else {
      setState(() {
        _isError = true;
        _message = 'Invalid email.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 102, 0, 0),
              Color.fromARGB(255, 53, 2, 2),
            ],
          ),
        ),
        child: Column(
          children: [
            const _TopNav(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('lib/assets/Logo_white.png', height: 72) 
                        .animate() .fadeIn(duration: 500.ms) 
                        .moveY(begin: -20, end: 0, curve: Curves.easeOut),
                        const SizedBox(height: 40),
                        Text(
                          'Sign In',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    style: const TextStyle(color: Colors.black87),
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: 'e.g. 202512345@sdca.edu.ph ',
                                      labelText: 'Email',
                                      prefixIcon:
                                          Icon(Icons.email_outlined),
                                    ),
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Email required'
                                        : null,
                                  ),
                                  const SizedBox(height: 14),
                                  /*TextFormField(
                                    //controller: _passwordController,
                                    obscureText: _obscure,
                                    style: const TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                     // hintText: 'Enter your password',
                                      //labelText: 'Password',
                                      prefixIcon:
                                          const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        onPressed: () => setState(
                                            () => _obscure = !_obscure),
                                        icon: Icon(_obscure
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                    ),
                                    /*validator: (v) =>
                                        (v == null || v.isEmpty)
                                            ? 'Password required'
                                            : null,*/
                                  ),*/
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          _submit();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFB71C1C), // SDCA red
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_message != null) ...[
                                    const SizedBox(height: 14),
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: _isError
                                            ? Colors.red.shade50
                                            : Colors.green.shade50,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _isError
                                              ? Colors.red.shade200
                                              : Colors.green.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _isError
                                                ? Icons.error_outline
                                                : Icons.check_circle_outline,
                                            color: _isError
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              _message!,
                                              style: TextStyle(
                                                color: _isError
                                                    ? Colors.red.shade900
                                                    : Colors.green.shade900,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .moveY(begin: 12, end: 0, curve: Curves.easeOut),
                        const SizedBox(height: 24),
                        Text(
                          'St. Dominic College of Asia',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha:0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Secure sign in to access your AI assistant',
                          style:
                              TextStyle(color: Colors.white.withValues(alpha:0.75)),
                        ),
                      ],
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
