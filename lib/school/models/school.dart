class Course {
  const Course({
    required this.name,
    required this.duration,
    required this.price,
    this.discountPrice,
  });

  final String name;
  final String duration;
  final int price;
  final int? discountPrice;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        name: json['name'] as String,
        duration: json['duration'] as String,
        price: json['price'] as int,
        discountPrice: json['discountPrice'] as int?,
      );
}

class School {
  const School({
    required this.id,
    required this.name,
    this.image,
    required this.description,
    required this.address,
    required this.phone,
    this.discount,
    required this.courses,
  });

  final String id;
  final String name;
  final String? image;
  final String description;
  final String address;
  final String phone;
  final String? discount;
  final List<Course> courses;

  factory School.fromJson(Map<String, dynamic> json) => School(
        id: json['id'] as String,
        name: json['name'] as String,
        image: json['image'] as String?,
        description: json['description'] as String,
        address: json['address'] as String,
        phone: json['phone'] as String,
        discount: json['discount'] as String?,
        courses: (json['courses'] as List<dynamic>)
            .map((c) => Course.fromJson(c as Map<String, dynamic>))
            .toList(),
      );
}
