import 'participant.dart';

class ParticipantsRepository {
  static List<Participant> loadParticipants(Category category) {
    const allParticipants = <Participant>[
      Participant(
        category: Category.admin,
        id: 0,
        name: 'Jane',
      ),
      Participant(
        category: Category.observer,
        id: 1,
        name: 'John',
      ),
      Participant(
        category: Category.expert,
        id: 2,
        name: 'Allie',
      ),
    ];
    if (category == Category.admin) {
      return allParticipants;
    } else {
      return allParticipants.where((Participant p) {
        return p.category == category;
      }).toList();
    }
  }
}
