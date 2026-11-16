/// Pre-seeded default categories for technology content creators.
class DefaultCategoryItem {
  final String id;
  final String name;
  final String description;
  final String icon;

  const DefaultCategoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}

const List<DefaultCategoryItem> kDefaultCategories = [
  DefaultCategoryItem(
    id: 'cat_phone_tricks',
    name: 'Phone Tricks',
    description: 'Mobile shortcuts, gesture controls & hidden settings',
    icon: 'smartphone',
  ),
  DefaultCategoryItem(
    id: 'cat_whatsapp',
    name: 'WhatsApp',
    description: 'Privacy, storage, data saving & hidden messaging features',
    icon: 'chat',
  ),
  DefaultCategoryItem(
    id: 'cat_windows',
    name: 'Windows',
    description: 'PC optimizations, command-line power tools & fixes',
    icon: 'desktop_windows',
  ),
  DefaultCategoryItem(
    id: 'cat_phone_pc',
    name: 'Phone + PC',
    description:
        'Cross-device integration, wireless mouse, file sharing & casting',
    icon: 'devices',
  ),
  DefaultCategoryItem(
    id: 'cat_internet',
    name: 'Internet & Web',
    description: 'Browsing speed, bandwidth, networking & DNS tricks',
    icon: 'wifi',
  ),
  DefaultCategoryItem(
    id: 'cat_security',
    name: 'Digital Safety',
    description: 'Account protection, 2FA, scam prevention & privacy',
    icon: 'security',
  ),
  DefaultCategoryItem(
    id: 'cat_productivity',
    name: 'Productivity',
    description: 'Workflows, shortcuts, note-taking & file management',
    icon: 'flash_on',
  ),
  DefaultCategoryItem(
    id: 'cat_ghana_tech',
    name: 'Ghana / Africa Tech',
    description: 'Mobile money, low-data hacks, USSD & local tech solutions',
    icon: 'public',
  ),
  DefaultCategoryItem(
    id: 'cat_other',
    name: 'Other Discoveries',
    description: 'Uncategorized and experimental technology ideas',
    icon: 'category',
  ),
];
