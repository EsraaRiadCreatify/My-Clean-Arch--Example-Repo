# نظام التحميل (Loading System)

نظام متكامل لإدارة حالات التحميل في التطبيق، يدعم كلاً من التحميل المحلي والعالمي.

## المكونات

### 1. LoadingOverlay Widget

الـ Widget الأساسي الذي يعرض شاشة التحميل.

```dart
LoadingOverlay(
  isLoading: true,                    // حالة التحميل
  child: YourWidget(),               // الـ Widget المراد تغليفه
  message: "جاري التحميل...",        // رسالة اختيارية
  backgroundColor: Colors.black54,    // لون الخلفية
  spinnerColor: Colors.white,         // لون المؤشر
  opacity: 0.5,                      // شفافية الخلفية
)
```

### 2. LoadingController

مدير التحميل الرئيسي (Singleton) الذي يتحكم في حالات التحميل.

```dart
final controller = LoadingController();

// بدء التحميل
controller.startLoading(
  isGlobal: true,                    // تحميل عالمي أم محلي
  message: "جاري التحميل...",
  backgroundColor: Colors.black54,
  spinnerColor: Colors.white,
  opacity: 0.5,
);

// إيقاف التحميل
controller.stopLoading(isGlobal: true);

// تغليف widget بطبقة تحميل
controller.wrapWithLoading(
  child: YourWidget(),
  message: "جاري التحميل...",
);
```

### 3. LoadingExtension

امتداد لـ BuildContext لتسهيل استخدام التحميل.

```dart
// بدء التحميل
context.showLoading(
  message: "جاري التحميل...",
  backgroundColor: Colors.black54,
  spinnerColor: Colors.white,
);

// إيقاف التحميل
context.hideLoading();

// تغليف widget بطبقة تحميل
context.withLoading(
  child: YourWidget(),
  message: "جاري التحميل...",
);
```

## حالات الاستخدام

### 1. التحميل المحلي (مع context)

مثال في شاشة:

```dart
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: context.withLoading(
        child: Center(
          child: Column(
            children: [
              // محتوى الشاشة
            ],
          ),
        ),
        message: "جاري تحميل الملف الشخصي...",
      ),
    );
  }
}
```

### 2. التحميل العالمي (بدون context)

مثال في service:

```dart
class ProfileService {
  final _loadingController = LoadingController();

  Future<void> loadProfile() async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري جلب البيانات...",
      );
      
      // تنفيذ العملية
      
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }
}
```

### 3. التحميل في عمليات الشبكة

مثال في data source:

```dart
class UserRemoteDataSource {
  final _loadingController = LoadingController();

  Future<UserEntity> getUser(String id) async {
    try {
      _loadingController.startLoading(
        isGlobal: true,
        message: "جاري جلب بيانات المستخدم...",
      );
      
      final response = await _apiClient.get<UserEntity>(
        endpoint: '/users/$id',
      );
      return response.data!;
    } finally {
      _loadingController.stopLoading(isGlobal: true);
    }
  }
}
```

## الفروق بين التحميل المحلي والعالمي

### التحميل المحلي

- يحتاج إلى `context`
- يظهر فقط على الـ widget المحدد
- يختفي تلقائياً عند إغلاق الشاشة
- مناسب للعمليات السريعة والمحدودة

### التحميل العالمي

- لا يحتاج إلى `context`
- يظهر على الشاشة بأكملها
- يجب إيقافه يدوياً
- مناسب للعمليات الطويلة وعمليات الشبكة

## أفضل الممارسات

1. استخدم `try-finally` مع التحميل العالمي لضمان إيقافه حتى في حالة حدوث خطأ
2. اختر نوع التحميل المناسب حسب طبيعة العملية:
   - محلي للعمليات السريعة والمحدودة
   - عالمي للعمليات الطويلة وعمليات الشبكة
3. قم بتخصيص رسائل التحميل لتكون واضحة للمستخدم
4. استخدم الألوان المناسبة للخلفية والمؤشر حسب تصميم التطبيق

## التكامل مع التطبيق

للاستخدام في التطبيق، قم بإضافة `LoadingWrapper` في `main.dart`:

```dart
void main() {
  final navigatorKey = GlobalKey<NavigatorState>();
  
  runApp(
    ProviderScope(
      child: LoadingWrapper(
        navigatorKey: navigatorKey,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          // باقي إعدادات التطبيق
        ),
      ),
    ),
  );
}
```

## المتطلبات

أضف حزمة `flutter_spinkit` إلى `pubspec.yaml`:

```yaml
dependencies:
  flutter_spinkit: ^5.2.0
```
