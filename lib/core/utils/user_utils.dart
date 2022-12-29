import 'package:priorli/core/user/entities/user.dart';

bool isUserAdmin(User? user) => user?.roles.contains('admin') == true;
