import '../../domain/entities/resume_entity.dart';

class ProjectModel {
  final String title;
  final String description;
  final String startDate;
  final String endDate;

  ProjectModel({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
    );
  }

  ProjectEntity toEntity() => ProjectEntity(
    title: title,
    description: description,
    startDate: startDate,
    endDate: endDate,
  );
}

class ResumeModel {
  final String name;
  final String phone;
  final String email;
  final String twitter;
  final String address;
  final String summary;
  final List<String> skills;
  final List<ProjectModel> projects;

  ResumeModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.twitter,
    required this.address,
    required this.summary,
    required this.skills,
    required this.projects,
  });

  factory ResumeModel.fromMap(Map<String, dynamic> map) {
    return ResumeModel(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      twitter: map['twitter'] ?? '',
      address: map['address'] ?? '',
      summary: map['summary'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      projects: (map['projects'] as List<dynamic>? ?? [])
          .map((e) => ProjectModel.fromMap(e))
          .toList(),
    );
  }

  ResumeEntity toEntity() => ResumeEntity(
    name: name,
    phone: phone,
    email: email,
    twitter: twitter,
    address: address,
    summary: summary,
    skills: skills,
    projects: projects.map((p) => p.toEntity()).toList(),
  );
}
