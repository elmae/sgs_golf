
/// Widget para seleccionar el tipo de palo de golf de forma visual e interactiva.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/data/models/golf_club.dart';
import 'package:sgs_golf/features/practice/providers/practice_provider.dart';


/// Widget visual e interactivo para seleccionar un palo de golf.
class ClubSelectorWidget extends StatelessWidget {
  /// Club actualmente seleccionado.
  final GolfClubType? selectedClub;
  /// Callback cuando se selecciona un club.
  final ValueChanged<GolfClubType> onClubSelected;

  /// Constructor.
  const ClubSelectorWidget({
    Key? key,
    required this.selectedClub,
    required this.onClubSelected,
  }) : super(key: key);

  /// Íconos representativos para cada tipo de palo.
  static const Map<GolfClubType, IconData> clubIcons = {
    GolfClubType.pw: Icons.golf_course,
    GolfClubType.gw: Icons.flag,
    GolfClubType.sw: Icons.beach_access,
    GolfClubType.lw: Icons.waves,
  };

  /// Nombres legibles para cada tipo de palo.
  static const Map<GolfClubType, String> clubNames = {
    GolfClubType.pw: 'Pitching Wedge',
    GolfClubType.gw: 'Gap Wedge',
    GolfClubType.sw: 'Sand Wedge',
    GolfClubType.lw: 'Lob Wedge',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: GolfClubType.values.map((club) {
        final isSelected = club == selectedClub;
        return GestureDetector(
          onTap: () => onClubSelected(club),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.transparent,
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(clubIcons[club], size: 32, color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey),
                const SizedBox(height: 8),
                Text(
                  clubNames[club]!,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Ejemplo de integración con Provider.
typedef OnClubSelected = void Function(GolfClubType);

/// Widget que integra el selector de club con el provider de práctica.
class ClubSelectorWithProvider extends StatelessWidget {
  const ClubSelectorWithProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final practiceProvider = Provider.of<PracticeProvider>(context);
    final selectedClub = practiceProvider.activeSession?.shots.isNotEmpty == true
        ? practiceProvider.activeSession!.shots.last.clubType
        : null;
    return ClubSelectorWidget(
      selectedClub: selectedClub,
      onClubSelected: (club) {
        // Actualiza el estado del provider para guardar el club seleccionado para el siguiente disparo
        practiceProvider.setNextClubType(club);
      },
    );
  }
}
