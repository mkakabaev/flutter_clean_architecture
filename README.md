# flutter_clean_architecture

A simple Flutter project to demonstrate the concept of Clean Architecture. There are a lot of ways to implement Clean Architecture for sure. Here is my version. 

Key points are:

- Feature based project structure;
- Less pulling data from repositories, more streaming;
- Only use-cases have an access to repositories.  
- Simple boilerplate generation using [hygen](https://hygen.io);

The project also can be used as some bootstrapping template as it covers different aspects of a mobile application:

- Networking (based on Dio + retrofit, token authentication, error handling, token refreshing etc.)
- Dependency Injection (get_it, injectable)
- State Management (BLOC)[^1] 
- Navigation (go_router, strong route param typing, custom transitions, deep linking)
- Local secure storage (flutter_secure_storage) to handle sensitive data, like authentication credentials

A lot of builders are involved (retrofit, injectable, json_serialization). Do not forget to use [build_runner](https://pub.dev/packages/build_runner)! 

[^1]: Actually, the project uses the BLOC pattern in the presentation layer only, there are also plans to add other presentation patterns like Riverpod, Provider, etc.

Under construction. More updates are coming very soon. 
Thanks!

P.S. Looking for a job. 
