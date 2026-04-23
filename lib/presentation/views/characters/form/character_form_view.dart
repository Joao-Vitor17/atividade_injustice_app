import 'package:flutter/material.dart';
import 'package:injustice_app/domain/models/extensions/character_ui.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/character_entity.dart';
import '../../../controllers/characters_view_model.dart';
import 'package:signals_flutter/signals_flutter.dart';

class CharacterFormView extends StatefulWidget {
  final Character? character;

  const CharacterFormView({
    super.key,
    this.character,
  });

  @override
  State<CharacterFormView> createState() => _CharacterFormViewState();
}

class _CharacterFormViewState extends State<CharacterFormView> {
  late final CharactersViewModel _viewModel;
  late final TextEditingController _nameController;
  late CharacterClass _selectedClass;
  late CharacterRarity _selectedRarity;
  late CharacterAlignment _selectedAlignment;
  late int _selectedLevel;
  late int _selectedStars;
  late int _selectedThreat;
  late int _selectedAttack;
  late int _selectedHealth;

  bool get _isCreating => widget.character == null;

  @override
  void initState() {
    super.initState();
    _viewModel = injector.get<CharactersViewModel>();
    
    if (_isCreating) {
      _nameController = TextEditingController();
      _selectedClass = CharacterClass.poderoso;
      _selectedRarity = CharacterRarity.prata;
      _selectedAlignment = CharacterAlignment.heroi;
      _selectedLevel = 1;
      _selectedStars = 1;
      _selectedThreat = 0;
      _selectedAttack = 50;
      _selectedHealth = 100;
    } else {
      final character = widget.character!;
      _nameController = TextEditingController(text: character.name);
      _selectedClass = character.characterClass;
      _selectedRarity = character.rarity;
      _selectedAlignment = character.alignment;
      _selectedLevel = character.level;
      _selectedStars = character.stars;
      _selectedThreat = character.threat;
      _selectedAttack = character.attack;
      _selectedHealth = character.health;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCharacter() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome do personagem é obrigatório')),
      );
      return;
    }

    if (_isCreating) {
      final newCharacter = Character(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        characterClass: _selectedClass,
        rarity: _selectedRarity,
        level: _selectedLevel,
        threat: _selectedThreat,
        attack: _selectedAttack,
        health: _selectedHealth,
        stars: _selectedStars,
        alignment: _selectedAlignment,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _viewModel.commands.addCharacter(newCharacter);
    } else {
      final updatedCharacter = widget.character!.copyWith(
        name: _nameController.text,
        characterClass: _selectedClass,
        rarity: _selectedRarity,
        level: _selectedLevel,
        threat: _selectedThreat,
        attack: _selectedAttack,
        health: _selectedHealth,
        stars: _selectedStars,
        alignment: _selectedAlignment,
        updatedAt: DateTime.now(),
      );
      _viewModel.commands.updateCharacter(updatedCharacter);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isLoading = _isCreating
          ? _viewModel.commands.createCharacterCommand.isExecuting.value
          : _viewModel.commands.updateCharacterCommand.isExecuting.value;

      return Scaffold(
        appBar: AppBar(
          title: Text(_isCreating ? 'Criar Personagem' : 'Editar Personagem'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome
              Text(
                'Nome',
                style: context.textStyles.titleSmall?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Digite o nome do personagem',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Classe
              Text(
                'Classe',
                style: context.textStyles.titleSmall?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<CharacterClass>(
                value: _selectedClass,
                items: CharacterClass.values
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Row(
                            children: [
                              Icon(c.icon, size: 18),
                              const SizedBox(width: AppSpacing.sm),
                              Text(c.displayName),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedClass = value);
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Raridade
              Text(
                'Raridade',
                style: context.textStyles.titleSmall?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<CharacterRarity>(
                value: _selectedRarity,
                items: CharacterRarity.values
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.displayName),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedRarity = value);
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.diamond),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Alinhamento
              Text(
                'Alinhamento',
                style: context.textStyles.titleSmall?.semiBold,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<CharacterAlignment>(
                value: _selectedAlignment,
                items: CharacterAlignment.values
                    .map((a) => DropdownMenuItem(
                          value: a,
                          child: Text(a.displayName),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedAlignment = value);
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.balance),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Level
              Text(
                'Level: $_selectedLevel',
                style: context.textStyles.titleSmall?.semiBold,
              ),
              Slider(
                value: _selectedLevel.toDouble(),
                min: 1,
                max: 80,
                divisions: 79,
                onChanged: (value) {
                  setState(() => _selectedLevel = value.toInt());
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Estrelas
              Text(
                'Estrelas: $_selectedStars',
                style: context.textStyles.titleSmall?.semiBold,
              ),
              Slider(
                value: _selectedStars.toDouble(),
                min: 1,
                max: 14,
                divisions: 13,
                onChanged: (value) {
                  setState(() => _selectedStars = value.toInt());
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Ameaça
              Text(
                'Ameaça: $_selectedThreat',
                style: context.textStyles.titleSmall?.semiBold,
              ),
              Slider(
                value: _selectedThreat.toDouble(),
                min: 0,
                max: 500,
                divisions: 50,
                onChanged: (value) {
                  setState(() => _selectedThreat = value.toInt());
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Ataque
              Text(
                'Ataque: $_selectedAttack',
                style: context.textStyles.titleSmall?.semiBold,
              ),
              Slider(
                value: _selectedAttack.toDouble(),
                min: 50,
                max: 1000,
                divisions: 95,
                onChanged: (value) {
                  setState(() => _selectedAttack = value.toInt());
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Vida
              Text(
                'Vida: $_selectedHealth',
                style: context.textStyles.titleSmall?.semiBold,
              ),
              Slider(
                value: _selectedHealth.toDouble(),
                min: 100,
                max: 5000,
                divisions: 98,
                onChanged: (value) {
                  setState(() => _selectedHealth = value.toInt());
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: isLoading ? null : _saveCharacter,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(_isCreating ? 'Criar' : 'Atualizar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
