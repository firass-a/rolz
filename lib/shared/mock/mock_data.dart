import 'dart:math';

import 'package:collection/collection.dart';

import '../models/models.dart';
import 'image_helper.dart';

// ---------------------------------------------------------------------------
// Name / location / vocabulary pools used to synthesize realistic profiles.
// ---------------------------------------------------------------------------

const List<String> _maleFirstNames = [
  'Karim', 'Yanis', 'Mehdi', 'Riad', 'Sofiane', 'Amine', 'Bilal', 'Nassim',
  'Rayan', 'Anis', 'Walid', 'Farid', 'Samir', 'Omar', 'Adel', 'Ilyes',
  'Rachid', 'Fares', 'Amir', 'Zineddine',
];

const List<String> _femaleFirstNames = [
  'Amina', 'Layla', 'Sara', 'Nadia', 'Yasmine', 'Imane', 'Meriem', 'Sabrina',
  'Lina', 'Farah', 'Kenza', 'Salma', 'Hind', 'Douaa', 'Ines', 'Rania',
  'Asma', 'Widad', 'Sofia', 'Manel',
];

const List<String> _lastNames = [
  'Sofiane', 'Bensaid', 'Meziane', 'Benali', 'Cherif', 'Amrani', 'Boudiaf',
  'Haddad', 'Khelifi', 'Mansouri', 'Zerrouki', 'Belkacem', 'Boumediene',
  'Kaddour', 'Saidi', 'Bouzid', 'Larbi', 'Taleb', 'Ferhat', 'Ould Ali',
];

class _CityInfo {
  final String city;
  final String country;
  final String nationality;
  const _CityInfo(this.city, this.country, this.nationality);
}

const List<_CityInfo> _cities = [
  _CityInfo('Algiers', 'Algeria', 'Algerian'),
  _CityInfo('Oran', 'Algeria', 'Algerian'),
  _CityInfo('Constantine', 'Algeria', 'Algerian'),
  _CityInfo('Annaba', 'Algeria', 'Algerian'),
  _CityInfo('Tlemcen', 'Algeria', 'Algerian'),
  _CityInfo('Béjaïa', 'Algeria', 'Algerian'),
  _CityInfo('Sétif', 'Algeria', 'Algerian'),
  _CityInfo('Paris', 'France', 'French-Algerian'),
  _CityInfo('Marseille', 'France', 'French-Algerian'),
  _CityInfo('Casablanca', 'Morocco', 'Moroccan'),
  _CityInfo('Tunis', 'Tunisia', 'Tunisian'),
  _CityInfo('Dubai', 'UAE', 'Emirati'),
  _CityInfo('Cairo', 'Egypt', 'Egyptian'),
];

const List<String> _skillsPool = [
  'Acting', 'Improvisation', 'Dance', 'Singing', 'Arabic', 'French',
  'English', 'Martial Arts', 'Horse Riding', 'Stunt Work', 'Comedy',
  'Drama', 'Voice Modulation', 'Classical Ballet', 'Hip-Hop Dance',
  'Stage Combat', 'Public Speaking', 'Modeling Poses', 'Photography',
  'Video Editing',
];

const List<String> _eyeColors = ['Brown', 'Black', 'Green', 'Hazel', 'Blue'];
const List<String> _hairColors = [
  'Black', 'Brown', 'Dark Brown', 'Blonde', 'Auburn',
];

const List<String> _educationPool = [
  'Institut Supérieur des Métiers des Arts du Spectacle (Alger)',
  "Conservatoire National d'Art Dramatique",
  'École Supérieure des Beaux-Arts d\'Alger',
  'Cours Florent, Paris',
  'École des Arts et Métiers, Oran',
  'Autodidacte / Self-taught',
  'Institut National des Arts Dramatiques',
];

const Map<TalentCategory, String> _categoryFrLabel = {
  TalentCategory.actor: 'Comédien',
  TalentCategory.actress: 'Comédienne',
  TalentCategory.model: 'Mannequin',
  TalentCategory.extra: 'Figurant(e)',
  TalentCategory.voiceActor: 'Comédien(ne) voix off',
  TalentCategory.dancer: 'Danseur/Danseuse',
  TalentCategory.musician: 'Musicien(ne)',
  TalentCategory.contentCreator: 'Créateur(rice) de contenu',
  TalentCategory.photographer: 'Photographe',
};

const List<String> _companyNames = [
  'Atlas Films Production', 'Casbah Studios', 'Mediterranean Casting Agency',
  'Dune Productions', 'Sahara Media Group', 'Nour Films',
  'Kasbah TV Network', 'Numidia Pictures', 'El Djazair Studios',
  'Maghreb Casting House', 'Oran Media Productions',
  'Constantine Film Bureau', 'Zenith Talent Agency', 'Andalus Entertainment',
  'Barbary Coast Films',
];

const List<String> _agencyNames = [
  'Prestige Talent Agency', 'Étoile Models Algiers', 'Kasbah Talent Group',
  'Maghreb Faces Agency', 'Sahara Stars Management', 'Numidia Talent House',
  'El Djazair Models', 'Atlas Faces Agency', 'Mediterranean Talents',
  'Oran Elite Agency',
];

const List<List<String>> _agencySpecialtyPool = [
  ['Film', 'Television'],
  ['Fashion', 'Commercial'],
  ['Theater', 'Voice Over'],
  ['Music Video', 'Commercial'],
  ['Film', 'Fashion'],
  ['Television', 'Commercial'],
  ['Fashion', 'Music Video'],
  ['Film', 'Theater'],
  ['Commercial', 'Voice Over'],
  ['Fashion', 'Film', 'Commercial'],
];

const List<Map<String, String>> _creditPool = [
  {'title': 'Sable et Silence', 'role': 'Rôle secondaire'},
  {'title': 'Les Ombres de la Casbah', 'role': 'Figuration'},
  {'title': 'Dar El Bacha (Saison 1)', 'role': 'Rôle récurrent'},
  {'title': 'Nour', 'role': 'Rôle principal'},
  {'title': 'Publicité Djezzy', 'role': 'Talent principal'},
  {'title': "Festival de Théâtre d'Alger", 'role': 'Comédien(ne)'},
  {'title': 'Court métrage "Le Dernier Tramway"', 'role': 'Rôle principal'},
  {'title': 'Campagne Hiba Couture', 'role': 'Mannequin'},
  {'title': "Documentaire Terre d'Algérie", 'role': 'Voix off'},
  {'title': 'Clip vidéo Raï', 'role': 'Danseur/Danseuse'},
  {'title': 'Publicité CPA Bank', 'role': 'Talent'},
  {'title': 'Algiers Fashion Week', 'role': 'Mannequin défilé'},
];

const List<TalentCategory> _femaleCategories = [
  TalentCategory.actress,
  TalentCategory.model,
  TalentCategory.extra,
  TalentCategory.voiceActor,
  TalentCategory.dancer,
  TalentCategory.musician,
  TalentCategory.contentCreator,
  TalentCategory.photographer,
];

const List<TalentCategory> _maleCategories = [
  TalentCategory.actor,
  TalentCategory.model,
  TalentCategory.extra,
  TalentCategory.voiceActor,
  TalentCategory.dancer,
  TalentCategory.musician,
  TalentCategory.contentCreator,
  TalentCategory.photographer,
];

// ---------------------------------------------------------------------------
// Small deterministic helpers.
// ---------------------------------------------------------------------------

String _pad(int n) => n.toString().padLeft(3, '0');

String _id(String prefix, int n) => '$prefix-${_pad(n)}';

String _slug(String s) =>
    s.toLowerCase().replaceAll(RegExp(r"[^a-z0-9]+"), '');

String _phoneFor(int seed) {
  final n = 550000000 + (seed * 137) % 49999999;
  final s = n.toString().padLeft(9, '0');
  return '+213 ${s.substring(0, 3)} ${s.substring(3, 5)} ${s.substring(5, 7)} ${s.substring(7, 9)}';
}

String _bioFor({
  required String firstName,
  required TalentCategory category,
  required String city,
  required String country,
  required int years,
  required List<String> skills,
}) {
  final frLabel = _categoryFrLabel[category] ?? 'Artiste';
  final enLabel = category.label;
  final skill1 = skills.isNotEmpty ? skills[0] : 'Acting';
  final skill2 = skills.length > 1 ? skills[1] : 'Improvisation';
  return '$frLabel passionné(e) basé(e) à $city, $firstName cumule $years ans '
      "d'expérience dans le cinéma, la télévision et la publicité à travers "
      '$country. Spécialisé(e) en $skill1 et $skill2, $firstName a participé '
      'à plusieurs productions régionales et internationales et continue de '
      'se perfectionner à travers des formations continues.\n\n'
      'Passionate $enLabel based in $city, $firstName brings $years years of '
      'experience in film, television and advertising across $country. '
      'Specialized in $skill1 and $skill2, $firstName has taken part in '
      'several regional and international productions and keeps sharpening '
      'the craft through continuous training.';
}

// ---------------------------------------------------------------------------
// Casting seed data — 20 hand-written casting calls covering every project
// type (film, TV, commercial, theater, voice, fashion, music video).
// ---------------------------------------------------------------------------

class _CastingSeed {
  final String title;
  final String descriptionFr;
  final String descriptionEn;
  final String role;
  final TalentCategory category;
  final CastingType type;
  final int cityIndex;
  final Gender? gender;
  final int ageMin;
  final int ageMax;
  final List<String> requirements;
  final List<String> skills;
  final ExperienceLevel experienceLevel;
  final double salary;
  final String currency;
  final CastingStatus status;
  final int deadlineDays;
  final int shootStartDays;
  final int shootEndDays;
  final bool isFeatured;
  final bool isUrgent;
  final bool hasAgency;
  final String? imageUrl;

  const _CastingSeed({
    required this.title,
    required this.descriptionFr,
    required this.descriptionEn,
    required this.role,
    required this.category,
    required this.type,
    required this.cityIndex,
    this.gender,
    required this.ageMin,
    required this.ageMax,
    required this.requirements,
    required this.skills,
    required this.experienceLevel,
    required this.salary,
    required this.currency,
    required this.status,
    required this.deadlineDays,
    required this.shootStartDays,
    required this.shootEndDays,
    this.isFeatured = false,
    this.isUrgent = false,
    this.hasAgency = false,
    this.imageUrl,
  });
}

const List<_CastingSeed> _castingSeeds = [
  _CastingSeed(
    title: 'Sable et Silence — Rôle Principal Féminin',
    descriptionFr:
        "Long métrage dramatique en préparation à Alger. Nous recherchons une actrice principale capable de porter un récit intense sur la mémoire et la résilience familiale.",
    descriptionEn:
        'Feature drama in pre-production in Algiers. Seeking a lead actress able to carry an intense story about memory and family resilience.',
    role: 'Rôle principal féminin',
    category: TalentCategory.actress,
    type: CastingType.film,
    cityIndex: 0,
    gender: Gender.female,
    ageMin: 25,
    ageMax: 35,
    requirements: ['Expérience en tournage long métrage', 'Disponible 6 semaines'],
    skills: ['Acting', 'Drama', 'Arabic'],
    experienceLevel: ExperienceLevel.professional,
    salary: 350000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 21,
    shootStartDays: 60,
    shootEndDays: 100,
    isFeatured: true,
    imageUrl:
        'https://images.unsplash.com/photo-1485846234645-a62644f84781?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Les Ombres de la Casbah — Rôle Principal Masculin',
    descriptionFr:
        "Long métrage policier tourné dans la Casbah d'Alger. Recherche un acteur principal charismatique, à l'aise dans les scènes d'action légères.",
    descriptionEn:
        "Crime feature shot in Algiers' Casbah. Looking for a charismatic lead actor comfortable with light action sequences.",
    role: 'Rôle principal masculin',
    category: TalentCategory.actor,
    type: CastingType.film,
    cityIndex: 0,
    gender: Gender.male,
    ageMin: 28,
    ageMax: 45,
    requirements: ['Casting en présentiel à Alger', 'Permis de conduire'],
    skills: ['Acting', 'Stunt Work', 'Arabic'],
    experienceLevel: ExperienceLevel.professional,
    salary: 380000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 18,
    shootStartDays: 55,
    shootEndDays: 95,
    imageUrl:
        'https://images.unsplash.com/photo-1536440136628-849c177e76a1?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Dar El Bacha — Saison 2, Rôle Récurrent',
    descriptionFr:
        "Série télévisée à succès diffusée en prime time. Nous cherchons un comédien pour un rôle récurrent sur 12 épisodes.",
    descriptionEn:
        'Hit prime-time TV series. Looking for an actor for a recurring role across 12 episodes.',
    role: 'Rôle récurrent',
    category: TalentCategory.actor,
    type: CastingType.tv,
    cityIndex: 0,
    ageMin: 30,
    ageMax: 50,
    requirements: ['Disponible tous les week-ends', 'Expérience télévision'],
    skills: ['Acting', 'Comedy', 'Arabic'],
    experienceLevel: ExperienceLevel.intermediate,
    salary: 120000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 10,
    shootStartDays: 40,
    shootEndDays: 160,
    isFeatured: true,
    imageUrl: 'assets/images/castings/family_drama.png',
  ),
  _CastingSeed(
    title: 'Nour — Rôle Principal Féminin (Telenovela)',
    descriptionFr:
        "Telenovela quotidienne tournée à Oran. Recherche une actrice principale pour incarner une héroïne moderne sur toute une saison.",
    descriptionEn:
        'Daily telenovela shot in Oran. Seeking a lead actress to play a modern heroine for a full season.',
    role: 'Rôle principal féminin',
    category: TalentCategory.actress,
    type: CastingType.tv,
    cityIndex: 1,
    gender: Gender.female,
    ageMin: 22,
    ageMax: 32,
    requirements: ['Disponibilité longue durée (6 mois)', 'Résidence à Oran'],
    skills: ['Drama', 'Arabic', 'French'],
    experienceLevel: ExperienceLevel.professional,
    salary: 200000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 25,
    shootStartDays: 30,
    shootEndDays: 210,
    isFeatured: true,
    imageUrl:
        'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Djezzy Mobile — Spot Publicitaire',
    descriptionFr:
        "Publicité nationale pour un opérateur télécom. Recherche des visages frais et souriants pour un tournage d'une journée.",
    descriptionEn:
        'National ad for a telecom operator. Looking for fresh, smiling faces for a one-day shoot.',
    role: 'Talent publicitaire',
    category: TalentCategory.model,
    type: CastingType.commercial,
    cityIndex: 0,
    ageMin: 18,
    ageMax: 40,
    requirements: ['Casting photo requis', 'Disponible en semaine'],
    skills: ['Modeling Poses', 'Public Speaking'],
    experienceLevel: ExperienceLevel.beginner,
    salary: 60000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 7,
    shootStartDays: 5,
    shootEndDays: 6,
    isUrgent: true,
    imageUrl:
        'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Ifri — Campagne Boisson Rafraîchissante',
    descriptionFr:
        "Spot publicitaire estival pour une marque de boisson locale. Ambiance jeune et dynamique recherchée.",
    descriptionEn:
        'Summer commercial for a local beverage brand. Looking for a young, dynamic vibe.',
    role: 'Talent publicitaire',
    category: TalentCategory.model,
    type: CastingType.commercial,
    cityIndex: 1,
    ageMin: 18,
    ageMax: 30,
    requirements: ['Casting vidéo requis'],
    skills: ['Modeling Poses', 'Comedy'],
    experienceLevel: ExperienceLevel.beginner,
    salary: 45000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 9,
    shootStartDays: 10,
    shootEndDays: 11,
    imageUrl:
        'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: "Festival de Théâtre d'Alger — Troupe Principale",
    descriptionFr:
        "Pièce contemporaine présentée au festival national. Recherche des comédiens de théâtre expérimentés pour une tournée de deux mois.",
    descriptionEn:
        'Contemporary play for the national festival. Looking for experienced stage actors for a two-month tour.',
    role: 'Comédien(ne) de théâtre',
    category: TalentCategory.actor,
    type: CastingType.theater,
    cityIndex: 0,
    ageMin: 20,
    ageMax: 50,
    requirements: ['Expérience scénique obligatoire', 'Disponible pour tournée'],
    skills: ['Acting', 'Stage Combat', 'Public Speaking'],
    experienceLevel: ExperienceLevel.intermediate,
    salary: 30000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 30,
    shootStartDays: 45,
    shootEndDays: 75,
    imageUrl:
        'https://images.unsplash.com/photo-1503095396549-807759245b35?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Pièce Kabyle Traditionnelle — Béjaïa',
    descriptionFr:
        "Adaptation théâtrale d'un conte kabyle traditionnel. Recherche des comédiens parlant couramment le kabyle.",
    descriptionEn:
        'Stage adaptation of a traditional Kabyle tale. Looking for actors fluent in Kabyle.',
    role: 'Comédien(ne)',
    category: TalentCategory.actor,
    type: CastingType.theater,
    cityIndex: 5,
    ageMin: 25,
    ageMax: 55,
    requirements: ['Kabyle courant', 'Disponible les soirs'],
    skills: ['Acting', 'Public Speaking'],
    experienceLevel: ExperienceLevel.intermediate,
    salary: 28000,
    currency: 'DZD',
    status: CastingStatus.draft,
    deadlineDays: 40,
    shootStartDays: 80,
    shootEndDays: 110,
    imageUrl:
        'https://images.unsplash.com/photo-1507676184212-d03ab07a01bf?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: "Documentaire Terre d'Algérie — Voix Off",
    descriptionFr:
        "Documentaire nature et patrimoine. Recherche une voix off chaleureuse et posée en arabe et en français.",
    descriptionEn:
        'Nature and heritage documentary. Looking for a warm, composed voice-over artist in Arabic and French.',
    role: 'Voix off',
    category: TalentCategory.voiceActor,
    type: CastingType.voiceOver,
    cityIndex: 0,
    ageMin: 25,
    ageMax: 60,
    requirements: ['Home studio ou accès studio', 'Bande démo requise'],
    skills: ['Voice Modulation', 'Arabic', 'French'],
    experienceLevel: ExperienceLevel.professional,
    salary: 25000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 12,
    shootStartDays: 20,
    shootEndDays: 22,
    imageUrl:
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Série Animée — Doublage Français, Paris',
    descriptionFr:
        "Doublage français d'une série animée internationale. Recherche des comédiens voix polyvalents.",
    descriptionEn:
        'French dub for an international animated series. Looking for versatile voice actors.',
    role: 'Comédien(ne) voix off',
    category: TalentCategory.voiceActor,
    type: CastingType.voiceOver,
    cityIndex: 7,
    ageMin: 18,
    ageMax: 45,
    requirements: ['Studio à Paris', 'Direction artistique fournie'],
    skills: ['Voice Modulation', 'French', 'English'],
    experienceLevel: ExperienceLevel.intermediate,
    salary: 1500,
    currency: 'EUR',
    status: CastingStatus.open,
    deadlineDays: 15,
    shootStartDays: 30,
    shootEndDays: 60,
    imageUrl:
        'https://images.unsplash.com/photo-1598488035139-bdbb2231ce04?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Algiers Fashion Week — Défilé Principal',
    descriptionFr:
        "Défilé phare de la Fashion Week d'Alger. Recherche des mannequins féminins pour présenter des collections de créateurs algériens.",
    descriptionEn:
        "Flagship runway show of Algiers Fashion Week. Looking for female models to present Algerian designer collections.",
    role: 'Mannequin défilé',
    category: TalentCategory.model,
    type: CastingType.fashion,
    cityIndex: 0,
    gender: Gender.female,
    ageMin: 18,
    ageMax: 28,
    requirements: ['Book photo à jour', 'Essayage obligatoire'],
    skills: ['Modeling Poses'],
    experienceLevel: ExperienceLevel.intermediate,
    salary: 40000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 14,
    shootStartDays: 35,
    shootEndDays: 36,
    isFeatured: true,
    hasAgency: true,
    imageUrl: 'assets/images/castings/fashion_week.png',
  ),
  _CastingSeed(
    title: 'Hiba Couture — Campagne Photo',
    descriptionFr:
        "Campagne photo pour une maison de haute couture algérienne. Tournage terminé, poste pourvu.",
    descriptionEn:
        'Photo campaign for an Algerian haute couture house. Shoot completed, position filled.',
    role: 'Mannequin',
    category: TalentCategory.model,
    type: CastingType.fashion,
    cityIndex: 1,
    gender: Gender.female,
    ageMin: 20,
    ageMax: 35,
    requirements: ['Book photo requis'],
    skills: ['Modeling Poses', 'Photography'],
    experienceLevel: ExperienceLevel.intermediate,
    salary: 55000,
    currency: 'DZD',
    status: CastingStatus.closed,
    deadlineDays: -5,
    shootStartDays: -20,
    shootEndDays: -18,
    imageUrl:
        'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Le Dernier Tramway — Court Métrage',
    descriptionFr:
        "Court métrage étudiant sélectionné en festival. Recherche une jeune actrice pour le rôle principal.",
    descriptionEn:
        'Award-selected student short film. Looking for a young actress for the lead role.',
    role: 'Rôle principal',
    category: TalentCategory.actress,
    type: CastingType.film,
    cityIndex: 2,
    gender: Gender.female,
    ageMin: 18,
    ageMax: 25,
    requirements: ['Disponible un week-end complet'],
    skills: ['Acting', 'Drama'],
    experienceLevel: ExperienceLevel.beginner,
    salary: 15000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 20,
    shootStartDays: 50,
    shootEndDays: 55,
    imageUrl:
        'https://images.unsplash.com/photo-1485846234645-a62644f84781?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Co-production Internationale — Figuration',
    descriptionFr:
        "Long métrage en co-production internationale tourné à Annaba. Recherche de nombreux figurants pour des scènes de foule.",
    descriptionEn:
        'Internationally co-produced feature shot in Annaba. Looking for many extras for crowd scenes.',
    role: 'Figurant(e)',
    category: TalentCategory.extra,
    type: CastingType.film,
    cityIndex: 3,
    ageMin: 18,
    ageMax: 60,
    requirements: ['Disponible plusieurs jours consécutifs'],
    skills: ['Acting'],
    experienceLevel: ExperienceLevel.beginner,
    salary: 8000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 5,
    shootStartDays: 15,
    shootEndDays: 45,
    isUrgent: true,
    imageUrl:
        'https://images.unsplash.com/photo-1574267432553-4b4628081c31?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Nouvelle Star — Recherche de Danseurs',
    descriptionFr:
        "Émission de télé-crochet à la recherche de danseurs pour la troupe de scène permanente.",
    descriptionEn:
        'Talent TV show looking for dancers to join the permanent stage crew.',
    role: 'Danseur/Danseuse',
    category: TalentCategory.dancer,
    type: CastingType.tv,
    cityIndex: 0,
    ageMin: 16,
    ageMax: 30,
    requirements: ['Vidéo de démonstration requise'],
    skills: ['Dance', 'Hip-Hop Dance'],
    experienceLevel: ExperienceLevel.intermediate,
    salary: 0,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 8,
    shootStartDays: 25,
    shootEndDays: 29,
    imageUrl:
        'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'CPA Bank — Publicité Institutionnelle',
    descriptionFr:
        "Campagne institutionnelle pour une banque nationale. Casting terminé, rôle pourvu.",
    descriptionEn:
        'Institutional campaign for a national bank. Casting completed, role filled.',
    role: 'Talent publicitaire',
    category: TalentCategory.actor,
    type: CastingType.commercial,
    cityIndex: 0,
    ageMin: 30,
    ageMax: 55,
    requirements: ['Allure professionnelle'],
    skills: ['Acting', 'Public Speaking'],
    experienceLevel: ExperienceLevel.professional,
    salary: 90000,
    currency: 'DZD',
    status: CastingStatus.filled,
    deadlineDays: -3,
    shootStartDays: -10,
    shootEndDays: -9,
    imageUrl:
        'https://images.unsplash.com/photo-1560179707-f14e90ef3623?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Clip Raï — Danseuses Backup',
    descriptionFr:
        "Clip vidéo d'un artiste raï populaire tourné à Oran. Recherche des danseuses pour la chorégraphie principale.",
    descriptionEn:
        'Music video for a popular raï artist shot in Oran. Looking for backup dancers for the main choreography.',
    role: 'Danseuse',
    category: TalentCategory.dancer,
    type: CastingType.musicVideo,
    cityIndex: 1,
    gender: Gender.female,
    ageMin: 18,
    ageMax: 28,
    requirements: ['Chorégraphie fournie en amont'],
    skills: ['Dance', 'Hip-Hop Dance', 'Classical Ballet'],
    experienceLevel: ExperienceLevel.intermediate,
    salary: 35000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 6,
    shootStartDays: 12,
    shootEndDays: 13,
    isUrgent: true,
    imageUrl:
        'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
  _CastingSeed(
    title: 'Bride Photography — Collection Printemps',
    descriptionFr:
        "Séance photo pour une collection de robes de mariée à Tlemcen.",
    descriptionEn:
        'Photo shoot for a bridal dress collection in Tlemcen.',
    role: 'Mannequin',
    category: TalentCategory.model,
    type: CastingType.fashion,
    cityIndex: 4,
    gender: Gender.female,
    ageMin: 20,
    ageMax: 32,
    requirements: ['Essayage à Tlemcen'],
    skills: ['Modeling Poses'],
    experienceLevel: ExperienceLevel.beginner,
    salary: 25000,
    currency: 'DZD',
    status: CastingStatus.open,
    deadlineDays: 20,
    shootStartDays: 35,
    shootEndDays: 36,
    isFeatured: true,
    imageUrl: 'assets/images/castings/bride_photography.png',
  ),
  _CastingSeed(
    title: 'Action Movie — Cascadeurs & Figuration, Dubai',
    descriptionFr:
        "Production internationale à gros budget tournée à Dubai. Recherche des figurants et cascadeurs formés aux arts martiaux.",
    descriptionEn:
        'Big-budget international action production shot in Dubai. Looking for extras and stunt performers trained in martial arts.',
    role: 'Cascadeur / Figurant',
    category: TalentCategory.extra,
    type: CastingType.film,
    cityIndex: 11,
    ageMin: 20,
    ageMax: 45,
    requirements: ['Formation cascade', 'Visa de travail EAU'],
    skills: ['Martial Arts', 'Stunt Work'],
    experienceLevel: ExperienceLevel.professional,
    salary: 500,
    currency: 'USD',
    status: CastingStatus.open,
    deadlineDays: 28,
    shootStartDays: 70,
    shootEndDays: 100,
    isFeatured: true,
    hasAgency: true,
    imageUrl: 'assets/images/castings/action_movie.png',
  ),
  _CastingSeed(
    title: 'Podcast de Marque — Voix & Présentation, Le Caire',
    descriptionFr:
        "Podcast sponsorisé destiné aux jeunes entrepreneurs. Campagne archivée après clôture du budget.",
    descriptionEn:
        'Sponsored podcast aimed at young entrepreneurs. Campaign archived after budget closure.',
    role: 'Présentateur/Présentatrice',
    category: TalentCategory.contentCreator,
    type: CastingType.voiceOver,
    cityIndex: 12,
    ageMin: 20,
    ageMax: 40,
    requirements: ['Matériel d\'enregistrement personnel'],
    skills: ['Public Speaking', 'English', 'Video Editing'],
    experienceLevel: ExperienceLevel.intermediate,
    salary: 8000,
    currency: 'EGP',
    status: CastingStatus.archived,
    deadlineDays: -60,
    shootStartDays: -80,
    shootEndDays: -70,
    imageUrl:
        'https://images.unsplash.com/photo-1478737270239-2f02b77fc618?auto=format&fit=crop&w=1200&h=800&q=80',
  ),
];

// ---------------------------------------------------------------------------
// MockData — the single source of truth for every demo record in the app.
// ---------------------------------------------------------------------------

class MockData {
  MockData._();

  static bool _initialized = false;

  static final DateTime now = DateTime(2026, 7, 27, 22, 58);

  static const String demoTalentUserId = 'user-demo-talent';
  static const String demoRecruiterUserId = 'user-demo-recruiter';
  static const String demoAdminUserId = 'user-demo-admin';

  static final List<UserModel> users = [];
  static final List<TalentModel> talents = [];
  static final List<RecruiterModel> recruiters = [];
  static final List<AgencyModel> agencies = [];
  static final List<CastingModel> castings = [];
  static final List<ApplicationModel> applications = [];
  static final List<ConversationModel> conversations = [];
  static final List<MessageModel> messages = [];
  static final List<NotificationModel> notifications = [];
  static final List<ReviewModel> reviews = [];
  static final List<FavoriteModel> favorites = [];
  static final List<SavedSearchModel> savedSearches = [];
  static final List<ReportModel> reports = [];

  /// Builds every mock list. Safe to call multiple times — only runs once
  /// unless [reset] is called first.
  static void init() {
    if (_initialized) return;
    _initialized = true;

    users.clear();
    talents.clear();
    recruiters.clear();
    agencies.clear();
    castings.clear();
    applications.clear();
    conversations.clear();
    messages.clear();
    notifications.clear();
    reviews.clear();
    favorites.clear();
    savedSearches.clear();
    reports.clear();

    _buildAgencies();
    _buildTalents();
    _buildRecruiters();
    _buildAdmins();
    _buildCastings();
    _buildApplications();
    _buildConversationsAndMessages();
    _buildNotifications();
    _buildReviews();
    _buildFavorites();
    _buildSavedSearches();
    _buildReports();
    _recomputeAgencyTalentCounts();
  }

  /// Rebuilds all mock data from scratch.
  static void reset() {
    _initialized = false;
    init();
  }

  // ---------------------------------------------------------------------
  // Lookups
  // ---------------------------------------------------------------------

  static UserModel? userById(String id) =>
      users.firstWhereOrNull((u) => u.id == id);

  static UserModel? login(String email, String password) =>
      users.firstWhereOrNull(
        (u) =>
            u.email.toLowerCase() == email.toLowerCase() &&
            u.password == password,
      );

  static TalentModel? talentById(String id) =>
      talents.firstWhereOrNull((t) => t.id == id);

  static TalentModel? talentByUserId(String userId) =>
      talents.firstWhereOrNull((t) => t.userId == userId);

  static RecruiterModel? recruiterById(String id) =>
      recruiters.firstWhereOrNull((r) => r.id == id);

  static RecruiterModel? recruiterByUserId(String userId) =>
      recruiters.firstWhereOrNull((r) => r.userId == userId);

  static AgencyModel? agencyById(String id) =>
      agencies.firstWhereOrNull((a) => a.id == id);

  static CastingModel? castingById(String id) =>
      castings.firstWhereOrNull((c) => c.id == id);

  static List<ApplicationModel> applicationsForTalent(String talentId) =>
      applications.where((a) => a.talentId == talentId).toList();

  static List<ApplicationModel> applicationsForCasting(String castingId) =>
      applications.where((a) => a.castingId == castingId).toList();

  static List<CastingModel> castingsForRecruiter(String recruiterId) =>
      castings.where((c) => c.recruiterId == recruiterId).toList();

  static List<TalentModel> talentsForAgency(String agencyId) =>
      talents.where((t) => t.agencyId == agencyId).toList();

  static List<ConversationModel> conversationsForUser(String userId) =>
      conversations.where((c) => c.participantIds.contains(userId)).toList();

  static List<MessageModel> messagesForConversation(String conversationId) =>
      messages.where((m) => m.conversationId == conversationId).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  static List<NotificationModel> notificationsForUser(String userId) =>
      notifications.where((n) => n.userId == userId).toList();

  static List<ReviewModel> reviewsForTalent(String talentId) =>
      reviews.where((r) => r.talentId == talentId).toList();

  static List<FavoriteModel> favoritesForUser(String userId) =>
      favorites.where((f) => f.userId == userId).toList();

  static List<SavedSearchModel> savedSearchesForUser(String userId) =>
      savedSearches.where((s) => s.userId == userId).toList();

  // ---------------------------------------------------------------------
  // Agencies
  // ---------------------------------------------------------------------

  static void _buildAgencies() {
    for (var i = 0; i < _agencyNames.length; i++) {
      final city = _cities[i % _cities.length];
      final id = _id('agency', i + 1);
      final specialties = _agencySpecialtyPool[i % _agencySpecialtyPool.length];
      final name = _agencyNames[i];
      agencies.add(AgencyModel(
        id: id,
        name: name,
        logoUrl: squareUrl('$id-logo'),
        coverUrl: agencyCoverUrl('$id-cover'),
        description:
            "$name accompagne des talents émergents et confirmés à travers l'Algérie et la région MENA, avec un réseau de partenaires dans le cinéma, la télévision et la mode.\n\n"
            '$name supports emerging and established talents across Algeria and the MENA region, with a partner network spanning film, television and fashion.',
        city: city.city,
        country: city.country,
        website: 'https://www.${_slug(name)}.com',
        talentCount: 0,
        isVerified: i % 3 != 0,
        specialties: specialties,
        rating: double.parse((3.8 + (i % 5) * 0.24).toStringAsFixed(1)),
        createdAt: now.subtract(Duration(days: 900 - i * 20)),
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Talents (+ their linked UserModel accounts)
  // ---------------------------------------------------------------------

  static void _buildTalents() {
    var index = 0;
    for (var i = 0; i < _femaleFirstNames.length; i++) {
      _addTalent(
        index: index++,
        firstName: _femaleFirstNames[i],
        lastName: _lastNames[i],
        gender: Gender.female,
      );
    }
    for (var i = 0; i < _maleFirstNames.length; i++) {
      _addTalent(
        index: index++,
        firstName: _maleFirstNames[i],
        lastName: _lastNames[(i + 7) % _lastNames.length],
        gender: Gender.male,
      );
    }
  }

  static void _addTalent({
    required int index,
    required String firstName,
    required String lastName,
    required Gender gender,
  }) {
    final n = index + 1;
    final id = _id('talent', n);
    final isDemo = index == 0;
    final userId = isDemo ? demoTalentUserId : 'user-$id';
    final rnd = Random(2000 + index);
    final cityInfo = _cities[index % _cities.length];
    final category = gender == Gender.female
        ? _femaleCategories[index % _femaleCategories.length]
        : _maleCategories[index % _maleCategories.length];
    final experienceLevel =
        ExperienceLevel.values[index % ExperienceLevel.values.length];
    final baseYears = switch (experienceLevel) {
      ExperienceLevel.beginner => rnd.nextInt(2),
      ExperienceLevel.intermediate => 2 + rnd.nextInt(4),
      ExperienceLevel.professional => 6 + rnd.nextInt(9),
      ExperienceLevel.celebrity => 12 + rnd.nextInt(13),
    };
    final age = 19 + rnd.nextInt(30);
    final dateOfBirth =
        DateTime(now.year - age, 1 + rnd.nextInt(12), 1 + rnd.nextInt(28));
    final heightCm = (gender == Gender.female ? 158 : 170) + rnd.nextInt(20);
    final weightKg = (gender == Gender.female ? 48 : 65) + rnd.nextInt(22);
    final skillSet = <String>{};
    for (var j = 0; j < 5; j++) {
      skillSet.add(_skillsPool[(index * 3 + j * 5) % _skillsPool.length]);
    }
    final skillList = skillSet.toList();
    final languages = <String>{'Arabic', 'French'};
    if (index % 2 == 0) languages.add('English');
    if (index % 5 == 0) languages.add('Kabyle');
    if (index % 7 == 0) languages.add('Spanish');
    final bio = _bioFor(
      firstName: firstName,
      category: category,
      city: cityInfo.city,
      country: cityInfo.country,
      years: baseYears,
      skills: skillList,
    );
    final experience = List.generate(2 + (index % 2), (j) {
      final credit = _creditPool[(index + j) % _creditPool.length];
      return ExperienceEntry(
        title: credit['title']!,
        role: credit['role']!,
        year: now.year - 1 - ((index + j) % 6),
      );
    });
    final email = isDemo
        ? 'talent@kastrolz.com'
        : '${firstName.toLowerCase()}.${_slug(lastName)}$n@example.com';
    final isFemale = gender == Gender.female;
    final headshot = portraitUrl(id, female: isFemale);
    final cover = coverUrl('$id-cover');
    final gallery = List.generate(4, (j) => portraitUrl('$id-g$j', female: isFemale));
    final videoThumbs = List.generate(2, (j) => coverUrl('$id-v$j'));
    final portfolio = List.generate(3, (j) => squareUrl('$id-p$j'));
    final isVerified = isDemo || index % 3 != 0;
    final isFeatured = isDemo || index < 8 || index % 6 == 0;
    final isArchived = index == 38 || index == 39;
    final agencyId =
        index % 3 == 0 ? agencies[index % agencies.length].id : null;
    final rating = double.parse(
      (3.4 + rnd.nextDouble() * 1.6).clamp(3.0, 5.0).toStringAsFixed(1),
    );
    final createdAt = now.subtract(Duration(days: 30 + index * 6));
    final updatedAt = now.subtract(Duration(days: index));
    final phone = _phoneFor(index + 1);

    talents.add(TalentModel(
      id: id,
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      category: category,
      gender: gender,
      age: age,
      dateOfBirth: dateOfBirth,
      heightCm: heightCm.toDouble(),
      weightKg: weightKg.toDouble(),
      eyeColor: _eyeColors[index % _eyeColors.length],
      hairColor: _hairColors[index % _hairColors.length],
      city: cityInfo.city,
      country: cityInfo.country,
      nationality: cityInfo.nationality,
      languages: languages.toList(),
      skills: skillList,
      experienceLevel: experienceLevel,
      yearsOfExperience: baseYears,
      biography: bio,
      headshotUrl: headshot,
      coverUrl: cover,
      portfolioUrls: portfolio,
      galleryUrls: gallery,
      videoThumbnails: videoThumbs,
      socialLinks: {
        'instagram': '@${firstName.toLowerCase()}${_slug(lastName)}',
        'tiktok': '@${firstName.toLowerCase()}_official',
      },
      availability:
          AvailabilityStatus.values[index % AvailabilityStatus.values.length],
      rating: rating,
      reviewCount: 3 + rnd.nextInt(90),
      viewCount: 80 + rnd.nextInt(6000),
      isVerified: isVerified,
      isFeatured: isFeatured,
      isArchived: isArchived,
      agencyId: agencyId,
      education: _educationPool[index % _educationPool.length],
      experience: experience,
      createdAt: createdAt,
      updatedAt: updatedAt,
    ));

    users.add(UserModel(
      id: userId,
      email: email,
      password: 'demo123',
      firstName: firstName,
      lastName: lastName,
      role: UserRole.talent,
      avatarUrl: headshot,
      coverUrl: cover,
      phone: phone,
      isVerified: isVerified,
      isPremium: isDemo || index % 4 == 0,
      status: isArchived ? UserStatus.suspended : UserStatus.active,
      createdAt: createdAt,
      lastSeen: now.subtract(Duration(hours: index % 48)),
      bio: bio,
    ));
  }

  // ---------------------------------------------------------------------
  // Recruiters (+ their linked UserModel accounts)
  // ---------------------------------------------------------------------

  static void _buildRecruiters() {
    for (var i = 0; i < _companyNames.length; i++) {
      final n = i + 1;
      final id = _id('recruiter', n);
      final isDemo = i == 0;
      final userId = isDemo ? demoRecruiterUserId : 'user-$id';
      final cityInfo = _cities[(i * 2) % _cities.length];
      final companyType = CompanyType.values[i % CompanyType.values.length];
      final contactFirst = i.isEven
          ? _maleFirstNames[(i + 4) % _maleFirstNames.length]
          : _femaleFirstNames[(i + 4) % _femaleFirstNames.length];
      final contactLast = _lastNames[(i + 3) % _lastNames.length];
      final companyName = _companyNames[i];
      final email =
          isDemo ? 'recruiter@kastrolz.com' : 'contact@${_slug(companyName)}.com';
      final logo = squareUrl('$id-logo');
      final cover = coverUrl('$id-cover');
      final avatar = portraitUrl('$id-avatar');
      final isVerified = isDemo || i % 3 != 0;
      final castingCount = 1 + (i % 6);
      final hireCount = i * 3 + 2;
      final rating = double.parse(
        (3.6 + (i % 5) * 0.28).clamp(3.0, 5.0).toStringAsFixed(1),
      );
      final createdAt = now.subtract(Duration(days: 700 - i * 25));
      final phone = _phoneFor(500 + i);

      recruiters.add(RecruiterModel(
        id: id,
        userId: userId,
        firstName: contactFirst,
        lastName: contactLast,
        email: email,
        phone: phone,
        avatarUrl: avatar,
        companyName: companyName,
        companyLogo: logo,
        companyCover: cover,
        companyType: companyType,
        city: cityInfo.city,
        country: cityInfo.country,
        bio:
            "$companyName est spécialisée en ${companyType.label.toLowerCase()}, basée à ${cityInfo.city}. Nous recherchons régulièrement des talents pour des productions cinéma, TV et publicité.\n\n"
            '$companyName is a ${companyType.label.toLowerCase()} based in ${cityInfo.city}, regularly scouting talents for film, TV and advertising productions.',
        website: 'https://www.${_slug(companyName)}.com',
        isVerified: isVerified,
        castingCount: castingCount,
        hireCount: hireCount,
        rating: rating,
        createdAt: createdAt,
      ));

      users.add(UserModel(
        id: userId,
        email: email,
        password: 'demo123',
        firstName: contactFirst,
        lastName: contactLast,
        role: UserRole.recruiter,
        avatarUrl: avatar,
        coverUrl: cover,
        phone: phone,
        isVerified: isVerified,
        isPremium: isDemo || i % 4 == 0,
        status: UserStatus.active,
        createdAt: createdAt,
        lastSeen: now.subtract(Duration(hours: i % 36)),
        bio: 'Recruiting talents for $companyName.',
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Admins
  // ---------------------------------------------------------------------

  static void _buildAdmins() {
    final admins = <(String, String, String, String)>[
      (demoAdminUserId, 'admin@kastrolz.com', 'Yacine', 'Kerrouche'),
      ('user-admin-002', 'sofia.rahal@kastrolz.com', 'Sofia', 'Rahal'),
      ('user-admin-003', 'idriss.bencheikh@kastrolz.com', 'Idriss', 'Bencheikh'),
    ];
    for (var i = 0; i < admins.length; i++) {
      final (userId, email, first, last) = admins[i];
      users.add(UserModel(
        id: userId,
        email: email,
        password: 'demo123',
        firstName: first,
        lastName: last,
        role: UserRole.admin,
        avatarUrl: portraitUrl('$userId-avatar'),
        coverUrl: coverUrl('$userId-cover'),
        phone: _phoneFor(900 + i),
        isVerified: true,
        isPremium: true,
        status: UserStatus.active,
        createdAt: now.subtract(Duration(days: 1200 - i * 40)),
        lastSeen: now.subtract(Duration(minutes: i * 30)),
        bio: 'KAST-ROLZ platform administrator.',
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Castings
  // ---------------------------------------------------------------------

  static void _buildCastings() {
    for (var i = 0; i < _castingSeeds.length; i++) {
      final seed = _castingSeeds[i];
      final id = _id('casting', i + 1);
      final cityInfo = _cities[seed.cityIndex % _cities.length];
      final recruiter = recruiters[i % recruiters.length];
      final agencyId =
          seed.hasAgency ? agencies[i % agencies.length].id : null;
      castings.add(CastingModel(
        id: id,
        title: seed.title,
        description: '${seed.descriptionFr}\n\n${seed.descriptionEn}',
        role: seed.role,
        category: seed.category,
        type: seed.type,
        bannerUrl: seed.imageUrl ?? coverUrl('$id-banner'),
        thumbnailUrl: seed.imageUrl ?? squareUrl('$id-thumb'),
        recruiterId: recruiter.id,
        agencyId: agencyId,
        location: '${cityInfo.city}, ${cityInfo.country}',
        city: cityInfo.city,
        country: cityInfo.country,
        salary: seed.salary,
        currency: seed.currency,
        gender: seed.gender,
        ageMin: seed.ageMin,
        ageMax: seed.ageMax,
        heightMin: seed.category == TalentCategory.model ? 165 : null,
        heightMax: seed.category == TalentCategory.model ? 185 : null,
        requirements: seed.requirements,
        skills: seed.skills,
        languages: const ['Arabic', 'French'],
        experienceLevel: seed.experienceLevel,
        status: seed.status,
        isFeatured: seed.isFeatured,
        isUrgent: seed.isUrgent,
        isArchived: seed.status == CastingStatus.archived,
        applicationDeadline: now.add(Duration(days: seed.deadlineDays)),
        shootStartDate: now.add(Duration(days: seed.shootStartDays)),
        shootEndDate: now.add(Duration(days: seed.shootEndDays)),
        applicantCount: 4 + (i * 5) % 60,
        viewCount: 120 + (i * 73) % 3000,
        createdAt: now.subtract(Duration(days: 20 + i * 4)),
        updatedAt: now.subtract(Duration(days: i)),
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Applications
  // ---------------------------------------------------------------------

  static void _buildApplications() {
    const coverLetters = [
      "Bonjour, je suis très intéressé(e) par ce rôle et je pense correspondre parfaitement au profil recherché.\n\nHello, I'm very interested in this role and believe I closely match the profile you're looking for.",
      'Passionné(e) par ce type de projet, je serais ravi(e) de mettre mon expérience à votre service.\n\nPassionate about this kind of project, I would be thrilled to bring my experience to your production.',
      'Je vous joins mon book et reste disponible pour un essai à votre convenance.\n\nPlease find my portfolio attached, I remain available for an audition at your convenience.',
      'Ce casting correspond exactement à mes compétences et à ma disponibilité actuelle.\n\nThis casting matches exactly my skill set and current availability.',
    ];
    for (var i = 0; i < 30; i++) {
      final talent = talents[(i * 3 + 2) % talents.length];
      final casting = castings[(i * 2 + 1) % castings.length];
      final status = ApplicationStatus.values[i % ApplicationStatus.values.length];
      final createdAt = casting.createdAt.add(Duration(days: 1 + i % 6));
      applications.add(ApplicationModel(
        id: _id('application', i + 1),
        castingId: casting.id,
        talentId: talent.id,
        recruiterId: casting.recruiterId,
        status: status,
        coverLetter: coverLetters[i % coverLetters.length],
        createdAt: createdAt,
        updatedAt: createdAt.add(Duration(days: i % 3)),
        notes: i % 4 == 0
            ? 'Rappelé(e) pour un second essai. / Called back for a second round.'
            : '',
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Conversations & Messages
  // ---------------------------------------------------------------------

  static const List<String> _recruiterChatLines = [
    'Bonjour, nous avons été impressionnés par votre profil pour le casting.',
    'Seriez-vous disponible pour un essai la semaine prochaine ?',
    'Merci de nous envoyer une bande démo récente si possible.',
    'Félicitations, vous êtes retenu(e) pour la prochaine étape !',
    'Nous revenons vers vous très bientôt avec plus de détails.',
  ];

  static const List<String> _talentChatLines = [
    'Bonjour, merci beaucoup pour votre message !',
    'Oui, je suis disponible toute la semaine prochaine.',
    "Je vous envoie ma bande démo dès aujourd'hui.",
    "Merci infiniment, c'est une excellente nouvelle !",
    'Avec plaisir, je reste disponible pour toute information complémentaire.',
  ];

  static void _buildConversationsAndMessages() {
    var messageIndex = 0;
    for (var i = 0; i < 20; i++) {
      final talent = talents[i % talents.length];
      final recruiter = recruiters[i % recruiters.length];
      final convId = _id('conv', i + 1);
      final messageCount = i < 10 ? 3 : 2;
      final base = now.subtract(Duration(days: 25 - i, hours: i));
      final convMessages = <MessageModel>[];
      for (var m = 0; m < messageCount; m++) {
        messageIndex++;
        final isRecruiterTurn = m.isEven;
        final senderId = isRecruiterTurn ? recruiter.userId : talent.userId;
        final content = isRecruiterTurn
            ? _recruiterChatLines[m % _recruiterChatLines.length]
            : _talentChatLines[m % _talentChatLines.length];
        final createdAt = base.add(Duration(hours: m * 5));
        final msg = MessageModel(
          id: _id('msg', messageIndex),
          conversationId: convId,
          senderId: senderId,
          content: content,
          type: MessageType.text,
          isRead: m < messageCount - 1,
          createdAt: createdAt,
        );
        convMessages.add(msg);
        messages.add(msg);
      }
      final last = convMessages.last;
      conversations.add(ConversationModel(
        id: convId,
        participantIds: [talent.userId, recruiter.userId],
        lastMessage: last.content,
        lastMessageAt: last.createdAt,
        unreadCount: {
          talent.userId: i % 4,
          recruiter.userId: i % 3 == 0 ? 1 : 0,
        },
        isTyping: {
          talent.userId: i == 0,
          recruiter.userId: false,
        },
        updatedAt: last.createdAt,
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------

  static void _buildNotifications() {
    const templates = <(NotificationType, String, String)>[
      (NotificationType.like, 'Nouveau like', 'Un recruteur a aimé votre profil.'),
      (NotificationType.application, 'Nouvelle candidature', 'Un talent a postulé à votre casting.'),
      (NotificationType.acceptance, 'Candidature acceptée', 'Félicitations, votre candidature a été acceptée !'),
      (NotificationType.rejection, 'Candidature refusée', "Votre candidature n'a pas été retenue cette fois-ci."),
      (NotificationType.message, 'Nouveau message', 'Vous avez reçu un nouveau message.'),
      (NotificationType.reminder, 'Rappel', "N'oubliez pas de compléter votre profil."),
      (NotificationType.verification, 'Profil vérifié', 'Votre profil a été vérifié avec succès.'),
      (NotificationType.system, 'Mise à jour', 'De nouvelles fonctionnalités sont disponibles sur KAST-ROLZ.'),
    ];

    final recipients = <String>[
      demoTalentUserId,
      demoRecruiterUserId,
      demoAdminUserId,
      ...talents.take(6).map((t) => t.userId),
      ...recruiters.take(4).map((r) => r.userId),
    ];

    for (var i = 0; i < 15; i++) {
      final template = templates[i % templates.length];
      final userId = recipients[i % recipients.length];
      final relatedId = switch (template.$1) {
        NotificationType.application ||
        NotificationType.acceptance ||
        NotificationType.rejection =>
          applications.isNotEmpty
              ? applications[i % applications.length].id
              : null,
        NotificationType.message =>
          conversations.isNotEmpty
              ? conversations[i % conversations.length].id
              : null,
        NotificationType.like =>
          talents.isNotEmpty ? talents[i % talents.length].id : null,
        _ => null,
      };
      notifications.add(NotificationModel(
        id: _id('notif', i + 1),
        userId: userId,
        type: template.$1,
        title: template.$2,
        body: template.$3,
        isRead: i % 3 == 0,
        relatedId: relatedId,
        createdAt: now.subtract(Duration(hours: i * 7)),
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Reviews
  // ---------------------------------------------------------------------

  static void _buildReviews() {
    const comments = [
      'Un professionnalisme exemplaire sur le tournage, à recommander sans hésiter.\n\nExemplary professionalism on set, highly recommended.',
      "Talent ponctuel, impliqué et très à l'écoute des directives.\n\nPunctual, committed talent who listens closely to direction.",
      'Une performance remarquable, nous retravaillerons ensemble avec plaisir.\n\nA remarkable performance, we would gladly work together again.',
      "Très bonne alchimie avec l'équipe, un vrai atout pour le projet.\n\nGreat chemistry with the team, a real asset to the project.",
      'Sérieux, motivé(e) et créatif(ve), une collaboration très agréable.\n\nSerious, motivated and creative — a very pleasant collaboration.',
    ];
    for (var i = 0; i < 20; i++) {
      final talent = talents[i % talents.length];
      final recruiter = recruiters[i % recruiters.length];
      reviews.add(ReviewModel(
        id: _id('review', i + 1),
        talentId: talent.id,
        reviewerId: recruiter.userId,
        reviewerName: recruiter.companyName,
        rating: double.parse(
          (3.5 + (i % 4) * 0.5).clamp(3.0, 5.0).toStringAsFixed(1),
        ),
        comment: comments[i % comments.length],
        createdAt: now.subtract(Duration(days: 5 + i * 9)),
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Favorites
  // ---------------------------------------------------------------------

  static void _buildFavorites() {
    var n = 0;
    for (var i = 0; i < 12; i++) {
      n++;
      favorites.add(FavoriteModel(
        id: _id('fav', n),
        userId: recruiters[i % recruiters.length].userId,
        itemId: talents[(i * 3) % talents.length].id,
        itemType: FavoriteItemType.talent,
        createdAt: now.subtract(Duration(days: i * 2)),
      ));
    }
    for (var i = 0; i < 8; i++) {
      n++;
      favorites.add(FavoriteModel(
        id: _id('fav', n),
        userId: talents[(i * 5) % talents.length].userId,
        itemId: castings[(i * 2) % castings.length].id,
        itemType: FavoriteItemType.casting,
        createdAt: now.subtract(Duration(days: i * 3)),
      ));
    }
    for (var i = 0; i < 5; i++) {
      n++;
      favorites.add(FavoriteModel(
        id: _id('fav', n),
        userId: talents[(i * 7) % talents.length].userId,
        itemId: agencies[i % agencies.length].id,
        itemType: FavoriteItemType.agency,
        createdAt: now.subtract(Duration(days: i * 4)),
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Saved searches
  // ---------------------------------------------------------------------

  static void _buildSavedSearches() {
    final owners = <String>[
      demoRecruiterUserId,
      demoTalentUserId,
      ...recruiters.map((r) => r.userId),
    ];
    const namesAndFilters = <(String, Map<String, dynamic>)>[
      ('Actrices à Alger 18-25', {'category': 'actress', 'city': 'Algiers', 'ageMin': 18, 'ageMax': 25}),
      ('Mannequins femmes Oran', {'category': 'model', 'city': 'Oran', 'gender': 'female'}),
      ('Voix off bilingues', {'category': 'voiceActor', 'languages': ['Arabic', 'French']}),
      ('Danseurs professionnels', {'category': 'dancer', 'experienceLevel': 'professional'}),
      ('Figurants Alger', {'category': 'extra', 'city': 'Algiers'}),
      ('Acteurs 30-45 ans', {'category': 'actor', 'ageMin': 30, 'ageMax': 45}),
      ('Talents vérifiés uniquement', {'isVerified': true}),
      ('Castings publicité ouverts', {'type': 'commercial', 'status': 'open'}),
      ('Castings film urgents', {'type': 'film', 'isUrgent': true}),
      ('Musiciens Constantine', {'category': 'musician', 'city': 'Constantine'}),
    ];
    for (var i = 0; i < 20; i++) {
      final owner = owners[i % owners.length];
      final nf = namesAndFilters[i % namesAndFilters.length];
      savedSearches.add(SavedSearchModel(
        id: _id('search', i + 1),
        userId: owner,
        name: nf.$1,
        filters: nf.$2,
        createdAt: now.subtract(Duration(days: i * 4)),
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Reports
  // ---------------------------------------------------------------------

  static void _buildReports() {
    const reasons = [
      'Fausses informations dans le profil / Fake information in profile',
      'Contenu inapproprié / Inappropriate content',
      'Comportement suspect en message privé / Suspicious behaviour in DMs',
      'Casting frauduleux ou trompeur / Fraudulent or misleading casting',
      "Usurpation d'identité / Impersonation",
    ];
    final seeds = <(String, ReportTargetType)>[
      (talents[3].id, ReportTargetType.talent),
      (talents[11].id, ReportTargetType.talent),
      (castings[5].id, ReportTargetType.casting),
      (castings[13].id, ReportTargetType.casting),
      (recruiters[2].id, ReportTargetType.recruiter),
      (demoTalentUserId, ReportTargetType.user),
      (messages.isNotEmpty ? messages[4].id : 'msg-001', ReportTargetType.message),
      (reviews.isNotEmpty ? reviews[2].id : 'review-001', ReportTargetType.review),
    ];
    for (var i = 0; i < seeds.length; i++) {
      reports.add(ReportModel(
        id: _id('report', i + 1),
        reporterId: i.isEven
            ? recruiters[i % recruiters.length].userId
            : talents[i % talents.length].userId,
        targetId: seeds[i].$1,
        targetType: seeds[i].$2,
        reason: reasons[i % reasons.length],
        status: ReportStatus.values[i % ReportStatus.values.length],
        createdAt: now.subtract(Duration(days: i * 6)),
      ));
    }
  }

  // ---------------------------------------------------------------------
  // Post-processing
  // ---------------------------------------------------------------------

  static void _recomputeAgencyTalentCounts() {
    for (var i = 0; i < agencies.length; i++) {
      final agency = agencies[i];
      final count = talents.where((t) => t.agencyId == agency.id).length;
      agencies[i] = agency.copyWith(talentCount: count);
    }
  }
}
