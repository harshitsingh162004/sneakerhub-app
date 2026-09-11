import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auction_provider.dart';
import '../../models/auction.dart';
import '../../widgets/auction_card.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Auction> _results = [];
  List<Auction> _allAuctions = [];
  String _selectedBrand = 'All';
  final List<String> _recentSearches = [
    'Nike Air Jordan',
    'Yeezy 350',
    'Adidas Samba',
  ];
  final List<String> _popularBrands = [
    'All',
    'Nike',
    'Adidas',
    'Puma',
    'New Balance',
    'Converse'
  ];

  @override
  void initState() {
    super.initState();
    _allAuctions = context.read<AuctionProvider>().auctions;
    _results = _allAuctions;
  }

  void _search(String query) {
    setState(() {
      _results = _allAuctions.where((a) {
        final matchQuery = query.isEmpty ||
            a.sneakerTitle.toLowerCase().contains(query.toLowerCase()) ||
            a.brand.toLowerCase().contains(query.toLowerCase());
        final matchBrand = _selectedBrand == 'All' || a.brand == _selectedBrand;
        return matchQuery && matchBrand;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.bgDark,
      appBar: AppBar(
        backgroundColor: AppConstants.navyBlue,
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: AppConstants.textWhite),
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Search sneakers, brands...',
                hintStyle: const TextStyle(color: AppConstants.textGrey),
                prefixIcon:
                    const Icon(Icons.search, color: AppConstants.textGrey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppConstants.textGrey),
                        onPressed: () {
                          _searchController.clear();
                          _search('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppConstants.cardBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  borderSide: const BorderSide(
                      color: AppConstants.electricBlue, width: 1.5),
                ),
              ),
            ),
          ),

          // Brand filter chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _popularBrands.length,
              itemBuilder: (context, index) {
                final brand = _popularBrands[index];
                final isSelected = _selectedBrand == brand;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedBrand = brand);
                    _search(_searchController.text);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.electricBlue
                          : AppConstants.cardBlue,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusXL),
                      border: isSelected
                          ? null
                          : Border.all(
                              color:
                                  AppConstants.electricBlue.withOpacity(0.3)),
                    ),
                    child: Text(
                      brand,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppConstants.textGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Recent searches (when no query)
          if (_searchController.text.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recent Searches', style: AppConstants.heading3),
                  const SizedBox(height: 12),
                  ..._recentSearches.map((s) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.history,
                            color: AppConstants.textGrey),
                        title: Text(s,
                            style:
                                const TextStyle(color: AppConstants.textLight)),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: AppConstants.textGrey, size: 14),
                        onTap: () {
                          _searchController.text = s;
                          _search(s);
                        },
                      )),
                ],
              ),
            ),
          ] else ...[
            // Results
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_results.length} results',
                style: const TextStyle(color: AppConstants.textGrey),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off,
                              size: 60, color: AppConstants.textGrey),
                          const SizedBox(height: 16),
                          Text(
                            'No results for "${_searchController.text}"',
                            style:
                                const TextStyle(color: AppConstants.textGrey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _results.length,
                      itemBuilder: (context, index) => AuctionCard(
                        auction: _results[index],
                        onTap: () => context
                            .push('/auction/${_results[index].auctionId}'),
                      ),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
