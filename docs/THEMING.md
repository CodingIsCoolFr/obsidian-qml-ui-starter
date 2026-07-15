# Theming guide

The starter separates semantic color roles from individual controls. Pages bind
to `Theme.qml`; controls never hard-code product-specific colors.

## Presets

- **Obsidian** — neutral true dark canvas with graphite structure.
- **Daylight** — clean light canvas with a violet interaction accent.
- **Studio** — the user's saved custom accent and seven-layer palette.

## Semantic roles

| Role | Purpose |
| --- | --- |
| `accent` | Primary actions, selection, focus and active values |
| `background` | Main window canvas |
| `sidebar` | Navigation rail |
| `surface` | Cards, dialogs and input backgrounds |
| `border` | Dividers and component structure |
| `text` | Primary copy and values |
| `muted` | Descriptions, metadata and inactive navigation |
| `success`, `warning`, `danger`, `info` | Status language only |

## Reusing the system

1. Change the organization and application names in `src/main.cpp`.
2. Replace the placeholder title and mock models in `qml/Main.qml`.
3. Keep `Theme.qml` and the `qml/components` directory intact.
4. Bind product state to the existing controls or add new components that accept
   a required `theme` property.
5. Use `theme.text` over `theme.surface` for body copy. Theme Studio reports the
   resulting contrast ratio and warns below 4.5:1.

Qt `Settings` persists the active preset, custom canvas, and every custom color.
The Basic control style is selected before application startup so Windows never
falls back to bright native hover states.
