class MoreGame {
  const MoreGame(
      {required this.appName,
      required this.packageName,
      required this.description,
      required this.iconUrl});
  final String appName, packageName, description, iconUrl;
  factory MoreGame.fromJson(Map<String, dynamic> j) => MoreGame(
      appName: j['app_name'] as String? ?? '',
      packageName: j['package_name'] as String? ?? '',
      description: j['description'] as String? ?? '',
      iconUrl: j['icon_url'] as String? ?? '');
}
