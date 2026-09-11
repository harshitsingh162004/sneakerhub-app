import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/auction_provider.dart';
import '../../models/auction.dart';
import '../../widgets/auction_card.dart';
import '../search/search_screen.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadUserData();
      context.read<AuctionProvider>().fetchAuctions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgDark,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          _UpcomingTab(),
          _ChatTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: AppConstants.navyBlue,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppConstants.electricBlue.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(0, Icons.home_rounded, 'Home'),
            _navItem(1, Icons.timer_outlined, 'Upcoming'),
            _navItem(2, Icons.chat_bubble_outline_rounded, 'Chat'),
            _navItem(3, Icons.person_outline_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppConstants.electricBlue.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isActive ? AppConstants.electricBlue : AppConstants.textGrey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppConstants.electricBlue
                    : AppConstants.textGrey,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => context.read<AuctionProvider>().fetchAuctions(),
        color: AppConstants.electricBlue,
        backgroundColor: AppConstants.navyBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildHeroBanner(context),
              _buildSectionTitle('Live Auctions', context),
              _buildAuctionsList(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back 👋',
                style: TextStyle(
                  color: AppConstants.textGrey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                auth.userName ?? 'Sneakerhead',
                style: AppConstants.heading2,
              ),
            ],
          ),
          Row(
            children: [
              _iconButton(Icons.search_rounded, onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()));
              }),
              const SizedBox(width: 8),
              _iconButton(Icons.notifications_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppConstants.cardBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppConstants.textWhite, size: 20),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Consumer<AuctionProvider>(
      builder: (context, provider, _) {
        if (provider.auctions.isEmpty) return const SizedBox.shrink();
        final featured = provider.auctions.first;
        return GestureDetector(
          onTap: () => context.push('/auction/${featured.auctionId}'),
          child: Container(
            margin: const EdgeInsets.all(20),
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D1F3C), Color(0xFF1E6FFF)],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.electricBlue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Glow effect
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppConstants.neonBlue.withOpacity(0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppConstants.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppConstants.success.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppConstants.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: AppConstants.success,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            featured.sneakerTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${featured.currentPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppConstants.neonBlue,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'BID NOW →',
                              style: TextStyle(
                                color: AppConstants.electricBlue,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
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
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppConstants.heading3),
          Text(
            'See all',
            style: TextStyle(
              color: AppConstants.electricBlue,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionsList(BuildContext context) {
    return Consumer<AuctionProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(
                color: AppConstants.electricBlue,
              ),
            ),
          );
        }
        if (provider.auctions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.sports_basketball_outlined,
                    size: 60,
                    color: AppConstants.textGrey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No live auctions right now',
                    style: AppConstants.bodyText,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pull down to refresh',
                    style: TextStyle(
                      color: AppConstants.textGrey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: provider.auctions.length,
          itemBuilder: (context, index) {
            return AuctionCard(
              auction: provider.auctions[index],
              onTap: () => context
                  .push('/auction/${provider.auctions[index].auctionId}'),
            );
          },
        );
      },
    );
  }
}

class _UpcomingTab extends StatelessWidget {
  const _UpcomingTab();

  final List<Map<String, dynamic>> _upcoming = const [
    {
      'title': 'Jordan 4 Military Black',
      'brand': 'Nike',
      'startingPrice': 25000,
      'daysLeft': 2,
      'hoursLeft': 14,
      'interested': 342,
    },
    {
      'title': 'Yeezy Boost 350 V2',
      'brand': 'Adidas',
      'startingPrice': 18000,
      'daysLeft': 3,
      'hoursLeft': 6,
      'interested': 215,
    },
    {
      'title': 'New Balance 550',
      'brand': 'New Balance',
      'startingPrice': 12000,
      'daysLeft': 5,
      'hoursLeft': 2,
      'interested': 189,
    },
    {
      'title': 'Converse Chuck 70',
      'brand': 'Converse',
      'startingPrice': 8000,
      'daysLeft': 7,
      'hoursLeft': 0,
      'interested': 98,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child:
                const Text('Upcoming Auctions', style: AppConstants.heading1),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _upcoming.length,
              itemBuilder: (context, index) {
                final item = _upcoming[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppConstants.cardGradient,
                    borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    border: Border.all(
                        color: AppConstants.electricBlue.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  AppConstants.electricBlue.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppConstants.electricBlue
                                      .withOpacity(0.4)),
                            ),
                            child: const Text(
                              'UPCOMING',
                              style: TextStyle(
                                color: AppConstants.electricBlue,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          Text(
                            '${item['interested']} interested',
                            style: const TextStyle(
                                color: AppConstants.textGrey, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppConstants.navyBlue,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusM),
                            ),
                            child: const Icon(Icons.sports_basketball_rounded,
                                color: AppConstants.electricBlue, size: 35),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title'] as String,
                                    style: AppConstants.heading3),
                                const SizedBox(height: 4),
                                Text(
                                  item['brand'] as String,
                                  style: const TextStyle(
                                      color: AppConstants.textGrey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Starting at ₹${item['startingPrice']}',
                                  style: const TextStyle(
                                    color: AppConstants.neonBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Starts in',
                                  style: TextStyle(
                                      color: AppConstants.textGrey,
                                      fontSize: 12)),
                              Text(
                                '${item['daysLeft']}d ${item['hoursLeft']}h',
                                style: const TextStyle(
                                  color: AppConstants.warning,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: AppConstants.blueGradient,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusS),
                              boxShadow: AppConstants.glowShadow,
                            ),
                            child: const Text(
                              'SET REMINDER',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTab extends StatelessWidget {
  const _ChatTab();

  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: AppConstants.blueGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.electricBlue.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  (auth.userName ?? 'U')[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              auth.userName ?? 'User',
              style: AppConstants.heading2,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.electricBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppConstants.electricBlue.withOpacity(0.3)),
              ),
              child: Text(
                auth.userRole ?? 'BUYER',
                style: const TextStyle(
                  color: AppConstants.electricBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Menu items
            _menuItem(Icons.gavel_rounded, 'My Bids', () {
              context.push('/my-bids');
            }),
            if (auth.userRole == 'SELLER')
              _menuItem(Icons.add_box_outlined, 'Create Auction', () {
                context.push('/create-auction');
              }),
            _menuItem(Icons.history, 'Auction History', () {}),
            _menuItem(Icons.favorite_border, 'Wishlist', () {}),
            _menuItem(Icons.settings_outlined, 'Settings', () {}),
            const SizedBox(height: 16),
            // Logout
            GestureDetector(
              onTap: () async {
                await auth.logout();
                if (context.mounted) context.go('/login');
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  border:
                      Border.all(color: AppConstants.danger.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: AppConstants.danger, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        color: AppConstants.danger,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConstants.cardBlue,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppConstants.electricBlue, size: 22),
            const SizedBox(width: 12),
            Text(title, style: AppConstants.heading3.copyWith(fontSize: 15)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: AppConstants.textGrey, size: 14),
          ],
        ),
      ),
    );
  }
}
