# A Dog's Life — Architecture

## Purpose

This document captures the overarching architectural principles of **A Dog's Life**.

It is not a technical reference. Its purpose is to guide future decisions as the game grows.

---

## 1. Responsibilities Belong Where They Are Owned

Behaviour should belong to the system responsible for it, not simply to the object currently affected by it.

The Dog owns behaviour intrinsic to the Dog. NPC movement belongs to NPC movement. Dialogue presentation belongs to dialogue presentation. Investigation feedback belongs to Investigation.

Where something appears, or which entity it affects, does not automatically determine who owns it.

> **Ask who owns the responsibility, not where the code would be convenient to put.**

---

## 2. Entities Are Composed from Capabilities

Game-world entities such as the Dog and NPCs act as composition and coordination points.

Specialised capabilities should remain focused rather than accumulating inside a single entity script.

Conceptually:

```text
NPC
├── Movement
├── Conversation
├── Visual / Animation
└── Other capabilities
```

The entity represents **what the thing is**. Its components represent **what it can do**.

Prefer composition over large inheritance structures or all-purpose entity scripts.

---

## 3. Reusable Systems Report; Authored Context Decides

Reusable mechanics should know what happened without knowing what that event means to the story.

For example:

```text
Scent trail completes
        ↓
Section is informed
        ↓
Section decides what completion causes
```

The Scent system should not know that a particular DigPoint must unlock. An EventTrigger should not know the narrative consequence of being triggered.

> **Reusable systems determine what happened. Authored context determines what happens because of it.**

Sections therefore act as the primary coordination boundary for local authored gameplay.

---

## 4. Lifetime Determines Scope

Gameplay behaviour should remain local by default.

A responsibility should move to Act/session/global scope only when its lifetime genuinely requires it.

State that must survive section unloading belongs outside the section. Ordinary gameplay behaviour does not.

> **Global only when the lifetime genuinely needs to be global.**

Persistence systems should store state without understanding its gameplay meaning. The mechanic that owns the state remains responsible for interpreting and restoring it.

Authored scene configuration remains the default; persisted state overrides it when appropriate.

---

## 5. Architecture Follows the Game

Architecture exists to support the game, not the other way around.

Build the smallest reusable responsibility required by current gameplay.

Do not introduce frameworks, managers, inheritance hierarchies or abstractions solely because they may become useful later.

Repeated real requirements should drive new architectural layers.

> **Solve demonstrated problems rather than hypothetical ones.**

---

## Supporting Conventions

A few conventions support these principles:

- **Scene hierarchy expresses ownership.** Spatial or behavioural relationships should be represented through composition where practical.
- **Signals announce events.** They communicate that something happened without requiring the sender to know the consequence.
- **Direct calls coordinate known collaborators.** Explicit relationships do not need to be artificially decoupled.
- **Authored data, runtime behaviour and presentation remain distinct where that separation provides value.**
- **Generic interaction stays generic.** The Dog coordinates contextual interaction; individual interactables own what their interaction actually does.

These are guidelines rather than rules that must be forced onto every feature.

---

## Areas to Revisit

The following should be watched as the project grows, but do not currently justify architectural work:

- Rename the historical `investigate` input action to the more accurate `interact`.
- Reconsider whether the currently implicit interactable contract needs formalising if interaction types grow substantially.
- Remove prototype/test naming and structures as production scenes replace them.
- Watch section scripts for excessive narrative orchestration; introduce a section-local coordinator only if real authored complexity demands one.
- Watch Dog and NPC root scripts for responsibility growth; specialised behaviour should continue moving into focused components where appropriate.
- Revisit small behavioural integration details, such as NPC movement/conversation coordination, when production characters and animation make them meaningful.

---

## Guiding Principle

> **Build the smallest reusable responsibility the game actually needs, put it where that responsibility naturally belongs, keep authored meaning in the authored context, and introduce new architectural layers only when real gameplay demonstrates the need.**

The architecture should remain understandable, pragmatic and subordinate to the needs of **A Dog's Life**.
