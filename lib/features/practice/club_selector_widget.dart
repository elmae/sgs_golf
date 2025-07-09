import 'package:flutter/material.dart';
import 'package:sgs_golf/data/models/golf_club.dart';

class ClubSelectorWidget extends StatelessWidget {
  final GolfClubType selectedClub;
  final ValueChanged<GolfClubType> onClubSelected;

  const ClubSelectorWidget({
    super.key,
    required this.selectedClub,
    required this.onClubSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: GolfClubType.values.map((club) {
        final isSelected = club == selectedClub;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ChoiceChip(
            label: Text(club.name.toUpperCase()),
            selected: isSelected,
            onSelected: (_) => onClubSelected(club),
          ),
        );
      }).toList(),
    );
  }
}
