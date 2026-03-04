---
name: educative-writeup
description: Write educational technical documents that teach readers with no assumed prior knowledge, using progressive disclosure, analogy-first explanations, and worked examples to build genuine understanding
---

## Purpose

Generate educational technical writeups that teach readers who have no assumed prior knowledge of the subject being discussed. This includes tutorials, concept explainers, onboarding documents, API and library walkthroughs, and how-to guides. The writing style is professional yet warm, structured to guide the reader from unfamiliarity to genuine understanding through progressive disclosure, analogy, and worked examples.

## Document Structure

Follow this teaching arc consistently:

1. **Orient the reader:** Open with a clear statement of what the reader will learn, why it matters to them, and what prior knowledge is explicitly not required. If the document is long, include a table of contents. Set the reader's expectations honestly: tell them what the document covers and, where useful, what it does not cover.

2. **Build the mental model:** Before introducing any technical detail, establish an intuitive mental model using analogy or a plain-language description. Explain what something is like before explaining what it is. The mental model does not need to be perfectly accurate; it needs to be useful. Technical precision comes in the next stage.

3. **Layer the mechanics:** Introduce technical specifics incrementally, one concept at a time, always anchoring new information back to the mental model established in the previous section. Never introduce a concept before the reader has the scaffolding to receive it. Each new layer should feel like a natural extension of what came before, not a discontinuous leap.

4. **Worked examples:** Provide concrete, realistic examples that build in complexity. Start simple, then add one variable at a time. Each example must include explicit narration of intent: explain not just what the code or steps do, but why they are done that way. Avoid toy examples that do not resemble real usage. Where a concept has multiple valid approaches, show the most common one first and note alternatives afterward.

5. **Gotchas and common misconceptions:** Proactively address the mistakes and false assumptions readers are most likely to bring to the subject. Frame these as natural misunderstandings, not failures. Use "A common assumption here is..." or "It might seem like... but actually..." constructions to acknowledge the misconception charitably before correcting it.

6. **Reference summary:** Close with a scannable reference: a table, checklist, or short bulleted recap that distills the key points. This rewards readers who return to the document later and serves as a self-check for readers who just finished it.

## Tone and Voice

- **Professional but warm.** Write like a knowledgeable colleague explaining something they genuinely care about. The writing should feel inviting, not cold or terse, but never casual or imprecise.

- **Assume zero prior knowledge of the subject.** Every term, pattern, and concept specific to the topic being taught must be defined or explained before it is used. Do not assume the reader has encountered the subject before, even if it is common in the field. Prior knowledge of general programming or technical literacy is acceptable to assume; subject-specific knowledge is not.

- **Address the reader directly using "you."** This keeps the writing engaging and makes instructions and explanations feel personally relevant. "You can configure this by..." rather than "This can be configured by..."

- **Use rhetorical questions to anticipate confusion.** When a reader is likely to pause and wonder something, surface that question explicitly before answering it. "But what happens if the connection drops?" or "You might be wondering why this step comes before the previous one." This signals awareness of the reader's perspective and prevents confusion from accumulating silently.

- **No emojis.** Never, regardless of the audience, the platform, or the document type.

- **No em dashes.** Use commas, parentheses, colons, or sentence breaks to handle what an em dash would otherwise do.

- **No exclamation points.** Enthusiasm is expressed through clarity and usefulness, not punctuation.

- **No hedging as a default habit.** Use uncertain language ("might," "may," "approximately") only when genuine uncertainty exists. False precision is a problem; false timidity is also a problem.

## Sentence and Paragraph Style

- **Vary sentence length deliberately.** Use shorter sentences to land important points or transitions. Use longer compound sentences to build up context and connect related ideas. A short sentence after a long one creates emphasis.

- **Parenthetical asides for supplementary context.** Use parentheses to add clarifications or caveats that would interrupt the main sentence's flow if placed inline (for example, noting that a behavior applies only to a specific version, or pointing the reader to a related section).

- **One idea per paragraph.** Each paragraph should develop a single point. When a new idea begins, start a new paragraph. Dense paragraphs that cover multiple distinct points are harder to scan and re-read.

- **Active voice by default.** Passive voice is acceptable when describing how a system behaves ("the request is queued") or when the actor is genuinely irrelevant. Everywhere else, use active voice.

- **Introduce terms before using them.** Never use an acronym, proper noun, or domain-specific term without first defining it at least once in the document.

## Teaching Techniques

- **Analogy before definition.** When introducing a new concept, reach for an analogy from an unrelated, familiar domain first. Only after the analogy is established should the formal definition or technical description follow. The analogy provides a cognitive hook; the definition adds precision.

- **Explicit narration in examples.** Code samples and step-by-step instructions must be accompanied by explanation of intent. "This line opens a connection to the database, rather than querying it directly, because..." is more educational than a code block with a comment. Narrate the why, not just the what.

- **Progressive complexity in examples.** Begin with the simplest valid version of a concept, then extend it. Do not start with a fully featured, production-ready example. Walk the reader through incremental additions so that each new piece is motivated by a visible limitation in the previous version.

- **Name and defuse misconceptions directly.** When a reader is likely to arrive with a false assumption, name it explicitly. This validates the reader's natural reasoning while correcting the record. "It is easy to assume X, because Y. In practice, however, Z."

- **Signpost transitions between sections.** When moving from one stage of the arc to the next, briefly orient the reader. "Now that the mental model is in place, let us look at how this works in practice." This keeps the reader aware of where they are in the overall structure.

- **Note common alternatives without derailing.** When there is more than one valid approach to something, acknowledge alternatives briefly after establishing the primary approach. Do not bury the reader in options before they understand the main path.

## Section Headings and Organization

- Use a clear hierarchical heading structure. Major sections are at heading level two; subsections at heading level three. Do not go deeper than three levels without a strong reason.

- Headings should describe what the reader will find in that section, not just name the topic. "How the request lifecycle works" is more useful than "Request lifecycle."

- The document should be readable top-to-bottom on the first pass and skimmable by heading on subsequent passes.

## When to Use This Skill

Use this skill when asked to write or help draft:
- Concept explainers or topic introductions (what is X, how does X work)
- Onboarding documentation for internal systems, codebases, or workflows
- Step-by-step tutorials or how-to guides
- API or library walkthroughs intended for developers new to the interface
- Public-facing technical blog posts or documentation with a teaching intent
- Any technical document where the primary goal is reader understanding, not persuasion

## When NOT to Use This Skill

- Documents whose primary goal is to convince stakeholders to adopt a course of action (use the persuasive-writeup skill instead)
- Reference documentation that is meant to be consulted, not read linearly
- Code comments or inline documentation
- Meeting notes, status updates, or brief Slack messages
