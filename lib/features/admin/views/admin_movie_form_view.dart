import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task/features/admin/data/admin_movie_model.dart';
import 'package:task/features/admin/provider/admin_provider.dart';
import 'package:task/features/admin/widgets/admin_form_field.dart';
import 'package:task/features/admin/widgets/cast_editor.dart';
import 'package:task/features/admin/widgets/genre_multi_select.dart';
import 'package:task/features/admin/widgets/section_header.dart';
import 'package:task/features/genres/data/genre_model.dart';
import 'package:task/features/genres/provider/genre_provider.dart';
import 'package:task/features/movie_details/data/helpers/cast_model.dart';
import 'package:task/features/movie_details/data/helpers/video_model.dart';
import 'package:task/shared/custom_text.dart';

class AdminMovieFormView extends StatefulWidget {
  final AdminMovieModel? existing;

  const AdminMovieFormView({super.key, this.existing});

  @override
  State<AdminMovieFormView> createState() => _AdminMovieFormViewState();
}

class _AdminMovieFormViewState extends State<AdminMovieFormView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _title;
  late final TextEditingController _originalTitle;
  late final TextEditingController _overview;
  late final TextEditingController _posterPath;
  late final TextEditingController _backdropPath;
  late final TextEditingController _releaseDate;
  late final TextEditingController _voteAverage;
  late final TextEditingController _voteCount;
  late final TextEditingController _runtime;
  late final TextEditingController _tagline;
  late final TextEditingController _status;
  late final TextEditingController _language;
  late final TextEditingController _budget;
  late final TextEditingController _revenue;
  late final TextEditingController _homepage;
  late final TextEditingController _imdbId;
  late final TextEditingController _popularity;
  late final TextEditingController _trailer;

  List<GenreModel> _selectedGenres = [];
  List<CastModel> _cast = [];

  bool _adult = false;
  bool _isSaving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final m = widget.existing;
    _title = TextEditingController(text: m?.title ?? '');
    _originalTitle = TextEditingController(text: m?.originalTitle ?? '');
    _overview = TextEditingController(text: m?.overview ?? '');
    _posterPath = TextEditingController(text: m?.posterPath ?? '');
    _backdropPath = TextEditingController(text: m?.backdropPath ?? '');
    _releaseDate = TextEditingController(text: m?.releaseDate ?? '');
    _voteAverage = TextEditingController(
      text: m?.voteAverage?.toString() ?? '',
    );
    _voteCount = TextEditingController(text: m?.voteCount?.toString() ?? '');
    _runtime = TextEditingController(text: m?.runtime?.toString() ?? '');
    _tagline = TextEditingController(text: m?.tagline ?? '');
    _status = TextEditingController(text: m?.status ?? '');
    _language = TextEditingController(text: m?.originalLanguage ?? '');
    _budget = TextEditingController(text: m?.budget?.toString() ?? '');
    _revenue = TextEditingController(text: m?.revenue?.toString() ?? '');
    _homepage = TextEditingController(text: m?.homepage ?? '');
    _imdbId = TextEditingController(text: m?.imdbId ?? '');
    _popularity = TextEditingController(text: m?.popularity?.toString() ?? '');
    _trailer = TextEditingController(text: m?.trailer?.key ?? '');
    _selectedGenres = List.of(m?.genres ?? []);
    _cast = List.of(m?.cast ?? []);
    _adult = m?.adult ?? false;

    // Genres might not be loaded yet if the admin opened this form without
    // visiting the Genres tab first this session.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final genreProvider = context.read<GenreProvider>();
      if (genreProvider.genres.isEmpty) {
        genreProvider.loadGenres();
      }
    });
  }

  @override
  void dispose() {
    for (final c in [
      _title,
      _originalTitle,
      _overview,
      _posterPath,
      _backdropPath,
      _releaseDate,
      _voteAverage,
      _voteCount,
      _runtime,
      _tagline,
      _status,
      _language,
      _budget,
      _revenue,
      _homepage,
      _imdbId,
      _popularity,
      _trailer,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // Accepts either a bare YouTube video id or a full YouTube URL (any of
  // the common formats), and extracts just the id either way.
  String? _extractYoutubeKey(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.host.contains('youtu')) {
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      }
      return uri.queryParameters['v'];
    }
    return trimmed; // assume a bare video id was pasted
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final provider = context.read<AdminProvider>();
    final existing = widget.existing;

    // Always a concrete list (never null) — that matters for the edit
    // path below, where copyWithAdmin uses `videos ?? this.videos`: an
    // empty list correctly clears a previously-set trailer, but null
    // would fall back to (and keep) the old one.
    final trailerKey = _extractYoutubeKey(_trailer.text);
    final videos = trailerKey == null
        ? <VideoModel>[]
        : [
            VideoModel(
              id: 'admin-trailer',
              key: trailerKey,
              name: '${_title.text.trim()} Trailer',
              site: 'YouTube',
              type: 'Trailer',
            ),
          ];

    try {
      if (_isEdit && existing != null) {
        final updated = existing.copyWithAdmin(
          title: _title.text.trim(),
          originalTitle: _originalTitle.text.trim().isEmpty
              ? null
              : _originalTitle.text.trim(),
          overview: _overview.text.trim().isEmpty
              ? null
              : _overview.text.trim(),
          posterPath: _posterPath.text.trim().isEmpty
              ? null
              : _posterPath.text.trim(),
          backdropPath: _backdropPath.text.trim().isEmpty
              ? null
              : _backdropPath.text.trim(),
          releaseDate: _releaseDate.text.trim().isEmpty
              ? null
              : _releaseDate.text.trim(),
          voteAverage: double.tryParse(_voteAverage.text.trim()),
          voteCount: int.tryParse(_voteCount.text.trim()),
          runtime: int.tryParse(_runtime.text.trim()),
          tagline: _tagline.text.trim().isEmpty ? null : _tagline.text.trim(),
          status: _status.text.trim().isEmpty ? null : _status.text.trim(),
          originalLanguage: _language.text.trim().isEmpty
              ? null
              : _language.text.trim(),
          budget: int.tryParse(_budget.text.trim()),
          revenue: int.tryParse(_revenue.text.trim()),
          homepage: _homepage.text.trim().isEmpty
              ? null
              : _homepage.text.trim(),
          imdbId: _imdbId.text.trim().isEmpty ? null : _imdbId.text.trim(),
          popularity: double.tryParse(_popularity.text.trim()),
          adult: _adult,
          genres: _selectedGenres,
          cast: _cast,
          videos: videos,
        );
        await provider.updateMovie(updated);
      } else {
        // Create mode — id is assigned by the repository (timestamp)
        final newMovie = AdminMovieModel(
          docId: '', // ignored on create; repository generates it
          id: 0, // overwritten by repository with timestamp
          title: _title.text.trim(),
          originalTitle: _originalTitle.text.trim().isEmpty
              ? null
              : _originalTitle.text.trim(),
          overview: _overview.text.trim().isEmpty
              ? null
              : _overview.text.trim(),
          posterPath: _posterPath.text.trim().isEmpty
              ? null
              : _posterPath.text.trim(),
          backdropPath: _backdropPath.text.trim().isEmpty
              ? null
              : _backdropPath.text.trim(),
          releaseDate: _releaseDate.text.trim().isEmpty
              ? null
              : _releaseDate.text.trim(),
          voteAverage: double.tryParse(_voteAverage.text.trim()),
          voteCount: int.tryParse(_voteCount.text.trim()),
          runtime: int.tryParse(_runtime.text.trim()),
          tagline: _tagline.text.trim().isEmpty ? null : _tagline.text.trim(),
          status: _status.text.trim().isEmpty ? null : _status.text.trim(),
          originalLanguage: _language.text.trim().isEmpty
              ? null
              : _language.text.trim(),
          budget: int.tryParse(_budget.text.trim()),
          revenue: int.tryParse(_revenue.text.trim()),
          homepage: _homepage.text.trim().isEmpty
              ? null
              : _homepage.text.trim(),
          imdbId: _imdbId.text.trim().isEmpty ? null : _imdbId.text.trim(),
          popularity: double.tryParse(_popularity.text.trim()),
          adult: _adult,
          genres: _selectedGenres,
          cast: _cast,
          videos: videos,
        );
        await provider.addMovie(newMovie);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(
          backgroundColor: AppColors.bg,
          iconTheme: const IconThemeData(color: Colors.white),
          title: CustomText(
            _isEdit ? 'Edit Movie' : 'Add Movie',
            color: Colors.white,
            size: 20,
            weight: FontWeight.w800,
          ),
          actions: [
            if (_isSaving)
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              )
            else
              TextButton(
                onPressed: _save,
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              SectionHeader('BASIC INFO'),
              AdminFormField(
                _title,
                'Title *',
                Icons.title,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Title is required'
                    : null,
              ),
              const Gap(14),
              AdminFormField(_originalTitle, 'Original Title', Icons.translate),
              const Gap(14),
              AdminFormField(
                _overview,
                'Overview / Synopsis',
                Icons.description_outlined,
                maxLines: 4,
              ),
              SectionHeader('IMAGES'),
              AdminFormField(
                _posterPath,
                'Poster URL or TMDB path',
                Icons.image_outlined,
              ),
              const Gap(14),
              AdminFormField(
                _backdropPath,
                'Backdrop URL or TMDB path',
                Icons.panorama_outlined,
              ),
              SectionHeader('RELEASE & RATINGS'),
              AdminFormField(
                _releaseDate,
                'Release Date (YYYY-MM-DD)',
                Icons.calendar_today_outlined,
              ),
              const Gap(14),
              Row(
                children: [
                  Expanded(
                    child: AdminFormField(
                      _voteAverage,
                      'Rating (0–10)',
                      Icons.star_outline,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: AdminFormField(
                      _voteCount,
                      'Vote Count',
                      Icons.how_to_vote_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const Gap(14),
              AdminFormField(
                _runtime,
                'Runtime (minutes)',
                Icons.timer_outlined,
                keyboardType: TextInputType.number,
              ),
              SectionHeader('GENRES'),
              GenreMultiSelect(
                selected: _selectedGenres,
                onChanged: (genres) => setState(() => _selectedGenres = genres),
              ),
              SectionHeader('DETAILS'),
              AdminFormField(_tagline, 'Tagline', Icons.format_quote_outlined),
              const Gap(14),
              AdminFormField(
                _status,
                'Status (e.g. Released)',
                Icons.info_outline,
              ),
              const Gap(14),
              AdminFormField(
                _language,
                'Original Language (e.g. en)',
                Icons.language,
              ),
              const Gap(14),
              AdminFormField(_popularity, 'Popularity', Icons.trending_up),
              SectionHeader('FINANCIALS'),
              Row(
                children: [
                  Expanded(
                    child: AdminFormField(
                      _budget,
                      'Budget (\$)',
                      Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: AdminFormField(
                      _revenue,
                      'Revenue (\$)',
                      Icons.monetization_on_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SectionHeader('LINKS'),
              AdminFormField(_homepage, 'Homepage URL', Icons.link),
              const Gap(14),
              AdminFormField(
                _imdbId,
                'IMDB ID (e.g. tt1234567)',
                Icons.movie_filter_outlined,
              ),
              SectionHeader('TRAILER'),
              AdminFormField(
                _trailer,
                'YouTube URL or video id',
                Icons.play_circle_outline,
              ),
              SectionHeader('CAST'),
              CastEditor(
                cast: _cast,
                onChanged: (cast) => setState(() => _cast = cast),
              ),
              SectionHeader('FLAGS'),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: const Border.fromBorderSide(
                    BorderSide(color: Color(0xFF353534), width: 1.5),
                  ),
                ),
                // SwitchListTile paints its ink/ripple effects expecting a
                // Material ancestor to host them. Setting the color on the
                // outer Container's BoxDecoration (as before) sits in front
                // of that ink layer instead of hosting it — that's exactly
                // what triggers Flutter's "ListTile background color or
                // ink splashes may be invisible" warning. Material is the
                // widget actually designed to host this.
                child: Material(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: SwitchListTile(
                    value: _adult,
                    onChanged: (v) => setState(() => _adult = v),
                    title: const Text(
                      'Adult Content (+18)',
                      style: TextStyle(color: Colors.white),
                    ),
                    activeThumbColor: AppColors.primary,
                  ),
                ),
              ),
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }
}
