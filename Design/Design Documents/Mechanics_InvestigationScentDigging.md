# Investigation, Scent & Digging

## Core Principle

Investigation represents the dog **actively perceiving and interpreting the world**, rather than simply displaying internal thoughts.

The exploration language is:

**Move → Notice → Investigate → Perceive → Interpret → Act**

An investigation may produce a thought, scent, discovery or other interaction. `InvestigationPoint` therefore remains a broad interaction system rather than becoming a dedicated scent system.

## Scent

Scent visualises information the dog can perceive but the player cannot.

Three initial scent forms are:

* **Isolated** — a contained/localised cloud.
* **Faint** — sparse, subtle wisps.
* **Strong** — dense, prominent scent.

Scent properties remain independent:

* **`scent_type`** — visual form/intensity.
* **`duration`** — how long it remains perceptible.
* **`colour`** — potentially communicates identity, familiarity or association.
* **`creates_trail`** — whether the scent remains local or forms a trail.

This allows combinations such as a faint scent forming a trail or a strong scent remaining localised.

The emerging visual language is:

**Form/density → character or strength of scent**
**Colour → association or identity**
**Trail → something that can be followed**

These meanings should be learned naturally through play rather than explained through explicit UI.

## Scent & Digging

Scent and digging are **independent mechanics that can interact**.

Possible relationships include:

**Scent → Dig**
**Dig → Scent**
**Scent → Other Discovery**
**Dig → Other Discovery**

This allows loops such as:

**Investigate → Scent → Follow → Investigate → Dig → Discover**

without making that sequence mandatory.

They can also support optional exploration, including hidden discoveries or Act-specific Easter eggs that reward curiosity rather than conventional collectible hunting.

## Interaction Philosophy

Mechanics should encourage **attention and deliberate interaction**, not repetitive checking or button-spamming.

Scent should therefore not function as a global scanner that rewards repeatedly pressing a smell button while travelling.

More broadly:

> **No core exploration mechanic should incentivise repetitive button-spamming as the optimal way to experience the world.**

The dog's abilities should feel like **ordinary canine behaviours through which the player experiences the world differently**, not RPG powers or abstract game systems.

Movement, investigation, scent and digging should support the game's restrained pace, atmosphere and narrative rather than compete with them.

### Notes:
Repeat investigations normally reuse the original scent properties. A repeat investigation may optionally override scent_type when the dog perceives something new or more clearly. Other scent properties remain shared unless a future design need justifies changing them.