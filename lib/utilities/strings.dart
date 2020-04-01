String smartCourseTitleCase(String courseName) {
  print(courseName);
  return courseName.replaceAllMapped(
    RegExp(r'\b(?!\b(?:ADV|AICE|MYP|PYP|[A-z]{1,2})\b)([A-z])([A-z]*?)\b'),
    (match) => match.group(1).toUpperCase() + match.group(2).toLowerCase(),
  );
}
