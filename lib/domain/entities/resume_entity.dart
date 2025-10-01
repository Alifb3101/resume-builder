class ProjectEntity {
  final String title;
  final String description;
  final String startDate;
  final String endDate;

  ProjectEntity({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });
}

class ResumeEntity {
  final String name;
  final String phone;
  final String email;
  final String twitter;
  final String address;
  final String summary;
  final List<String> skills;
  final List<ProjectEntity> projects;

  ResumeEntity({
    required this.name,
    required this.phone,
    required this.email,
    required this.twitter,
    required this.address,
    required this.summary,
    required this.skills,
    required this.projects,
  });
}
