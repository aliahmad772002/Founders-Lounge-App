class Post {
  final String username;
  final String profession;
  final String content;
  final String profileAvatarUrl;
  final String? postImageUrl;

  Post({
    required this.username,
    required this.profession,
    required this.content,
    required this.profileAvatarUrl,
    this.postImageUrl,
  });
}
