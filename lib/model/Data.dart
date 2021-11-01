import 'package:hive/hive.dart';
part 'Data.g.dart';
@HiveType(typeId: 0)
class JakesDataModel {
  JakesDataModel({
    this.name,
    this.image,
    this.language,
    this.description,
    this.watchers_count,
    this.openIssuesCount,
    this.url

  });
  @HiveField(0)
  String name;

  @HiveField(1)
  String image;
  @HiveField(2)
  String language;
  @HiveField(3)
  String description;
  @HiveField(4)
  int  watchers_count;
  @HiveField(5)
  int openIssuesCount;
  @HiveField(6)
  String url;

  factory JakesDataModel.fromJson(Map<String, dynamic> json) => JakesDataModel(
    name: json["name"],
    image: json["owner"]["avatar_url"],
    language : json["language"],
    description: json["description"],
    watchers_count: json["watchers_count"],
    openIssuesCount: json["open_issues_count"],
    url: json["html_url"],
  );
}
