class MeetingDetail {
  MeetingDetail({
    this.id,
    this.hostId,
    this.hostName,
  });

  factory MeetingDetail.fromJson(dynamic json) {
    final result =  MeetingDetail(
      id: json['id'],
      hostId: json['hostId'],
      hostName: json['hostName'],
    );
    return result;
  }

  String? id;
  String? hostId;
  String? hostName;
}
