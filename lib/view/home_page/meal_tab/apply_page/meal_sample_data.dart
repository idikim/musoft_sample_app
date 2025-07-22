import 'package:musoft_sample_app/model/meal.dart';

List<Meal> getMealsFor(DateTime date, String mealType) {
  final dateKey = '${date.year}-${date.month}-${date.day}';
  if (mealType == '점심') {
    return [
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}lunch1/200',
        menu: '불고기덮밥',
        description: '고소한 불고기와 밥이 어우러진 한 그릇 요리',
        price: '7,000',
      ),
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}lunch2/200',
        menu: '치킨마요',
        description: '닭고기와 마요네즈의 조화, 인기 메뉴',
        price: '6,500',
      ),
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}lunch3/200',
        menu: '제육볶음',
        description: '매콤한 돼지고기 볶음과 밥',
        price: '7,500',
      ),
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}lunch4/200',
        menu: '돈까스',
        description: '바삭한 돈까스와 특제 소스',
        price: '8,000',
      ),
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}lunch5/200',
        menu: '비빔밥',
        description: '다양한 나물과 고추장이 어우러진 비빔밥',
        price: '7,200',
      ),
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}lunch6/200',
        menu: '카레라이스',
        description: '진한 카레와 밥의 만남',
        price: '6,800',
      ),
    ];
  } else {
    return [
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}dinner1/200',
        menu: '오므라이스',
        description: '계란으로 감싼 볶음밥',
        price: '7,300',
      ),
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}dinner2/200',
        menu: '김치볶음밥',
        description: '매콤한 김치와 밥의 조화',
        price: '6,900',
      ),
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}dinner3/200',
        menu: '닭갈비덮밥',
        description: '매콤한 닭갈비와 밥',
        price: '7,800',
      ),
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}dinner4/200',
        menu: '함박스테이크',
        description: '두툼한 함박스테이크와 소스',
        price: '8,200',
      ),
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}dinner5/200',
        menu: '새우볶음밥',
        description: '탱글한 새우와 볶음밥',
        price: '7,400',
      ),
      Meal(
        imageUrl: 'https://picsum.photos/seed/${dateKey}dinner6/200',
        menu: '참치마요',
        description: '참치와 마요네즈의 고소함',
        price: '6,700',
      ),
    ];
  }
}
