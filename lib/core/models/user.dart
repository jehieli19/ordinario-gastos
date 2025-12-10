class AppUser {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;

  AppUser({required this.id, required this.email, this.name, this.photoUrl});
}
