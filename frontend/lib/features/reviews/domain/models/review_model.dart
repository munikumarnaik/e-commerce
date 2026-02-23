class ReviewUser {
  final String name;
  final String? avatar;

  const ReviewUser({required this.name, this.avatar});

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    return ReviewUser(
      name: json['user_name'] as String? ?? 'Anonymous',
      avatar: json['user_avatar'] as String?,
    );
  }
}

class ReviewImage {
  final String id;
  final String image;

  const ReviewImage({required this.id, required this.image});

  factory ReviewImage.fromJson(Map<String, dynamic> json) {
    return ReviewImage(
      id: json['id'].toString(),
      image: json['image'] as String,
    );
  }
}

class ReviewResponse {
  final String userName;
  final String comment;
  final String? createdAt;

  const ReviewResponse({
    required this.userName,
    required this.comment,
    this.createdAt,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      userName: json['user_name'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] as String?,
    );
  }
}

class Review {
  final String id;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String title;
  final String comment;
  final bool isVerifiedPurchase;
  final int helpfulCount;
  final List<ReviewImage> images;
  final ReviewResponse? response;
  final bool hasVotedHelpful;
  final String? createdAt;

  const Review({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.title,
    required this.comment,
    this.isVerifiedPurchase = false,
    this.helpfulCount = 0,
    this.images = const [],
    this.response,
    this.hasVotedHelpful = false,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'].toString(),
      userName: json['user_name'] as String? ?? 'Anonymous',
      userAvatar: json['user_avatar'] as String?,
      rating: json['rating'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      isVerifiedPurchase: json['is_verified_purchase'] as bool? ?? false,
      helpfulCount: json['helpful_count'] as int? ?? 0,
      images: (json['images'] as List?)
              ?.map((e) => ReviewImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      response: json['response'] != null
          ? ReviewResponse.fromJson(json['response'] as Map<String, dynamic>)
          : null,
      hasVotedHelpful: json['has_voted_helpful'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
    );
  }
}

class ReviewsSummary {
  final double averageRating;
  final int totalReviews;
  final int star5;
  final int star4;
  final int star3;
  final int star2;
  final int star1;

  const ReviewsSummary({
    this.averageRating = 0,
    this.totalReviews = 0,
    this.star5 = 0,
    this.star4 = 0,
    this.star3 = 0,
    this.star2 = 0,
    this.star1 = 0,
  });

  factory ReviewsSummary.fromJson(Map<String, dynamic> json) {
    return ReviewsSummary(
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      star5: json['5_star'] as int? ?? 0,
      star4: json['4_star'] as int? ?? 0,
      star3: json['3_star'] as int? ?? 0,
      star2: json['2_star'] as int? ?? 0,
      star1: json['1_star'] as int? ?? 0,
    );
  }

  int get maxStarCount {
    final counts = [star1, star2, star3, star4, star5];
    return counts.fold(0, (a, b) => a > b ? a : b);
  }
}
