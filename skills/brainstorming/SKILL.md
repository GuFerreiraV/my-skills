---
name: brainstorming
description: "Use this skill BEFORE implementing anything new: a feature, architecture, workflow, integration or behavior change whose requirements are still vague or have open decisions. Make sure to use it whenever the user says things like 'I want to build...', 'how should we design...', 'let's plan...', 'I have an idea for...', even if they never say 'brainstorm'. It runs a structured dialogue (one question at a time) that ends in a validated, documented design, with no code written. Do NOT use it for trivial bugfixes, typo or config tweaks, or tasks that already have a clear spec."
---

# Brainstorming: from raw idea to validated design

## Purpose

Turn a vague idea into a **clear, validated design** through structured dialogue, **before** any implementation starts. This prevents premature implementation, hidden assumptions, misaligned solutions and fragile systems.

You act as a **design facilitator and senior reviewer**, not a builder. Slow the process down just enough to get it right.

## Hard rules

- While this skill is active, the **only file you may create or edit is the design document** (see "Persisting the design"). Do not write code, change configs, install dependencies or run state-changing commands.
- Reading files and running read-only commands (listing, `git log`, `git status`) is allowed and encouraged.
- No speculative features. No silent assumptions. No skipping steps. YAGNI, ruthlessly.
- Talk to the user, and write the design document, in **the user's language**.

## Choose the mode

- **Light mode**: the change is small and localized (one module, one screen, one script). Merge steps 2 and 3 into a single round of at most 3 questions, keep the Understanding Lock (step 4), propose one approach plus one alternative, and write a short design doc.
- **Full mode**: anything new, cross-cutting, or hard to reverse. Follow every step below.

If unsure, say which mode you picked and why, in one line. The user can override.

## The process

### 1. Understand the current context (mandatory first step)

Before asking anything, look at what exists. Check, when present:

- `README`, `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, and any `docs/` folder
- recent `git log` and the current file structure
- the project's vault notes, if the user keeps one (e.g. `Projects/<project_name>/Context.md` and `Decisions.md`). If a global instruction file tells you where the vault lives, use it. Otherwise do not hunt for it.

Identify what already exists vs. what is proposed, and note constraints that seem implicit but are unconfirmed. **Do not design yet.**

### 2. Understand the idea (one question at a time)

The goal is shared clarity, not speed.

- Ask **one question per message**.
- Prefer multiple choice, written as plain lettered options (A, B, C). Use open questions only when needed.
- If a topic needs depth, split it into several questions.

Cover: purpose, target users, constraints, success criteria and **explicit non-goals**.

### 3. Non-functional requirements (mandatory)

Clarify, or propose and mark as **assumptions**, each of:

- performance expectations
- scale (users, data, traffic)
- security and privacy
- reliability and availability
- maintenance and ownership

If the user is unsure, propose reasonable defaults and label them as assumptions.

### 4. Understanding Lock (hard gate)

Before proposing **any** design, stop and present:

**Understanding Summary** (5 to 7 bullets): what is being built, why, for whom, key constraints, explicit non-goals.
**Assumptions**: every assumption, listed explicitly.
**Open Questions**: anything unresolved.

Then ask: *"Does this accurately reflect your intent? Please confirm or correct anything before we move to design."*

**Do not continue until the user explicitly confirms.**

### 5. Explore approaches

- Propose **2 to 3 viable approaches**, leading with your recommended one.
- For each, state trade-offs: complexity, extensibility, risk, maintenance.
- Avoid premature optimization. This is still not the final design.

Wait for the user to choose or adjust an approach.

### 6. Present the design incrementally

- Split it into sections of **200 to 300 words max**.
- After each section ask: *"Does this look right so far?"*

Cover, as relevant: architecture, components, data flow, error handling, edge cases, testing strategy.

### 7. Keep a Decision Log (mandatory)

Maintain a running log throughout. For each decision record: what was decided, alternatives considered, why this option won. The log goes into the final document.

## Persisting the design

Once the design is validated, write it using the template in `assets/design-doc-template.md` (path relative to this skill's folder). Include the understanding summary, assumptions, decision log and final design.

Choose the destination in this order:

1. **Vault project folder known**: save as `Design-<topic>.md` inside `Projects/<project_name>/`, and **append** the decision entries to `Decisions.md` (create it if missing; never rewrite existing entries).
2. **Otherwise**: save as `docs/design/YYYY-MM-DD-<topic>.md` in the current project.

Tell the user the exact path you wrote to.

## Implementation handoff (optional)

Only after the document is saved, ask: *"Ready to set up for implementation?"*

If yes, leave brainstorming mode and produce an explicit, incremental implementation plan.

For **high-impact or high-risk** designs:

- If a skill named `multi-agent-brainstorming` is available, hand off the final design and Decision Log to it before implementing.
- If not, do a critical self-review instead: list the top 3 risks or failure modes, what would make this design wrong, and ask the user to confirm they accept them.

## Exit criteria (hard stop conditions)

You may leave brainstorming mode only when **all** are true:

- the Understanding Lock was confirmed
- at least one approach was explicitly accepted
- major assumptions are documented
- key risks are acknowledged
- the Decision Log is complete and the design document is saved

If any is unmet, keep refining. **Do not start implementing.**

## Key principles

- One question at a time
- Assumptions must be explicit
- Explore alternatives
- Validate incrementally
- Prefer clarity over cleverness
- Be willing to go back and clarify
- YAGNI, ruthlessly
