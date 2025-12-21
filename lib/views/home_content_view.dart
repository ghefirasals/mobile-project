import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/menu_service.dart';
import '../services/cart_service.dart';
import '../services/theme_service.dart';
import '../models/menu_item.dart';
import 'cart_view.dart';

class HomeContentView extends StatefulWidget {
  const HomeContentView({super.key});

  @override
  State<HomeContentView> createState() => _HomeContentViewViewState();
}

class _HomeContentViewViewState extends State<HomeContentView> {
  final MenuService menuService = Get.find<MenuService>();
  final CartService cartService = Get.find<CartService>();
  final ThemeService themeService = Get.find<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: const Text('🍛 Nasi Padang'),
          actions: [
            UserMenuButton(onLogout: _handleLogout),
            ThemeToggleButton(themeService: themeService),
            CartButton(cartService: cartService),
          ],
        ),

        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildCategories()),
        SliverFillRemaining(child: _buildMenuGrid()),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (_, __) {
          final user = Supabase.instance.client.auth.currentUser;
          final name =
              user?.userMetadata?['display_name'] ??
              user?.email?.split('@')[0] ??
              'Pengunjung';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang, $name!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text('Silakan pilih menu favorit Anda'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Obx(() {
        final categories = ['Semua', ...menuService.getAvailableCategories()];
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (_, i) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(categories[i]),
                selected: false,
                onSelected: (_) {},
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildMenuGrid() {
    return Obx(() {
      if (menuService.menuItems.isEmpty) {
        return const Center(child: Text('Tidak ada menu tersedia'));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: menuService.menuItems.length,
        itemBuilder: (_, i) {
          return MenuItemCard(
            menuItem: menuService.menuItems[i],
            onAddToCart: () => cartService.addToCart(menuService.menuItems[i]),
          );
        },
      );
    });
  }

  Future<void> _handleLogout() async {
    await Supabase.instance.client.auth.signOut();
    Get.offAllNamed('/login');
  }
}

/* =========================
   MENU ITEM CARD (FIX IMAGE)
   ========================= */

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final VoidCallback onAddToCart;

  const MenuItemCard({
    super.key,
    required this.menuItem,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // ===== IMAGE =====
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: _buildImage(menuItem.imageUrl),
            ),
          ),

          // ===== INFO =====
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuItem.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(menuItem.spicyIndicator, style: const TextStyle(fontSize: 12)),
                  Text(
                    menuItem.categoryName ?? 'Lainnya',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        menuItem.formattedPrice,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD84315)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart,
                            color: Color(0xFFD84315)),
                        onPressed: onAddToCart,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// IMAGE HANDLER (ASSET / NETWORK / FALLBACK)
  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/default_food.png',
        fit: BoxFit.cover,
      );
    }

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(imageUrl, fit: BoxFit.cover);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Image.asset(
          'assets/images/default_food.png',
          fit: BoxFit.cover,
        );
      },
    );
  }
}

/* ===== WIDGET LAIN TIDAK DIUBAH ===== */

class UserMenuButton extends StatelessWidget {
  final VoidCallback onLogout;
  const UserMenuButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final name = user?.email?.split('@')[0] ?? 'User';

    return PopupMenuButton(
      icon: CircleAvatar(child: Text(name[0].toUpperCase())),
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'logout', child: Text('Logout')),
      ],
      onSelected: (_) => onLogout(),
    );
  }
}

class ThemeToggleButton extends StatelessWidget {
  final ThemeService themeService;
  const ThemeToggleButton({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
          icon: Icon(themeService.isDarkMode
              ? Icons.light_mode
              : Icons.dark_mode),
          onPressed: themeService.toggleTheme,
        ));
  }
}

class CartButton extends StatelessWidget {
  final CartService cartService;
  const CartButton({super.key, required this.cartService});

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => Get.to(() => const CartView()),
        ));
  }
}
