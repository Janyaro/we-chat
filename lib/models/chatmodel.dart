class chatmodel {
  String? image;
  String? name;
  String? about;
  String? eMail;
  String? createdAt;
  String? pushtoken;
  String? lastActive;
  String? id;
  bool? isonline;

  chatmodel(
      {this.image,
      this.name,
      this.about,
      this.eMail,
      this.createdAt,
      this.pushtoken,
      this.lastActive,
      this.id,
      this.isonline});

  chatmodel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    eMail = json['e-mail'] ?? '';
    createdAt = json['created_at'] ?? '';
    pushtoken = json['pushtoken'] ?? '';
    lastActive = json['last_active'] ?? '';
    id = json['id'] ?? '';
    isonline = json['isonline'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['about'] = this.about;
    data['e-mail'] = this.eMail;
    data['created_at'] = this.createdAt;
    data['pushtoken'] = this.pushtoken;
    data['last_active'] = this.lastActive;
    data['id'] = this.id;
    data['isonline'] = this.isonline;
    return data;
  }
}
