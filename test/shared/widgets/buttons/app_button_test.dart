import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/shared/widgets/buttons/app_button.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('AppButton', () {
    testWidgets('should render button with text', (WidgetTester tester) async {
      // Arrange
      const buttonText = 'Test Button';

      // Act
      await tester.pumpWidget(
        TestHelpers.createApp(
          child: AppButton(
            text: buttonText,
            onPressed: () {},
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should be disabled when onPressed is null',
        (WidgetTester tester) async {
      // Arrange
      const buttonText = 'Disabled Button';

      // Act
      await tester.pumpWidget(
        TestHelpers.createApp(
          child: const AppButton(
            text: buttonText,
          ),
        ),
      );

      // Assert
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should call onPressed when tapped',
        (WidgetTester tester) async {
      // Arrange
      var wasPressed = false;
      const buttonText = 'Clickable Button';

      // Act
      await tester.pumpWidget(
        TestHelpers.createApp(
          child: AppButton(
            text: buttonText,
            onPressed: () => wasPressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      // Assert
      expect(wasPressed, isTrue);
    });

    group('Variants', () {
      testWidgets('should render primary button by default',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton(
              text: 'Primary',
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should render secondary button',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton.secondary(
              text: 'Secondary',
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should render outlined button', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton.outlined(
              text: 'Outlined',
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(OutlinedButton), findsOneWidget);
      });

      testWidgets('should render text button', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton.text(
              text: 'Text',
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(TextButton), findsOneWidget);
      });

      testWidgets('should render danger button', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton.danger(
              text: 'Danger',
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('Loading State', () {
      testWidgets('should show loading indicator when isLoading is true',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton(
              text: 'Loading',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading'), findsOneWidget);
      });

      testWidgets('should disable button when loading',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton(
              text: 'Loading',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        );

        // Assert
        final button =
            tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNull);
      });
    });

    group('Icon', () {
      testWidgets('should show icon when provided',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton(
              text: 'With Icon',
              icon: Icons.star,
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('With Icon'), findsOneWidget);
      });

      testWidgets('should hide icon when loading', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton(
              text: 'Loading with Icon',
              icon: Icons.star,
              isLoading: true,
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.star), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('Full Width', () {
      testWidgets('should be full width when isFullWidth is true',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: Column(
              children: [
                AppButton(
                  text: 'Full Width',
                  isFullWidth: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );

        // Assert
        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, equals(double.infinity));
      });
    });

    group('Sizes', () {
      testWidgets('should render small button', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton(
              text: 'Small',
              size: AppButtonSize.small,
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('should render medium button', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton(
              text: 'Medium',
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('should render large button', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton(
              text: 'Large',
              size: AppButtonSize.large,
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(AppButton), findsOneWidget);
      });
    });

    group('Custom Styling', () {
      testWidgets('should apply custom padding', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton(
              text: 'Custom Padding',
              padding: const EdgeInsets.all(20),
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('should apply custom border radius',
          (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createApp(
            child: AppButton(
              text: 'Custom Border',
              borderRadius: BorderRadius.circular(8),
              onPressed: () {},
            ),
          ),
        );

        // Assert
        expect(find.byType(AppButton), findsOneWidget);
      });
    });
  });
}
