import 'visit.dart';

class VisitsRepository {
  static List<Visit> loadVisits(Category category) {
    const allVisits = <Visit> [
      Visit(
        category: Category.today,
        site: 'MGH',
        location: 'Jackson 5',
        summary: 'Quisque viverra nunc eget dui. Etiam iaculis tincidunt sapien. Aliquam erat volutpat. Mauris sagittis mi suscipit est. Maecenas',
        id: 0,
        isFeatured: true,
        name: 'Ellison 6',
        date: 'Today',
        time: '11:30',
        price: 120,
        
      ),
      Visit(
        category: Category.today,
        site: 'MGH',
        location: 'Jackson 5',
        summary: 'Quisque viverra nunc eget dui. Etiam iaculis tincidunt sapien. Aliquam erat volutpat. Mauris sagittis mi suscipit est. Maecenas',
        id: 1,
        isFeatured: true,
        name: 'Transplant',
        date: 'Today',
        time: '11:30',
        price: 58,
      ),
      Visit(
        category: Category.today,
        site: 'MGH',
        location: 'Jackson 5',
        summary: 'Quisque viverra nunc eget dui. Etiam iaculis tincidunt sapien. Aliquam erat volutpat. Mauris sagittis mi suscipit est. Maecenas',
        id: 2,
        isFeatured: false,
        name: 'Emergency Department',
        date: 'Today',
        time: '11:30',
        price: 35,
      ),
      Visit(
        category: Category.today,
        site: 'MGH',
        location: 'Jackson 5',
        summary: 'Quisque viverra nunc eget dui. Etiam iaculis tincidunt sapien. Aliquam erat volutpat. Mauris sagittis mi suscipit est. Maecenas',
        id: 3,
        isFeatured: true,
        name: 'IMA',
        date: 'Today',
        time: '11:30',
        price: 98,
      ),
    ];
    if (category == Category.all) {
      return allVisits;
    } else {
      return allVisits.where((Visit p) {
        return p.category == category;
      }).toList();
    }
  }
}
