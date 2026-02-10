# Accessibility Module

The accessibility module provides comprehensive accessibility support for the Fast Golden Taxi application, including semantic widgets, focus helpers, and screen reader support.

## 📁 Directory Structure

```
lib/core/accessibility/
├── semantic_widgets.dart  # Semantic widgets for screen readers
└── focus_helpers.dart     # Focus management utilities
```

## 🎯 Key Components

### 1. SemanticWidgets (`semantic_widgets.dart`)

Semantic widgets that provide accessibility information to screen readers.

**Features:**
- Semantic buttons with labels and hints
- Semantic images with descriptions
- Semantic text with roles
- Semantic lists with item counts
- Semantic cards with actions
- Custom semantic widgets

**Usage:**
```dart
// Semantic button
SemanticButton(
  label: 'Submit form',
  hint: 'Press to submit the form',
  onPressed: () => submitForm(),
  child: const Text('Submit'),
);

// Semantic image
SemanticImage(
  label: 'Profile picture',
  hint: 'User profile picture',
  imageUrl: 'https://example.com/profile.jpg',
);

// Semantic text
SemanticText(
  label: 'Welcome message',
  text: 'Welcome to Fast Golden Taxi',
);

// Semantic list
SemanticList(
  itemCount: items.length,
  label: 'Available rides',
  children: items.map((item) => ListTile(title: Text(item.name))).toList(),
);
```

**SemanticButton:**
```dart
class SemanticButton extends StatelessWidget {
  final String label;
  final String? hint;
  final VoidCallback onPressed;
  final Widget child;
  final bool enabled;

  const SemanticButton({
    super.key,
    required this.label,
    this.hint,
    required this.onPressed,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      hint: hint,
      enabled: enabled,
      excludeSemantics: true,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child: child,
      ),
    );
  }
}
```

**SemanticImage:**
```dart
class SemanticImage extends StatelessWidget {
  final String label;
  final String? hint;
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SemanticImage({
    super.key,
    required this.label,
    this.hint,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: label,
      hint: hint,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
```

**SemanticText:**
```dart
class SemanticText extends StatelessWidget {
  final String label;
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const SemanticText({
    super.key,
    required this.label,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
```

**SemanticList:**
```dart
class SemanticList extends StatelessWidget {
  final int itemCount;
  final String label;
  final List<Widget> children;

  const SemanticList({
    super.key,
    required this.itemCount,
    required this.label,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      list: true,
      label: label,
      child: ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, index) {
          return Semantics(
            index: index,
            child: children[index],
          );
        },
      ),
    );
  }
}
```

**SemanticCard:**
```dart
class SemanticCard extends StatelessWidget {
  final String label;
  final String? hint;
  final VoidCallback? onTap;
  final Widget child;

  const SemanticCard({
    super.key,
    required this.label,
    this.hint,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: label,
      hint: hint,
      button: onTap != null,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
```

### 2. FocusHelpers (`focus_helpers.dart`)

Utilities for managing focus and keyboard navigation.

**Features:**
- Focus node management
- Focus traversal
- Focus scope handling
- Keyboard shortcuts
- Focus highlighting

**Usage:**
```dart
// Create focus node
final focusNode = FocusNode();

// Request focus
focusNode.requestFocus();

// Unfocus
focusNode.unfocus();

// Check if focused
if (focusNode.hasFocus) {
  // Handle focus
}

// Dispose focus node
focusNode.dispose();
```

**FocusScopeManager:**
```dart
class FocusScopeManager {
  static final FocusScopeManager _instance = FocusScopeManager._internal();
  factory FocusScopeManager() => _instance;
  FocusScopeManager._internal();

  final List<FocusNode> _focusNodes = [];

  void registerFocusNode(FocusNode node) {
    _focusNodes.add(node);
  }

  void unregisterFocusNode(FocusNode node) {
    _focusNodes.remove(node);
  }

  void requestNextFocus() {
    final currentIndex = _focusNodes.indexWhere((node) => node.hasFocus);
    if (currentIndex >= 0 && currentIndex < _focusNodes.length - 1) {
      _focusNodes[currentIndex + 1].requestFocus();
    }
  }

  void requestPreviousFocus() {
    final currentIndex = _focusNodes.indexWhere((node) => node.hasFocus);
    if (currentIndex > 0) {
      _focusNodes[currentIndex - 1].requestFocus();
    }
  }

  void unfocusAll() {
    for (final node in _focusNodes) {
      node.unfocus();
    }
  }
}
```

**FocusTraversalPolicy:**
```dart
class CustomFocusTraversalPolicy extends WidgetOrderTraversalPolicy {
  @override
  bool previous(FocusNode currentNode) {
    // Custom previous focus logic
    return super.previous(currentNode);
  }

  @override
  bool next(FocusNode currentNode) {
    // Custom next focus logic
    return super.next(currentNode);
  }
}
```

**KeyboardShortcuts:**
```dart
class KeyboardShortcuts extends StatelessWidget {
  final Widget child;

  const KeyboardShortcuts({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.tab) {
            if (HardwareKeyboard.instance.isShiftPressed) {
              FocusScopeManager().requestPreviousFocus();
            } else {
              FocusScopeManager().requestNextFocus();
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}
```

## 🏗️ Architecture

### Accessibility Flow

```
1. App starts
2. Initialize accessibility services
3. Register semantic widgets
4. Screen reader detects semantic information
5. User interacts with app
6. Screen reader announces changes
7. Focus management handles navigation
```

### Semantic Widget Structure

```
Semantic Widget
├── Semantics Widget
│   ├── Label (What is this?)
│   ├── Hint (What does it do?)
│   ├── Value (Current value)
│   └── Properties (button, image, etc.)
└── Child Widget
```

## 📝 Best Practices

### 1. Use Semantic Widgets for Interactive Elements

```dart
// Good
SemanticButton(
  label: 'Submit form',
  onPressed: () => submitForm(),
  child: const Text('Submit'),
);

// Bad
ElevatedButton(
  onPressed: () => submitForm(),
  child: const Text('Submit'),
);
```

### 2. Provide Descriptive Labels

```dart
// Good
SemanticButton(
  label: 'Submit booking request',
  onPressed: () => submitBooking(),
  child: const Text('Submit'),
);

// Bad
SemanticButton(
  label: 'Submit',
  onPressed: () => submitBooking(),
  child: const Text('Submit'),
);
```

### 3. Use Hints for Additional Context

```dart
// Good
SemanticButton(
  label: 'Submit form',
  hint: 'Press to submit the booking form',
  onPressed: () => submitForm(),
  child: const Text('Submit'),
);

// Bad
SemanticButton(
  label: 'Submit form',
  onPressed: () => submitForm(),
  child: const Text('Submit'),
);
```

### 4. Manage Focus Properly

```dart
// Good
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    FocusScopeManager().registerFocusNode(_focusNode);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    FocusScopeManager().unregisterFocusNode(_focusNode);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
    );
  }
}

// Bad
// Don't manage focus nodes properly
```

### 5. Support Keyboard Navigation

```dart
// Good
KeyboardShortcuts(
  child: MyForm(),
);

// Bad
// Don't support keyboard navigation
```

## 🔧 Usage Examples

### Accessible Form

```dart
class AccessibleForm extends StatefulWidget {
  @override
  State<AccessibleForm> createState() => _AccessibleFormState();
}

class _AccessibleFormState extends State<AccessibleForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    FocusScopeManager().registerFocusNode(_nameFocusNode);
    FocusScopeManager().registerFocusNode(_emailFocusNode);
    FocusScopeManager().registerFocusNode(_phoneFocusNode);
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Semantics(
            label: 'Name field',
            hint: 'Enter your full name',
            textField: true,
            child: TextFormField(
              focusNode: _nameFocusNode,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_emailFocusNode);
              },
            ),
          ),
          Semantics(
            label: 'Email field',
            hint: 'Enter your email address',
            textField: true,
            child: TextFormField(
              focusNode: _emailFocusNode,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_phoneFocusNode);
              },
            ),
          ),
          Semantics(
            label: 'Phone field',
            hint: 'Enter your phone number',
            textField: true,
            child: TextFormField(
              focusNode: _phoneFocusNode,
              decoration: const InputDecoration(
                labelText: 'Phone',
              ),
            ),
          ),
          SemanticButton(
            label: 'Submit form',
            hint: 'Press to submit the form',
            onPressed: () => _submitForm(),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Submit form
    }
  }
}
```

### Accessible List

```dart
class AccessibleList extends StatelessWidget {
  final List<Ride> rides;

  const AccessibleList({super.key, required this.rides});

  @override
  Widget build(BuildContext context) {
    return SemanticList(
      itemCount: rides.length,
      label: 'Available rides',
      children: rides.map((ride) {
        return SemanticCard(
          label: 'Ride to ${ride.destination}',
          hint: 'Tap to view details',
          onTap: () => _showRideDetails(ride),
          child: ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text(ride.destination),
            subtitle: Text('${ride.price} - ${ride.duration}'),
          ),
        );
      }).toList(),
    );
  }

  void _showRideDetails(Ride ride) {
    // Show ride details
  }
}
```

### Accessible Image Gallery

```dart
class AccessibleImageGallery extends StatelessWidget {
  final List<String> images;

  const AccessibleImageGallery({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return SemanticImage(
          label: 'Image ${index + 1} of ${images.length}',
          hint: 'Swipe to view more images',
          imageUrl: images[index],
        );
      },
    );
  }
}
```

### Focus Management

```dart
class FocusableWidget extends StatefulWidget {
  @override
  State<FocusableWidget> createState() => _FocusableWidgetState();
}

class _FocusableWidgetState extends State<FocusableWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    FocusScopeManager().registerFocusNode(_focusNode);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    FocusScopeManager().unregisterFocusNode(_focusNode);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter) {
            // Handle enter key
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _focusNode.hasFocus
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: const Text('Focusable widget'),
      ),
    );
  }
}
```

## 🧪 Testing

### Widget Tests

```dart
testWidgets('SemanticButton should have correct semantics', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SemanticButton(
          label: 'Submit',
          onPressed: () {},
          child: const Text('Submit'),
        ),
      ),
    ),
  );

  final semantics = tester.getSemantics(find.byType(SemanticButton));
  expect(semantics.label, 'Submit');
  expect(semantics.hasAction(SemanticsAction.tap), true);
});
```

### Accessibility Tests

```dart
testWidgets('Form should be accessible', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AccessibleForm(),
      ),
    ),
  );

  // Test focus navigation
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pumpAndSettle();

  expect(find.byType(TextFormField), findsWidgets);
});
```

## 📚 Additional Resources

- [Flutter Accessibility](https://flutter.dev/docs/development/accessibility-and-internationalization/accessibility)
- [Semantics Widget](https://api.flutter.dev/flutter/widgets/Semantics-class.html)
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

## 🤝 Contributing

When adding accessibility features:

1. Test with screen readers (VoiceOver, TalkBack)
2. Test keyboard navigation
3. Test with accessibility inspector
4. Ensure proper semantic labels
5. Update documentation

## 📄 License

This module is part of the Fast Golden Taxi project.