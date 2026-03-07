---
name: ui-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications (examples include websites, landing pages, dashboards, React components, HTML/CSS layouts, or when styling/beautifying any web UI). Generates creative, polished code that avoids generic AI aesthetics.
---

This skill guides creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

The user provides frontend requirements: a component, page, application, or interface to build. They may include context about the purpose, audience, or technical constraints.

---

## Phase 1 — Understand Before You Create

Before writing a single line of code, establish clarity on four dimensions:

1. **Purpose** — What problem does this interface solve? Who are the real users, and what do they need to accomplish?
2. **Tone** — Pick an extreme and commit to it. Brutally minimal. Maximalist chaos. Retro-futuristic. Organic/natural. Luxury/refined. Playful/toy-like. Editorial/magazine. Brutalist/raw. Art deco/geometric. Soft/pastel. Industrial/utilitarian. These are starting points — synthesize your own. The key is specificity, not intensity.
3. **Constraints** — Framework (React, Vue, plain HTML), performance targets, accessibility requirements, existing design system tokens.
4. **Differentiation** — What is the single most memorable thing about this interface? Define it before you start. Everything else serves that anchor.

**CRITICAL**: Commit to a clear conceptual direction and execute it with precision. The enemy is not maximalism or minimalism — it is vagueness and hedging. A refined, subtle design and an elaborate, baroque design are equally valid. Both fail if executed without conviction.

---

## Phase 2 — Design Principles

### Typography

Choose fonts that carry meaning, not just legibility. Avoid the defaults: Inter, Roboto, Arial, system-ui, and Space Grotesk are overused and carry no personality. Use Google Fonts, Bunny Fonts, or self-hosted options.

Pairing model: one display face (opinionated, characterful) + one body face (refined, readable). A few directions:

- **Editorial**: Playfair Display + Source Serif 4
- **Brutalist**: Space Mono + IBM Plex Sans
- **Luxury**: Cormorant Garamond + Jost
- **Technical**: JetBrains Mono + DM Sans
- **Organic**: Fraunces + Nunito
- **Geometric**: Bebas Neue + Barlow

Scale with intention: one dominant size (a headline or label) that is noticeably large or small. Avoid uniform, evenly-distributed type sizes.

### Color

Commit. A palette of 2–3 colors executed with conviction beats a 10-color palette executed timidly. Use CSS custom properties (`--color-*`) for every color reference — no magic strings.

Rules:
- Dominant background + dominant foreground + one sharp accent. Add a muted mid-tone if needed.
- Avoid: purple gradients on white, light-blue tech palettes, generic "SaaS blue", default Tailwind gray.
- Prefer: unexpected combinations — burnt sienna + cream + black, deep teal + acid yellow, near-white + deep navy + copper.
- Vary freely between light and dark themes. Neither is default.

### Motion

Use animation to reinforce the aesthetic, not to demonstrate technical capability. Principles:

- **One orchestrated moment** is more powerful than many scattered micro-interactions. A well-staged page load with staggered reveals (`animation-delay`) creates delight; random hover effects on every element create noise.
- CSS-only for HTML artifacts. Motion/Framer Motion for React when available.
- High-impact triggers: page load, scroll-into-view, meaningful hover states (not all hover states).
- Duration guidelines: entrances 300–600ms, exits 150–300ms. Use `ease-out` for enters, `ease-in` for exits, custom cubic-bezier for personality.
- Respect `prefers-reduced-motion`: wrap all non-essential animations in the media query.

### Layout and Composition

Break the grid deliberately. Predictable 12-column layouts feel safe and forgettable. Instead:

- Asymmetry with purpose: heavy left / light right, or a single off-center anchor element
- Overlapping elements (controlled z-index layering)
- Diagonal flow or rotated type accents
- Generous negative space as a design element, not an afterthought
- OR: controlled density — pack information tightly when the aesthetic demands it (data dashboards, editorial layouts)

Use `clamp()` for fluid typography and spacing. Avoid fixed pixel breakpoints where possible.

### Backgrounds and Depth

Never default to flat solid backgrounds. Create atmosphere:

- Gradient meshes (`background: radial-gradient(...)` layered)
- Subtle noise textures (SVG filter or CSS `url()` data URI)
- Geometric patterns (CSS `repeating-linear-gradient` or SVG `<pattern>`)
- Layered transparencies with `backdrop-filter`
- Dramatic box shadows with color (not gray)
- Grain overlays via pseudo-elements

Match the atmosphere to the aesthetic: industrial uses hard shadows and concrete textures; luxury uses soft glows and fine grain; brutalist uses raw white or black with no decoration.

---

## Phase 3 — Implementation Standards

### Code Quality

- All code must be **functional and production-ready** — no placeholder comments, no `TODO`, no lorem ipsum unless explicitly requested for a mockup.
- Use semantic HTML elements (`<article>`, `<section>`, `<nav>`, `<main>`, `<header>`, `<footer>`, `<time>`, `<figure>`, etc.).
- CSS custom properties for every design token (color, spacing scale, font stack, border-radius, shadow).
- Component structure should be self-contained and portable.

### Accessibility Baseline

Every interface must meet these minimums without being asked:

- Color contrast ratio ≥ 4.5:1 for body text, ≥ 3:1 for large text and UI components
- All interactive elements reachable and operable via keyboard
- Focus states are visible and styled (never `outline: none` without a replacement)
- Images have meaningful `alt` text or `alt=""` for decorative images
- Form inputs have associated `<label>` elements
- ARIA roles/attributes only where native semantics are insufficient

### Responsive Behavior

- Mobile-first by default unless the brief specifies otherwise
- Test mental model at 375px, 768px, 1280px, 1920px
- Typography and spacing use `clamp()` or viewport units for fluid scaling
- Layouts reflow without breaking — no horizontal scroll on mobile

### Performance Awareness

- Prefer system-adjacent or variable fonts loaded via `font-display: swap`
- Limit external font requests to 2 families, 2–3 weights each
- CSS animations use `transform` and `opacity` only (GPU-composited, no layout thrashing)
- No unnecessary JavaScript for things achievable in CSS

---

## Phase 4 — Anti-Patterns to Avoid

These are the markers of generic AI-generated UI. Avoid them unconditionally:

| Anti-pattern | Why it fails |
|---|---|
| Inter or Roboto as the only font | Zero personality; signals no design intent |
| Purple-to-blue gradient hero on white | Overused; carries no meaning |
| Generic card grid with drop shadows | Safe, predictable, forgettable |
| Rounded everything (`border-radius: 9999px`) | Signals default Tailwind, not design |
| Evenly-distributed color palette | Timid; no dominant visual voice |
| Every element has a hover animation | Noise without signal |
| Hero section with centered h1 + paragraph + two buttons | Cookie-cutter landing page template |
| Dark mode = white text on `#1a1a1a` background | No atmosphere, no depth |
| Gradient text on every heading | Cheapens the typography |

---

## Phase 5 — Execution Checklist

Before delivering, verify:

- [ ] Aesthetic direction is defined and consistently executed throughout
- [ ] Font pairing is distinctive and intentional (not Inter/Roboto/Arial)
- [ ] Color palette is committed and uses CSS custom properties
- [ ] Layout has a memorable compositional choice (not default grid)
- [ ] At least one atmospheric background treatment applied
- [ ] Motion, if present, is purposeful and respects `prefers-reduced-motion`
- [ ] Accessibility minimums met (contrast, keyboard nav, focus states, alt text)
- [ ] Responsive at 375px and 1280px
- [ ] No placeholder content or TODOs in delivered code
- [ ] Code is self-contained and runnable

---

## Aesthetic Direction Reference

Use these as jumping-off points, not constraints. The goal is to pick a direction and push it further than seems comfortable:

| Direction | Typography | Colors | Texture | Motion |
|---|---|---|---|---|
| Brutalist | Monospace, raw, oversized | Black/white + one harsh color | None or extreme | Abrupt, no easing |
| Editorial | Serif display, varied weights | Cream, ink black, 1 accent | Fine grain | Measured reveals |
| Luxury | Thin serif, tight tracking | Deep neutral + gold/copper | Silk grain, soft glow | Slow, deliberate |
| Retro-futuristic | Condensed sans, geometric | Dark + neon accent | Grid lines, scanlines | Glitch, flicker |
| Organic | Variable serif, ink-like | Earth tones, muted | Paper texture, noise | Gentle, breathing |
| Technical | Mono + clean sans | Near-white or near-black | Subtle grid | Precise, mechanical |
| Playful | Rounded display, expressive | Saturated, high-contrast | Illustration, doodle | Springy, bouncy |

---

## Functional/App UI Mode (Uncodixfy Rules)

Apply this mode when building **product UIs**: dashboards, admin tools, SaaS apps, developer tools, internal tools, or any interface where the primary goal is usability and clarity over artistic expression. Reference products: Linear, Raycast, Stripe, GitHub.

When you recognize a functional/app UI context, switch into this mode. The expressive design principles above (atmospheric backgrounds, editorial typography, asymmetric layouts) do not apply. Restraint is the craft.

> **Internal reasoning check**: Before writing any component, list all the "AI default" moves you would normally make — then do none of them.

### Keep It Normal — Component Standards

- **Sidebars**: 240–260px fixed width, solid background, simple `border-right`, no floating shells, no rounded outer corners
- **Headers**: simple text, no eyebrow labels, no uppercase decorative labels, no gradient text — just `h1`/`h2` with proper hierarchy
- **Sections**: standard padding 20–30px, no hero blocks inside dashboards, no decorative copy
- **Navigation**: simple links, subtle hover states, no transform animations, no badges unless functional
- **Buttons**: solid fills or simple borders, 8–10px radius max, no pill shapes, no gradient backgrounds
- **Cards**: simple containers, 8–12px radius max, subtle borders, shadows max `0 2px 8px rgba(0,0,0,0.1)`, no floating/glow effect
- **Forms**: standard inputs, clear labels above fields, no fancy floating labels, simple focus states
- **Inputs**: solid borders, simple focus ring, no animated underlines, no morphing shapes
- **Modals**: centered overlay, simple backdrop, no slide-in animations, straightforward close button
- **Dropdowns**: simple list, subtle shadow, no fancy animations, clear selected state
- **Tables**: clean rows, simple borders, subtle hover, left-aligned text
- **Tabs**: simple underline or border indicator, no pill backgrounds, no sliding animations
- **Badges**: small text, simple border or background, 6–8px radius, no glows, only when functional
- **Icons**: simple shapes, consistent size 16–20px, no decorative icon backgrounds, monochrome or subtle color
- **Typography**: system fonts or a clean sans-serif, clear hierarchy, readable body sizes 14–16px — no mixed serif/sans combos for decoration
- **Spacing**: consistent 4/8/12/16/24/32px scale, no random gaps, no excessive padding
- **Borders**: `1px solid`, subtle colors, no thick decorative borders, no gradient borders
- **Shadows**: max `0 2px 8px rgba(0,0,0,0.1)`, no dramatic drop shadows, no colored shadows
- **Transitions**: 100–200ms ease, simple `opacity`/`color` changes only — no bounce, no transform effects
- **Layouts**: standard grid/flex, predictable structure, clear content hierarchy — no creative asymmetry
- **Containers**: max-width 1200–1400px, centered, standard padding
- **Panels**: simple background differentiation, subtle borders, no floating/detached panels, no glass effects
- **Toolbars**: simple horizontal layout, standard height 48–56px, clear actions, no decorative elements

### Hard No

- Oversized rounded corners or pill overload
- Floating glassmorphism shells as the default visual language
- Soft corporate gradients used to fake taste
- Generic dark SaaS blue-black composition
- Decorative sidebar blobs or visual noise
- Serif headline + system sans as a shortcut to "premium"
- `Segoe UI`, `Trebuchet MS`, `Arial`, `Inter`, `Roboto`, or safe default stacks unless the product already uses them
- Sticky left rail unless the information architecture truly requires it
- Metric-card KPI grid as the first instinct for a dashboard
- Fake charts or data visualizations that exist only to fill space
- Random glows, blur haze, frosted panels, or conic-gradient donuts as decoration
- Hero sections inside internal or app UI unless there is a real product reason
- Alignment that creates dead space just to look expensive
- Overpadded layouts
- Mobile collapse that just stacks everything into one long column with no thought
- Eyebrow labels (`MARCH SNAPSHOT`, `LIVE PULSE`, uppercase decorative spans)
- Decorative copy like "Operational clarity without the clutter" as a page header
- Section notes and mini-notes explaining what the UI does
- `<small>` used as a heading or eyebrow element
- Rounded `<span>` chips used decoratively
- Colors skewing toward blue — prefer dark, muted, calm tones

### Specifically Banned Patterns

These are recurring AI UI mistakes. Recognize and reject them:

| Pattern | Why it's banned |
|---|---|
| Border radii in the 20–32px range applied everywhere | Visually homogeneous; signals AI default |
| Floating sidebar with rounded outer shell | Decorative, not functional |
| Canvas chart placed in a glass card without product reason | Filler, not data |
| Donut chart with hand-wavy percentages | Vague and decorative |
| UI cards using glows instead of hierarchy | Glows are not structure |
| Mixed alignment (some content left-aligned, some floating center-ish) | Inconsistent grid logic |
| Muted gray-blue text throughout | Weakens contrast and clarity |
| "Premium dark mode" = blue-black gradient + cyan accents | No atmosphere, no depth |
| Eyebrow labels with `letter-spacing` and uppercase | Decorative noise |
| Hero strip with decorative copy inside a dashboard | Wrong context |
| Transform animations on nav link hover (`translateX(2px)`) | Gratuitous motion |
| Dramatic box shadows (`0 24px 60px rgba(0,0,0,0.35)`) | Over-designed depth |
| Status dots via `::before` pseudo-elements | Overused pattern |
| Muted uppercase `letter-spacing` labels everywhere | Templated aesthetic |
| Pipeline/progress bars with gradient fills | Decoration over information |
| KPI card grid as the default dashboard opener | Clichéd and uninformative |
| Tables with `.tag` badge on every status cell | Tag overuse |
| Workspace blocks in sidebar with CTAs | Wrong context for CTA |
| Brand marks with gradient backgrounds | Unnecessary decoration |
| Nav badges showing counts or "Live" status labels | Functional clutter |
| Multiple nested panel types (panel, panel-2, rail-panel) | Structural confusion |
| Footer lines with meta information about the UI itself | Self-referential noise |
| Trend indicators with colored text classes (`trend-up`, `trend-flat`) | Cheap, templated |

### The Rule

> If a UI choice feels like a default AI move, ban it and pick the harder, cleaner option. Colors should stay calm, not fight.

---

## When NOT to Use This Skill

- Auditing or reviewing existing UI against design guidelines (use the `web-design-guidelines` skill instead)
- Writing backend logic, APIs, or data layers with no visual output
- Generating design tokens or theme files without an actual UI component
