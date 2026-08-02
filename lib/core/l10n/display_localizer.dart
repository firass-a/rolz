import '../l10n/locale_controller.dart';

/// Translates seeded English/French display values (skills, languages, places,
/// colors, casting copy) when Arabic is active. Keys are matched
/// case-insensitively where lowercase variants exist.
abstract final class DisplayLocalizer {
  static String t(String value) {
    if (!LocaleController.isArabic) return value;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;

    final direct = _map[trimmed] ?? _map[trimmed.toLowerCase()];
    if (direct != null) return direct;

    // Location labels like "Sétif, Algeria"
    if (trimmed.contains(',')) {
      final parts = trimmed.split(',').map((p) => p.trim()).toList();
      return parts.map(t).join('، ');
    }

    return trimmed;
  }

  static List<String> list(Iterable<String> values) => values.map(t).toList();

  /// For casting descriptions stored as "fr\n\nen", pick the right language.
  static String description(String raw) {
    final parts = raw
        .split(RegExp(r'\n\n+'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    if (!LocaleController.isArabic) {
      if (parts.length >= 2) return parts.last; // English
      return raw;
    }
    // Arabic: prefer translated English paragraph, else translate French, else t(raw)
    if (parts.length >= 2) {
      final en = parts.last;
      final ar = _map[en] ?? _map[en.trim()];
      if (ar != null) return ar;
    }
    if (parts.isNotEmpty) {
      final first = parts.first;
      return _map[first] ?? t(first);
    }
    return t(raw);
  }

  static const Map<String, String> _map = {
    // ── Languages ──────────────────────────────────────────────────────────
    'Arabic': 'العربية',
    'arabic': 'العربية',
    'French': 'الفرنسية',
    'french': 'الفرنسية',
    'English': 'الإنجليزية',
    'english': 'الإنجليزية',
    'Spanish': 'الإسبانية',
    'German': 'الألمانية',
    'Italian': 'الإيطالية',
    'Portuguese': 'البرتغالية',
    'Turkish': 'التركية',
    'Kabyle': 'القبائلية',
    'Berber': 'الأمازيغية',
    'Korean': 'الكورية',
    'Chinese': 'الصينية',
    'Japanese': 'اليابانية',
    'Russian': 'الروسية',
    'Hindi': 'الهندية',

    // ── Skills ─────────────────────────────────────────────────────────────
    'Acting': 'التمثيل',
    'Improvisation': 'الارتجال',
    'Dance': 'الرقص',
    'Singing': 'الغناء',
    'Martial Arts': 'الفنون القتالية',
    'Horse Riding': 'ركوب الخيل',
    'Horseback riding': 'ركوب الخيل',
    'Stunt Work': 'أعمال المخاطرة',
    'Comedy': 'الكوميديا',
    'Drama': 'الدراما',
    'Voice Modulation': 'تلوين الصوت',
    'Voice acting': 'التعليق الصوتي',
    'Classical Ballet': 'الباليه الكلاسيكي',
    'Hip-Hop Dance': 'رقص الهيب هوب',
    'Stage Combat': 'القتال المسرحي',
    'Stage combat': 'القتال المسرحي',
    'Public Speaking': 'الخطابة',
    'Modeling Poses': 'وضعيات الموضة',
    'Modeling': 'العرض والأزياء',
    'Photography': 'التصوير',
    'Video Editing': 'تحرير الفيديو',
    'Motion capture': 'التقاط الحركة',
    'Live TV': 'البث المباشر',
    'Cinematography': 'السينمائية',
    'Directing': 'الإخراج',
    'Editing': 'المونتاج',

    // ── Places ─────────────────────────────────────────────────────────────
    'Algiers': 'الجزائر العاصمة',
    'Oran': 'وهران',
    'Constantine': 'قسنطينة',
    'Annaba': 'عنابة',
    'Tlemcen': 'تلمسان',
    'Béjaïa': 'بجاية',
    'Bejaia': 'بجاية',
    'Sétif': 'سطيف',
    'Setif': 'سطيف',
    'Paris': 'باريس',
    'Marseille': 'مرسيليا',
    'Casablanca': 'الدار البيضاء',
    'Tunis': 'تونس',
    'Dubai': 'دبي',
    'Cairo': 'القاهرة',
    'Le Caire': 'القاهرة',
    'Algeria': 'الجزائر',
    'France': 'فرنسا',
    'Morocco': 'المغرب',
    'Tunisia': 'تونس',
    'UAE': 'الإمارات',
    'EAU': 'الإمارات',
    'Egypt': 'مصر',
    'Algerian': 'جزائري',
    'French-Algerian': 'فرنسي جزائري',
    'Moroccan': 'مغربي',
    'Tunisian': 'تونسي',
    'Emirati': 'إماراتي',
    'Egyptian': 'مصري',

    // ── Colors ─────────────────────────────────────────────────────────────
    'Brown': 'بني',
    'Black': 'أسود',
    'Green': 'أخضر',
    'Hazel': 'عسلي',
    'Blue': 'أزرق',
    'Dark Brown': 'بني غامق',
    'Blonde': 'أشقر',
    'Auburn': 'كستنائي',

    // ── Common casting / profile copy fragments ────────────────────────────
    'Negotiable': 'قابل للتفاوض',
    'Self-taught': 'عصامي',
    'Autodidacte / Self-taught': 'عصامي / تعلّم ذاتي',

    // ── Casting titles (exact matches from _castingSeeds) ──────────────────
    'Sable et Silence — Rôle Principal Féminin':
        'رمال وصمت — الدور الرئيسي النسائي',
    'Les Ombres de la Casbah — Rôle Principal Masculin':
        'ظلال القصبة — الدور الرئيسي الرجالي',
    'Dar El Bacha — Saison 2, Rôle Récurrent':
        'دار الباشا — الموسم 2، دور متكرر',
    'Nour — Rôle Principal Féminin (Telenovela)':
        'نور — الدور الرئيسي النسائي (تيلينوفيلا)',
    'Djezzy Mobile — Spot Publicitaire':
        'Djezzy Mobile — إعلان تلفزيوني',
    'Ifri — Campagne Boisson Rafraîchissante':
        'Ifri — حملة مشروب منعش',
    "Festival de Théâtre d'Alger — Troupe Principale":
        'مهرجان مسرح الجزائر — الفرقة الرئيسية',
    'Pièce Kabyle Traditionnelle — Béjaïa':
        'مسرحية قبلية تقليدية — بجاية',
    "Documentaire Terre d'Algérie — Voix Off":
        'وثائقي أرض الجزائر — تعليق صوتي',
    'Série Animée — Doublage Français, Paris':
        'مسلسل رسوم متحركة — دبلجة فرنسية، باريس',
    'Algiers Fashion Week — Défilé Principal':
        'أسبوع الموضة في الجزائر — العرض الرئيسي',
    'Algiers Fashion Week': 'أسبوع الموضة في الجزائر',
    'Hiba Couture — Campagne Photo':
        'Hiba Couture — حملة تصوير',
    'Le Dernier Tramway — Court Métrage':
        'الترام الأخير — فيلم قصير',
    'Co-production Internationale — Figuration':
        'إنتاج مشترك دولي — كومبارس',
    'Nouvelle Star — Recherche de Danseurs':
        'Nouvelle Star — البحث عن راقصين',
    'CPA Bank — Publicité Institutionnelle':
        'CPA Bank — إعلان مؤسسي',
    'Clip Raï — Danseuses Backup':
        'كليب راي — راقصات مساندات',
    'Shooting Mariée — Collection Printemps':
        'تصوير عروس — مجموعة الربيع',
    'Blockbuster International — Cascadeurs & Figuration, Dubai':
        'فيلم عالمي ضخم — ممثلو مخاطر وكومبارس، دبي',
    'Action Movie — Cascadeurs & Figuration, Dubai':
        'فيلم أكشن — ممثلو مخاطر وكومبارس، دبي',
    'Bride Photography — Collection Printemps':
        'تصوير عروس — مجموعة الربيع',
    'Podcast de Marque — Voix & Présentation, Le Caire':
        'بودكاست علامة تجارية — صوت وتقديم، القاهرة',

    // Credit / profile titles that appear elsewhere in mock data
    'Sable et Silence': 'رمال وصمت',
    'Les Ombres de la Casbah': 'ظلال القصبة',
    'Dar El Bacha (Saison 1)': 'دار الباشا (الموسم 1)',
    'Nour': 'نور',
    'Publicité Djezzy': 'إعلان Djezzy',
    "Festival de Théâtre d'Alger": 'مهرجان مسرح الجزائر',
    'Court métrage "Le Dernier Tramway"': 'فيلم قصير «الترام الأخير»',
    'Campagne Hiba Couture': 'حملة Hiba Couture',
    "Documentaire Terre d'Algérie": 'وثائقي أرض الجزائر',
    'Clip vidéo Raï': 'كليب فيديو راي',
    'Publicité CPA Bank': 'إعلان CPA Bank',

    // ── Casting roles (from _castingSeeds + common mock roles) ─────────────
    'Rôle principal féminin': 'دور رئيسي نسائي',
    'Rôle principal masculin': 'دور رئيسي رجالي',
    'Rôle récurrent': 'دور متكرر',
    'Rôle principal': 'دور رئيسي',
    'Rôle secondaire': 'دور ثانوي',
    'Talent publicitaire': 'موهبة إعلانية',
    'Talent principal': 'الموهبة الرئيسية',
    'Talent': 'موهبة',
    'Comédien(ne) de théâtre': 'ممثل / ممثلة مسرح',
    'Comédien(ne)': 'ممثل / ممثلة',
    'Comédien(ne) voix off': 'ممثل / ممثلة تعليق صوتي',
    'Voix off': 'تعليق صوتي',
    'Mannequin défilé': 'عارضة أزياء للعرض',
    'Mannequin': 'عارضة / عارض أزياء',
    'Figurant(e)': 'كومبارس',
    'Figuration': 'كومبارس',
    'Danseur/Danseuse': 'راقص / راقصة',
    'Danseuse': 'راقصة',
    'Cascadeur / Figurant': 'ممثل مخاطر / كومبارس',
    'Présentateur/Présentatrice': 'مقدّم / مقدّمة',
    'Lead Actress': 'بطلة رئيسية',
    'Lead Actor': 'بطل رئيسي',
    'Supporting Role': 'دور ثانوي',
    'Voice Over': 'تعليق صوتي',
    'Extra': 'كومبارس',
    'Model': 'عارضة / عارض',

    // ── Requirements (from _castingSeeds) ──────────────────────────────────
    'Expérience en tournage long métrage': 'خبرة في تصوير فيلم طويل',
    'Disponible 6 semaines': 'متاح لمدة 6 أسابيع',
    'Casting en présentiel à Alger': 'كاستينغ حضوري في الجزائر العاصمة',
    'Permis de conduire': 'رخصة قيادة',
    'Disponible tous les week-ends': 'متاح في جميع عطل نهاية الأسبوع',
    'Expérience télévision': 'خبرة في التلفزيون',
    'Disponibilité longue durée (6 mois)': 'تفرّغ طويل الأمد (6 أشهر)',
    'Résidence à Oran': 'إقامة في وهران',
    'Casting photo requis': 'كاستينغ صورة مطلوب',
    'Disponible en semaine': 'متاح خلال أيام الأسبوع',
    'Casting vidéo requis': 'كاستينغ فيديو مطلوب',
    'Expérience scénique obligatoire': 'خبرة مسرحية إلزامية',
    'Disponible pour tournée': 'متاح للجولة',
    'Kabyle courant': 'قبائلية بطلاقة',
    'Disponible les soirs': 'متاح في المساء',
    'Home studio ou accès studio': 'استوديو منزلي أو إمكانية الوصول لاستوديو',
    'Bande démo requise': 'شريط تجارب مطلوب',
    'Studio à Paris': 'استوديو في باريس',
    'Direction artistique fournie': 'إخراج فني موفَّر',
    'Book photo à jour': 'بوك صور محدَّث',
    'Essayage obligatoire': 'تجربة ملابس إلزامية',
    'Book photo requis': 'بوك صور مطلوب',
    'Disponible un week-end complet': 'متاح لعطلة نهاية أسبوع كاملة',
    'Disponible plusieurs jours consécutifs': 'متاح لعدة أيام متتالية',
    'Vidéo de démonstration requise': 'فيديو تجريبي مطلوب',
    'Allure professionnelle': 'مظهر مهني',
    'Chorégraphie fournie en amont': 'كوريغرافيا موفَّرة مسبقاً',
    'Essayage à Tlemcen': 'تجربة ملابس في تلمسان',
    'Formation cascade': 'تدريب على المشاهد الخطرة',
    'Visa de travail EAU': 'تأشيرة عمل الإمارات',
    'Matériel d\'enregistrement personnel': 'معدات تسجيل شخصية',

    // ── descriptionEn → Arabic MSA ─────────────────────────────────────────
    'Feature drama in pre-production in Algiers. Seeking a lead actress able to carry an intense story about memory and family resilience.':
        'فيلم درامي طويل في مرحلة ما قبل الإنتاج بالجزائر العاصمة. نبحث عن ممثلة رئيسية قادرة على حمل قصة قوية عن الذاكرة وصمود العائلة.',
    "Crime feature shot in Algiers' Casbah. Looking for a charismatic lead actor comfortable with light action sequences.":
        'فيلم بوليسي طويل يُصوَّر في قصبة الجزائر. نبحث عن ممثل رئيسي كاريزمي مرتاح في مشاهد الأكشن الخفيفة.',
    'Hit prime-time TV series. Looking for an actor for a recurring role across 12 episodes.':
        'مسلسل تلفزيوني ناجح في أوقات الذروة. نبحث عن ممثل لدور متكرر عبر 12 حلقة.',
    'Daily telenovela shot in Oran. Seeking a lead actress to play a modern heroine for a full season.':
        'تيلينوفيلا يومية تُصوَّر في وهران. نبحث عن ممثلة رئيسية لتجسيد بطلة عصرية على مدار موسم كامل.',
    'National ad for a telecom operator. Looking for fresh, smiling faces for a one-day shoot.':
        'إعلان وطني لمشغّل اتصالات. نبحث عن وجوه جديدة ومبتسمة لتصوير ليوم واحد.',
    'Summer commercial for a local beverage brand. Looking for a young, dynamic vibe.':
        'إعلان صيفي لعلامة مشروبات محلية. نبحث عن أجواء شبابية وحيوية.',
    'Contemporary play for the national festival. Looking for experienced stage actors for a two-month tour.':
        'مسرحية معاصرة للمهرجان الوطني. نبحث عن ممثلين مسرحيين ذوي خبرة لجولة لمدة شهرين.',
    'Stage adaptation of a traditional Kabyle tale. Looking for actors fluent in Kabyle.':
        'اقتباس مسرحي لحكاية قبلية تقليدية. نبحث عن ممثلين يتحدثون القبائلية بطلاقة.',
    'Nature and heritage documentary. Looking for a warm, composed voice-over artist in Arabic and French.':
        'وثائقي عن الطبيعة والتراث. نبحث عن صوت تعليق دافئ وهادئ بالعربية والفرنسية.',
    'French dub for an international animated series. Looking for versatile voice actors.':
        'دبلجة فرنسية لمسلسل رسوم متحركة دولي. نبحث عن ممثلي صوت متعدّدي المهارات.',
    'Flagship runway show of Algiers Fashion Week. Looking for female models to present Algerian designer collections.':
        'العرض الرئيسي لأسبوع الموضة في الجزائر. نبحث عن عارضات لتقديم مجموعات مصمّمين جزائريين.',
    'Photo campaign for an Algerian haute couture house. Shoot completed, position filled.':
        'حملة تصوير لدار أزياء جزائرية راقية. انتهى التصوير وتم شغل المنصب.',
    'Award-selected student short film. Looking for a young actress for the lead role.':
        'فيلم قصير طلابي مختار في مهرجان. نبحث عن ممثلة شابة للدور الرئيسي.',
    'Internationally co-produced feature shot in Annaba. Looking for many extras for crowd scenes.':
        'فيلم طويل بإنتاج مشترك دولي يُصوَّر في عنابة. نبحث عن عدد كبير من الكومبارس لمشاهد الحشود.',
    'Talent TV show looking for dancers to join the permanent stage crew.':
        'برنامج مواهب تلفزيوني يبحث عن راقصين للانضمام إلى الفرقة المسرحية الدائمة.',
    'Institutional campaign for a national bank. Casting completed, role filled.':
        'حملة مؤسسية لبنك وطني. انتهى الكاستينغ وتم شغل الدور.',
    'Music video for a popular raï artist shot in Oran. Looking for backup dancers for the main choreography.':
        'كليب فيديو لفنان راي شهير يُصوَّر في وهران. نبحث عن راقصات مساندات للكوريغرافيا الرئيسية.',
    'Photo shoot for a bridal dress collection in Tlemcen. Still in preparation.':
        'جلسة تصوير لمجموعة فساتين زفاف في تلمسان. لا تزال في مرحلة التحضير.',
    'Big-budget international production shot in Dubai. Looking for extras and stunt performers trained in martial arts.':
        'إنتاج دولي بميزانية كبيرة يُصوَّر في دبي. نبحث عن كومبارس وممثلي مخاطر مدرَّبين على الفنون القتالية.',
    'Sponsored podcast aimed at young entrepreneurs. Campaign archived after budget closure.':
        'بودكاست برعاية يستهدف روّاد الأعمال الشباب. أُرشفت الحملة بعد إغلاق الميزانية.',

    // ── descriptionFr → Arabic (fallback when EN map misses) ───────────────
    'Long métrage dramatique en préparation à Alger. Nous recherchons une actrice principale capable de porter un récit intense sur la mémoire et la résilience familiale.':
        'فيلم درامي طويل قيد التحضير في الجزائر العاصمة. نبحث عن ممثلة رئيسية قادرة على حمل قصة قوية عن الذاكرة وصمود العائلة.',
    "Long métrage policier tourné dans la Casbah d'Alger. Recherche un acteur principal charismatique, à l'aise dans les scènes d'action légères.":
        'فيلم بوليسي طويل يُصوَّر في قصبة الجزائر. نبحث عن ممثل رئيسي كاريزمي مرتاح في مشاهد الأكشن الخفيفة.',
    'Série télévisée à succès diffusée en prime time. Nous cherchons un comédien pour un rôle récurrent sur 12 épisodes.':
        'مسلسل تلفزيوني ناجح يُبث في أوقات الذروة. نبحث عن ممثل لدور متكرر عبر 12 حلقة.',
    'Telenovela quotidienne tournée à Oran. Recherche une actrice principale pour incarner une héroïne moderne sur toute une saison.':
        'تيلينوفيلا يومية تُصوَّر في وهران. نبحث عن ممثلة رئيسية لتجسيد بطلة عصرية على مدار موسم كامل.',
    "Publicité nationale pour un opérateur télécom. Recherche des visages frais et souriants pour un tournage d'une journée.":
        'إعلان وطني لمشغّل اتصالات. نبحث عن وجوه جديدة ومبتسمة لتصوير ليوم واحد.',
    'Spot publicitaire estival pour une marque de boisson locale. Ambiance jeune et dynamique recherchée.':
        'إعلان صيفي لعلامة مشروبات محلية. نبحث عن أجواء شبابية وحيوية.',
    'Pièce contemporaine présentée au festival national. Recherche des comédiens de théâtre expérimentés pour une tournée de deux mois.':
        'مسرحية معاصرة تُقدَّم في المهرجان الوطني. نبحث عن ممثلين مسرحيين ذوي خبرة لجولة لمدة شهرين.',
    "Adaptation théâtrale d'un conte kabyle traditionnel. Recherche des comédiens parlant couramment le kabyle.":
        'اقتباس مسرحي لحكاية قبلية تقليدية. نبحث عن ممثلين يتحدثون القبائلية بطلاقة.',
    'Documentaire nature et patrimoine. Recherche une voix off chaleureuse et posée en arabe et en français.':
        'وثائقي عن الطبيعة والتراث. نبحث عن صوت تعليق دافئ وهادئ بالعربية والفرنسية.',
    "Doublage français d'une série animée internationale. Recherche des comédiens voix polyvalents.":
        'دبلجة فرنسية لمسلسل رسوم متحركة دولي. نبحث عن ممثلي صوت متعدّدي المهارات.',
    "Défilé phare de la Fashion Week d'Alger. Recherche des mannequins féminins pour présenter des collections de créateurs algériens.":
        'العرض الرئيسي لأسبوع الموضة في الجزائر. نبحث عن عارضات لتقديم مجموعات مصمّمين جزائريين.',
    'Campagne photo pour une maison de haute couture algérienne. Tournage terminé, poste pourvu.':
        'حملة تصوير لدار أزياء جزائرية راقية. انتهى التصوير وتم شغل المنصب.',
    'Court métrage étudiant sélectionné en festival. Recherche une jeune actrice pour le rôle principal.':
        'فيلم قصير طلابي مختار في مهرجان. نبحث عن ممثلة شابة للدور الرئيسي.',
    'Long métrage en co-production internationale tourné à Annaba. Recherche de nombreux figurants pour des scènes de foule.':
        'فيلم طويل بإنتاج مشترك دولي يُصوَّر في عنابة. نبحث عن عدد كبير من الكومبارس لمشاهد الحشود.',
    'Émission de télé-crochet à la recherche de danseurs pour la troupe de scène permanente.':
        'برنامج مواهب تلفزيوني يبحث عن راقصين للانضمام إلى الفرقة المسرحية الدائمة.',
    'Campagne institutionnelle pour une banque nationale. Casting terminé, rôle pourvu.':
        'حملة مؤسسية لبنك وطني. انتهى الكاستينغ وتم شغل الدور.',
    "Clip vidéo d'un artiste raï populaire tourné à Oran. Recherche des danseuses pour la chorégraphie principale.":
        'كليب فيديو لفنان راي شهير يُصوَّر في وهران. نبحث عن راقصات مساندات للكوريغرافيا الرئيسية.',
    'Séance photo pour une collection de robes de mariée à Tlemcen. Encore en préparation.':
        'جلسة تصوير لمجموعة فساتين زفاف في تلمسان. لا تزال في مرحلة التحضير.',
    'Production internationale à gros budget tournée à Dubai. Recherche des figurants et cascadeurs formés aux arts martiaux.':
        'إنتاج دولي بميزانية كبيرة يُصوَّر في دبي. نبحث عن كومبارس وممثلي مخاطر مدرَّبين على الفنون القتالية.',
    'Podcast sponsorisé destiné aux jeunes entrepreneurs. Campagne archivée après clôture du budget.':
        'بودكاست برعاية يستهدف روّاد الأعمال الشباب. أُرشفت الحملة بعد إغلاق الميزانية.',
  };
}
