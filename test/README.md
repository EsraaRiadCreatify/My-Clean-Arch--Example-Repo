# دليل اختبارات المشروع

هذا الدليل يشرح بالتفصيل هيكل الاختبارات في المشروع، الغرض من كل ملف، ومتى وكيفية استخدام كل نوع من الاختبارات.

## جدول المحتويات
- [هيكل الاختبارات](#هيكل-الاختبارات)
- [أنواع الاختبارات](#أنواع-الاختبارات)
- [أمثلة عملية](#أمثلة-عملية)
- [أفضل الممارسات](#أفضل-الممارسات)
- [نصائح للاختبار](#نصائح-للاختبار)

## هيكل الاختبارات

```
test/
├── features/                # اختبارات الميزات
│   └── user/               # اختبارات ميزة المستخدم
│       ├── data/           # اختبارات طبقة البيانات
│       │   ├── datasources/ # اختبارات مصادر البيانات
│       │   │   ├── mock_user_local_data_source.dart
│       │   │   └── mock_user_remote_data_source.dart
│       │   ├── models/     # اختبارات النماذج
│       │   └── repositories/ # اختبارات المستودعات
│       ├── domain/         # اختبارات طبقة النطاق
│       │   ├── entities/   # اختبارات الكيانات
│       │   ├── repositories/ # اختبارات واجهات المستودعات
│       │   └── usecases/   # اختبارات حالات الاستخدام
│       └── presentation/   # اختبارات طبقة العرض
│           ├── pages/      # اختبارات الصفحات
│           ├── providers/  # اختبارات الـ Providers
│           └── widgets/    # اختبارات الـ Widgets
└── core/                   # اختبارات المكونات الأساسية
    ├── api/               # اختبارات الـ API
    ├── di/                # اختبارات الـ Dependency Injection
    ├── network/           # اختبارات الشبكة
    └── storage/           # اختبارات التخزين
```

## أنواع الاختبارات

### 1. اختبارات الوحدة (Unit Tests)
- **الغرض**: اختبار الوحدات المنفردة من الكود بشكل معزول
- **متى تستخدم**: عند اختبار منطق الأعمال، التحقق من صحة البيانات، ومعالجة الأخطاء
- **أمثلة**: اختبارات المستودعات، حالات الاستخدام، والـ Providers

```dart
// مثال: اختبار مستودع المستخدمين
test('getUsers returns empty list when offline', () async {
  when(() => mockConnectivity.isConnected).thenAnswer((_) async => false);
  
  final result = await repository.getUsers();
  
  expect(result, isEmpty);
  verify(() => mockLocalDataSource.getUsers()).called(1);
});
```

### 2. اختبارات الواجهة (Widget Tests)
- **الغرض**: اختبار مكونات واجهة المستخدم
- **متى تستخدم**: عند اختبار تفاعلات المستخدم، وعرض البيانات، وحالات التحميل
- **أمثلة**: اختبارات الصفحات، الـ Widgets، والـ Dialogs

```dart
// مثال: اختبار صفحة عرض المستخدمين
testWidgets('UserListPage shows loading indicator', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: UserListPage()),
    ),
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### 3. اختبارات التكامل (Integration Tests)
- **الغرض**: اختبار تدفق العمل الكامل للميزة
- **متى تستخدم**: عند اختبار سيناريوهات المستخدم الكاملة
- **أمثلة**: اختبارات تسجيل الدخول، إنشاء المستخدم، وتحديث البيانات

```dart
// مثال: اختبار تدفق إنشاء مستخدم
test('Complete user creation flow', () async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byType(TextField).first, 'Test User');
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
  
  expect(find.text('Test User'), findsOneWidget);
});
```

## أمثلة عملية

### 1. اختبارات مصادر البيانات
```dart
// test/features/user/data/datasources/mock_user_local_data_source.dart
class MockUserLocalDataSource extends Mock implements UserLocalDataSource {
  @override
  Future<List<UserEntity>> getUsers() async => [];
  
  @override
  Future<UserEntity?> getUser(String id) async => null;
}
```
- **الغرض**: محاكاة سلوك مصدر البيانات المحلي
- **متى تستخدم**: عند اختبار المستودعات في وضع عدم الاتصال
- **متى تحتاج إنشاء واحد**: عند إضافة مصدر بيانات جديد أو تغيير سلوك المصدر الحالي

### 2. اختبارات المستودعات
```dart
// test/features/user/data/repositories/user_repository_test.dart
void main() {
  late UserRepositoryImpl repository;
  late MockUserLocalDataSource mockLocalDataSource;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  
  setUp(() {
    mockLocalDataSource = MockUserLocalDataSource();
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  
  test('getUsers returns remote data when online', () async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(() => mockRemoteDataSource.getUsers()).thenAnswer((_) async => [mockUser]);
    
    final result = await repository.getUsers();
    
    expect(result, [mockUser]);
    verify(() => mockRemoteDataSource.getUsers()).called(1);
  });
}
```
- **الغرض**: اختبار منطق المستودع في حالات مختلفة
- **متى تستخدم**: عند اختبار تزامن البيانات، ومعالجة الأخطاء
- **متى تحتاج إنشاء واحد**: عند إضافة مستودع جديد أو تغيير منطق المستودع الحالي

### 3. اختبارات حالات الاستخدام
```dart
// test/features/user/domain/usecases/get_users_test.dart
void main() {
  late GetUsers usecase;
  late MockUserRepository mockRepository;
  
  setUp(() {
    mockRepository = MockUserRepository();
    usecase = GetUsers(mockRepository);
  });
  
  test('should get users from repository', () async {
    when(() => mockRepository.getUsers()).thenAnswer((_) async => [mockUser]);
    
    final result = await usecase();
    
    expect(result, [mockUser]);
    verify(() => mockRepository.getUsers()).called(1);
  });
}
```
- **الغرض**: اختبار منطق الأعمال في حالات الاستخدام
- **متى تستخدم**: عند اختبار قواعد الأعمال، والتحقق من صحة البيانات
- **متى تحتاج إنشاء واحد**: عند إضافة حالة استخدام جديدة أو تعديل المنطق الحالي

## أفضل الممارسات

### 1. تنظيم الاختبارات
- **استخدم أسماء واضحة**: `user_repository_test.dart` بدلاً من `test.dart`
- **قم بتجميع الاختبارات**: استخدم `group` لتنظيم الاختبارات المتعلقة
- **اكتب اختبارات صغيرة**: ركز على اختبار حالة واحدة في كل مرة

### 2. كتابة الاختبارات
- **استخدم `setUp` و `tearDown`**: لإعداد وتهيئة البيئة قبل وبعد كل اختبار
- **اكتب اختبارات مستقلة**: لا تعتمد الاختبارات على بعضها البعض
- **استخدم Mocktail**: لمحاكاة التبعيات واختبار السلوك

### 3. تغطية الاختبارات
- **اختر الحالات الحرجة**: ركز على الحالات التي تؤثر على سلوك التطبيق
- **اختر الحالات الحدية**: اختبر القيم الحدية والسيناريوهات غير المتوقعة
- **اختر حالات الخطأ**: تأكد من معالجة الأخطاء بشكل صحيح

## نصائح للاختبار

### 1. متى تكتب اختبارات جديدة
- عند إضافة ميزة جديدة
- عند إصلاح خطأ
- عند إعادة هيكلة الكود
- عند تغيير المنطق الحالي

### 2. متى تستخدم أنواع مختلفة من الاختبارات
- **اختبارات الوحدة**: للتحقق من صحة المنطق
- **اختبارات الواجهة**: للتحقق من تفاعلات المستخدم
- **اختبارات التكامل**: للتحقق من تدفق العمل الكامل

### 3. كيفية تحسين جودة الاختبارات
- اكتب اختبارات قابلة للقراءة
- استخدم أسماء واضحة للاختبارات
- اكتب اختبارات قابلة للصيانة
- حافظ على تغطية اختبارات عالية

## الدعم

إذا كنت بحاجة إلى مساعدة في كتابة الاختبارات أو لديك أسئلة، يرجى التواصل مع فريق التطوير. 