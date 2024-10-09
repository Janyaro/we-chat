class ChatModel {
  String? image;
  String? name;
  String? about;
  String? email; // Keeping original key for consistency
  String? createdAt;
  String? pushToken; // Keeping camelCase consistency
  String? lastActive;
  String? id;
  bool? isOnline; // Keeping camelCase consistency

  ChatModel({
    this.image,
    this.name,
    this.about,
    this.email,
    this.createdAt,
    this.pushToken,
    this.lastActive,
    this.id,
    this.isOnline,
  });
  ChatModel.fromJson(Map<String, dynamic> json) {
    image =
        (json['image'] is String) ? json['image'] : json['image'].toString();
    name = (json['name'] is String) ? json['name'] : json['name'].toString();
    about =
        (json['about'] is String) ? json['about'] : json['about'].toString();
    email =
        (json['e-mail'] is String) ? json['e-mail'] : json['e-mail'].toString();
    createdAt = (json['created_at'] is String)
        ? json['created_at']
        : json['created_at'].toString();
    pushToken = (json['pushtoken'] is String)
        ? json['pushtoken']
        : json['pushtoken'].toString();
    lastActive = (json['last_active'] is String)
        ? json['last_active']
        : json['last_active'].toString();
    id = (json['id'] is String) ? json['id'] : json['id'].toString();

    // Handle the case where `isonline` might be an int or a bool
    if (json['isonline'] is int) {
      isOnline = json['isonline'] == 1; // Convert int to bool
    } else if (json['isonline'] is bool) {
      isOnline = json['isonline']; // Directly assign if it's already a bool
    } else {
      isOnline = false; // Default to false
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['e-mail'] = email; // Keeping the original key
    data['created_at'] = createdAt;
    data['pushtoken'] = pushToken;
    data['last_active'] = lastActive;
    data['id'] = id;
    data['isonline'] = isOnline; // Directly use the bool value
    return data;
  }
}
