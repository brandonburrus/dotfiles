---
name: persuasive-writeup
description: Write persuasive technical documents using an evidence-driven, professionally authoritative writing style that builds business cases before technical cases and systematically addresses objections
---

## Purpose

Generate persuasive technical writeups — spikes, proposals, RFCs, ADRs, migration plans, or vendor evaluations — that convince engineering and business stakeholders to adopt a recommended approach. The writing style is modeled on a specific voice: professional, confident, evidence-driven, and structured to make the recommendation feel like the inevitable conclusion of the evidence.

## Document Structure

Follow this argumentative arc consistently:

1. **Frame the investigation** — Open with 1-2 paragraphs of context: what is being investigated, why, and what questions need answering. If specific questions or goals drive the investigation, enumerate them explicitly up front. Optionally include a table of contents for longer documents.

2. **Establish the pain** — Document the current state's problems with specific, concrete evidence. Use real data: developer hours lost, dollar costs, error rates, manual process descriptions, specific frustrations developers experience. Make the pain tangible and quantified wherever possible. Each bullet should describe a real, specific problem — not a vague complaint.

3. **Present the solution** — Introduce the proposed tool, technology, or approach. Explain what it is and how it works at a conceptual level before diving into details. Connect each capability back to a specific pain point from the previous section.

4. **Demonstrate feasibility** — Show through code samples, architectural walkthroughs, configuration examples, and detailed technical analysis that the solution actually works for the team's specific use cases. Code examples should be realistic and relevant to the team's actual codebase — not toy examples.

5. **Address risks and objections** — Proactively identify and address likely concerns: migration complexity, learning curves, cost, compatibility, compliance. Use a concession-then-counter pattern when acknowledging tradeoffs ("However... the tooling around Terraform is still widely considered the best in industry"). Include side-by-side before/after code comparisons when demonstrating simplicity gains.

6. **Define a migration path** — Always end with concrete, phased implementation steps. Break large changes into discrete, ordered phases (pilot then expand, incremental then full, multi-phase rollout). This reduces perceived risk and demonstrates operational maturity. Never leave the reader wondering "but how would we actually do this?"

## Tone and Voice

- **Professional but accessible.** Avoid overly formal academic language, but never become casual or colloquial. Write like a senior engineer addressing a mixed audience of engineers, architects, and business stakeholders.

- **Confident but not dogmatic.** Present recommendations as the logical conclusion of evidence, not as predetermined opinions. Hedging language ("would," "should," "approximately") should be used strategically — only where genuine uncertainty exists — not as a general habit of timidity.

- **Empathetic toward the reader.** Anticipate questions, objections, and knowledge gaps. Create dedicated sections that address likely reader concerns before they can be raised (e.g., "What about Karma?", "Developer Learning Curve", "Would this support our existing hierarchy?").

- **Free of emotional language.** No enthusiasm markers, exclamation points, or superlatives. Persuasion is entirely logical and evidential, never emotional. Let the evidence speak for itself.

- **No explicit recommendation statement.** Do not conclude with "therefore we should do X." The recommendation should be embedded in the structure of the document itself — the evidence and analysis should make the conclusion self-evident.

## Sentence and Paragraph Style

- **Long, information-dense sentences.** Favor compound-complex sentences that use multiple clauses joined by commas, dashes, and parenthetical insertions. Chain ideas together within single sentences using "and" conjunctions rather than breaking them into many short sentences.

- **Parenthetical asides.** Use parentheticals frequently to provide caveats, clarifications, or alternative context without breaking the main sentence flow (e.g., "(if you want to know more, talk to Karl Leudke)", "(this does not affect client-side connections as those are measured by MAUs, covered in the next section)").

- **Active voice predominates.** Use passive voice only when describing system behavior or current state. Action-oriented verbs drive the writing: "migrate," "shift," "empower," "enable," "reduce," "resolve," "decouple."

- **"This enables..." / "This would enable..."** as a bridging construction to connect a feature to its benefit.

- **"Note that..." prefixed bullets** to call out important edge cases, exceptions, or operational considerations. This demonstrates thoroughness and risk awareness.

## Persuasive Techniques

- **Quantify everything possible.** Dollar figures, developer hours, compute costs, pricing formulas, MAU counts, quarterly data. Show your math. Numbers are more persuasive than adjectives.

- **Use contrast as the dominant framework.** Structure the entire document around "painful now" vs. "better future." Every section should reinforce this contrast.

- **Stack evidence through accumulation.** When listing benefits, certifications, features, or capabilities, deliberately stack them to create an overwhelming impression. Pile certification after certification, feature after feature.

- **Use code as evidence.** Inline code samples serve as proof-of-concept, making abstract claims tangible. Side-by-side before/after code comparisons are the most powerful visual persuasion tool — make the "after" state visually simpler and more appealing.

- **Front-load business value.** Present cost analysis, compliance posture, and business impact before the technical deep-dive. This ensures decision-makers stay engaged and the technical audience understands the stakes.

- **Use business-value language when addressing stakeholders.** Employ terms like "release velocity," "blast radius," "break-glass scenarios," "compliance posture," and "data-driven decision making" to connect technical decisions to business outcomes.

- **Ground analysis in internal data.** Reference team-specific metrics, internal tool names, actual repo names, Rally/Jira ticket data, and billing analytics. This makes arguments feel directly applicable rather than theoretical.

## Word Choice

- Use precise domain-specific terminology without over-explaining it. This signals expertise and targets an audience of peer engineers.
- Hedging words ("approximately," "roughly," "might") appear only in cost estimates or where genuine uncertainty exists.
- Avoid filler phrases, throat-clearing, and unnecessary qualifiers.
- Link to official documentation, pricing pages, and relevant PRs/tickets as supporting material rather than over-relying on external references.

## Section Headings and Organization

- Use clear hierarchical heading structure with consistent heading levels.
- Major sections are clearly demarcated; logical flow is always top-down from high-level to detailed.
- Shift register subtly by section: business value and cost sections use more accessible language; technical implementation sections assume deeper engineering knowledge.

## When to Use This Skill

Use this skill when asked to write or help draft:
- Technical spike documents
- Technology evaluation or comparison documents
- Vendor assessments
- Migration proposals
- RFCs or ADRs recommending a specific approach
- Any technical document where the goal is to persuade stakeholders to adopt a recommended course of action

## When NOT to Use This Skill

- Pure documentation or reference material with no persuasive intent
- Casual Slack messages or brief status updates
- Code comments or inline documentation
- Meeting notes or agendas
