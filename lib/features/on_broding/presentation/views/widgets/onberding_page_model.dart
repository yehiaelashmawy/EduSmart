class OnBoardingPageModel {
  final String title;
  final String description;
  final String image;
  final String? headerTitle;
  final bool hasImagePadding;

  OnBoardingPageModel({
    required this.title,
    required this.description,
    required this.image,
    this.headerTitle,
    this.hasImagePadding = true,
  });
}
