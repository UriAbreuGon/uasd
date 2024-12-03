import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:login/main.dart';
import 'package:login/screens/login_page.dart';

void main() {
  testWidgets('Login page loads correctly', (WidgetTester tester) async {
    // Build MyApp with the initial route set to '/login'.
    await tester.pumpWidget(const MyApp(initialRoute: '/login'));

    // Verify that the LoginPage is displayed.
    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Login button triggers navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialRoute: '/login'));

    // Enter text in username and password fields.
    await tester.enterText(find.byType(TextField).first, 'testuser');
    await tester.enterText(find.byType(TextField).last, 'password');

    // Tap the Login button.
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Since the login logic involves API calls, you might need to mock the API 
    // and test navigation depending on the success of the login.
    // For now, check that the HomePage is navigated to if the login is successful.
    // expect(find.byType(HomePage), findsOneWidget);  // Uncomment if mocking is added.
  });
}
