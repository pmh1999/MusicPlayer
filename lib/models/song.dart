class Song {
  String? id;
  String? name;
  String? link;
  String? thumbnail;
  String? performer;
  int? position;

  Song(
      {this.id,
      this.name,
      this.link,
      this.thumbnail,
      this.performer,
      this.position});

  Song.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    link = json['link'];
    thumbnail = json['thumbnail'];
    performer = json['performer'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['link'] = this.link;
    data['thumbnail'] = this.thumbnail;
    data['performer'] = this.performer;
    data['position'] = this.position;
    return data;
  }
}