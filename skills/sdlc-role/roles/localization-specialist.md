# Localization / i18n Specialist

**Slug:** `localization-specialist` · **Phase:** Cross-cutting governance · **Agent fit:** Partial · **9-person seat:** S9 + borrowed

## Mandate

Owns translation, locale formatting, and the layout consequences of text expansion and RTL. Also
handles jurisdiction-specific content differences, which are legal requirements as often as
linguistic ones.

## Inputs required

- Target locales and the business reason for each
- Source strings externalized with context — a string without context is untranslatable
- Jurisdictional content requirements from `legal-contracts` and `compliance-privacy`
- Designs that account for text expansion and bidirectional layout

## Outputs

- Externalized string catalogue with context notes and screenshots per string
- Locale formatting rules: dates, numbers, currency, addresses, names, sorting, pluralization
- Translated content with a review pass by a native speaker in the domain
- RTL and text-expansion layout validation
- Jurisdiction-specific content variants where required by law

## Operating checklist

1. Externalize strings with context. "Open" is a verb or an adjective, and translators cannot tell
   which from the string alone. Context notes and screenshots are the deliverable, not a nicety.
2. Never concatenate translated fragments. Word order differs by language, and concatenation produces
   sentences that cannot be fixed in translation.
3. Handle plurals with the locale's plural rules. Languages have between one and six plural forms;
   an `if (n == 1)` is wrong in most of the world.
4. Budget for text expansion — commonly 30% or more from English — and validate RTL mirroring for
   layout, icons, and progress direction.
5. Format dates, numbers, currency, addresses, and names by locale convention, and do not assume name
   structure. Sorting is locale-dependent too.
6. Get domain-native review. A generically correct translation can be wrong in a legal or medical
   context in ways that matter.
7. Separate legally-required jurisdictional variants from linguistic ones; those are not translation
   decisions and must not be made by a translator.
8. Treat the pseudo-locale as a test target — it exposes hard-coded strings and expansion breakage
   before any translation is bought.

## Definition of done

- [ ] Strings externalized with context and screenshots
- [ ] No concatenated translated fragments
- [ ] Locale-correct plural rules, formatting, and sorting
- [ ] Text expansion and RTL validated in real layouts
- [ ] Domain-native review completed
- [ ] Jurisdictional variants confirmed with legal, not with translators
- [ ] Pseudo-locale pass shows no hard-coded strings

## Must not (separation of duties)

- **Machine-translate legal, safety, or medical content** without qualified human review.
- **Decide jurisdictional content requirements** — that is `legal-contracts`.
- **Ship a locale as supported** when only the UI is translated but content, support, and formats are
  not.

## Failure modes

- Hard-coded strings discovered after the localization contract is signed
- Concatenated sentences that are unfixable in half the target languages
- Layouts that break at 30% expansion, discovered only in the German build
- RTL treated as text direction only, leaving mirrored layout and iconography broken
- A locale marketed as supported with untranslated support and unlocalized formats

## Handoff

**Receives from:** `ux-designer`, `frontend-engineer`, `legal-contracts`, `technical-writer`
**Hands to:** `frontend-engineer` / `mobile-engineer` (fixes), `qa-analyst` (locale testing)

## Related

`ux-designer`, `technical-writer`, `legal-contracts`, `accessibility-specialist`
