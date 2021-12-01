# MyGrades

📘 The district-approved grades app formerly known as "SwiftGrade" for schools in Palm Beach County

[![Discuss On Discord][discord]][discord-url]
[![Contributors][contributors-shield]][contributors-url]
[![Issues][issues]][issues-url]

MyGrades is a mobile application that allows students to check their school assignment scores. MyGrades supports over 180 schools in the School District of Palm Beach County, and has been approved by the Technology Clearinghouse Committee.

We are doing this as an accommodation for students; We are not storing or collecting their information. The security and safety of their information is a priority for this application - MyGrades does not use an external server accessible by us and all requests are fully encrypted. In addition, we are not pulling personal information such as name, email, or address.

At its basic level, MyGrades works by logging in to the district portal with the same authentication a student would normally use to access their grades. It then scans their grades, pulls them back to their device, and displays them in a more convenient and user-friendly fashion. The app is separated into several pages. After logging in, the user sees a screen with their classes and class averages. If they click on a class, it expands into a full page with specific assignment grades. They can also see a profile screen that displays class rank and GPA.

This app exists because it fills a need - there is no "grades" app in our school district, and the website is slow and not at all user-friendly, especially on mobile devices.

## Gallery

<img src="https://user-images.githubusercontent.com/47064842/92181462-47886100-ee17-11ea-8b96-c37c6e8b0f8d.png" width="23%"></img> <img src="https://user-images.githubusercontent.com/47064842/92181458-46573400-ee17-11ea-9410-e37ffb4066fa.png" width="23%"></img> <img src="https://user-images.githubusercontent.com/47064842/92181464-4820f780-ee17-11ea-900e-52692f572fcc.png" width="23%"></img> <img src="https://user-images.githubusercontent.com/47064842/92181460-46efca80-ee17-11ea-9f8f-73df6bb6efe8.png" width="23%"></img>

## Installation

`iOS:` Via the [App Store](https://apps.apple.com/us/app/mygrades/id1495113299) or [Testflight](https://testflight.apple.com/join/N9fTLKmf) if you like living on the edge

`Android:` Via the [Google Play Store](https://play.google.com/store/apps/details?id=com.goldinguy.grades)

You can also find these download links for MyGrades [here](https://mygrades.app/)

#### Sample dummy user authentication

If you do not have a applicable account, you can use the following credentials to test MyGrades

```
Username: s2558161d
Password: figure51
```

## How it works

MyGrades is an app built on Flutter, a framework that enables cross-platform compatibility for a single codebase. It uses a multi-page layout with the following UI/UX flow:

`Open App` => `If previously logged in, automatically authenticate (otherwise go to login screen) and enter home page with all of your courses complete with class avgs and letter grades` => `Swipe left for recent grades, or swipe right to see upcoming assignments` => `Click on a class to see the grades in that class, sorted by either category (w/ weights) or recency` => `Click on a specific assignment to see more details`

MyGrades has two major submodules, [sis-dart-loader](https://github.com/MyGradesApp/dart-sis-loader), which gathers the student data that the app displays, and [grade-core](https://github.com/MyGradesApp/grades-core), which stores and formats it

## Development setup

Simply clone the repository, then run

```
flutter pub get
```

Then to test the app, enter the `grades-flutter` directory and run

```
flutter devices

flutter run -d "target device"
```

## Contributing

1. Fork MyGrades [here](https://github.com/MyGradesApp/grades-flutter/fork)
2. Create a feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

## Meta

Created by Students [@Noskcaj19](https://github.com/Noskcaj19) and [@GoldinGuy](https://github.com/GoldinGuy)

You can view the MyGrades `terms of service` and `privacy policy` [here](https://mygrades.app/privacy-policy.html)

<!-- Markdown link & img dfn's -->

[discord-url]: https://discord.gg/gKYSMeJ
[discord]: https://img.shields.io/discord/689176425701703810
[issues]: https://img.shields.io/github/issues/MyGradesApp/grades-flutter
[issues-url]: https://github.com/MyGradesApp/grades-flutter/issues
[contributors-shield]: https://img.shields.io/github/contributors/MyGradesApp/grades-flutter.svg?style=flat-square
[contributors-url]: https://github.com/MyGradesApp/grades-flutter/graphs/contributors
