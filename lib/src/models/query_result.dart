class QueryResult {
  String title;
  String locationType;
  int woeid;
  String lattLong;

  QueryResult({this.title, this.locationType, this.woeid, this.lattLong});

  QueryResult.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    locationType = json['location_type'];
    woeid = json['woeid'];
    lattLong = json['latt_long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['location_type'] = this.locationType;
    data['woeid'] = this.woeid;
    data['latt_long'] = this.lattLong;
    return data;
  }
}
