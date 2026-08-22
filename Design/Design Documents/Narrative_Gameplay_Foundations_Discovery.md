# Narrative Gameplay Foundations - Discovery Decisions

> Working design/architecture decisions made before defining the next
> milestone and tickets.

## 1. Dialogue System

### One system, two presentation modes

Use **one conversation system** with two presentation modes.
Presentation belongs to the **conversation**, not the NPC.

#### Ambient Dialogue

-   For incidental/world-building exchanges and short snippets.
-   Usually initiated with `[E] Talk`, but may also be event-triggered.
-   Dog movement is locked for the duration.
-   Dialogue appears spatially near/above the speaking animal.
-   Lines progress automatically using an estimated reading time.
-   Initial timing approach: roughly **2 seconds per 5 words**, with a
    sensible minimum; tune through playtesting.
-   Short, concise and deliberately \"in the moment\".

#### Focused Dialogue

-   For narratively important conversations.
-   May begin through `[E] Talk` or automatically through an authored
    event.
-   Dog movement is locked for the duration.
-   Characters retain their established left/right staging during the
    focused sequence.
-   Camera smoothly reframes/zooms modestly (around 10% as an initial
    test value).
-   A black cinematic dialogue bar appears at the bottom of the screen.
-   Dialogue presentation comes from the speaker's side of the
    composition: left-side character from the left, right-side character
    from the right.
-   Player presses **E** to advance each line.
-   After completion, the dialogue presentation closes, camera returns
    and movement unlocks.
-   If characters later move/cross sides while travelling together,
    dialogue can use **Ambient** presentation instead.

### Speaker presentation

-   Every dialogue line explicitly identifies its speaker.
-   Avoid default `Dog:` / `Vole:` style name labels to preserve
    immersion.
-   Speaker identity should instead be communicated through
    presentation:
    -   spatial position;
    -   subtle speaker-specific text colour/tint where useful;
    -   eventually a brief animal vocal cue such as a bark, squeak or
        hoot.
-   Colour alone should not be the only speaker cue.
-   Content identifies **who** speaks; presentation determines
    **where/how** their line appears.
-   Conversation participants should resolve to the actual runtime
    characters so spatial presentation can use their positions. Exact
    Godot implementation remains to be designed.

### Dialogue content and progression

-   Dialogue is **linear and authored**.
-   The player never chooses what the dog says.
-   The player guides the dog's experience; dialogue reveals the dog's
    authored character.
-   Conversation data contains ordered lines (`speaker + text`).
-   Avoid speculative per-line properties such as custom duration,
    sound, emotion or camera instructions until demonstrated as
    necessary.

### Conversation sequences

-   NPCs can have a finite authored sequence of conversations.
-   First interaction uses Conversation 1, later interaction
    Conversation 2, etc.
-   Conversations in the same sequence may use different presentation
    modes.
-   Once the authored sequence is exhausted, `[E] Talk` disappears.
-   No generic \"repeat final conversation\" behaviour.
-   If an NPC later gains new dialogue because the story changes, that
    should be an explicit external state/event change.

### Conversation consequences

-   The conversation system reports completion but **does not own story
    consequences**.
-   Section/Act logic decides what completion means (e.g. Badger begins
    following, route unlocks, world changes).
-   Principle: **conversation completion is an event; consequences live
    outside the conversation system.**

------------------------------------------------------------------------

## 2. Narrative Events

### EventTrigger

Create a small reusable **EventTrigger**: - `Area2D` detects the dog
entering an authored area. - Emits a `triggered` event/signal. - Can
optionally be one-shot. - It does not contain story-specific logic.

### Story sequencing

Use **scene/section-specific orchestration**, not a generic
cutscene/narrative sequence engine. - Local section logic responds to
EventTrigger and coordinates the relevant systems. - Example: trigger
-\> lock/reframe -\> conversation -\> completion -\> NPC behaviour
change -\> resume. - Reusable systems retain their own
responsibilities. - Important narrative moments are few enough (roughly
a dozen to \~18 Focused conversations expected) that explicit authoring
is appropriate. - Extract reusable sequencing later only if genuine
repetition demonstrates the need.

------------------------------------------------------------------------

## 3. Sections and Navigation

### World structure

-   Acts are composed of finite authored sections/scenes.
-   Navigation is an **authored mixture**:
    -   generally traversable backwards and forwards within an Act;
    -   major story boundaries may permanently block/close earlier areas
        where appropriate.

### SectionTransition

Create a reusable **SectionTransition**: - Detects the dog entering an
exit/transition area. - Requests the destination section and destination
entrance. - Responsible for section loading/transition, **not
gameplay-state persistence**.

### EntryPoint

Destination sections contain stable/named **EntryPoints** so transitions
target an entrance rather than hard-coded coordinates.

------------------------------------------------------------------------

## 4. Act-Local State and Persistence

### Required behaviour

Revisiting a section must restore it as the dog left it.

Examples: - used/exhausted InvestigationPoints retain their
investigation count/status; - exhausted DigPoints remain exhausted and
their holes remain visible; - completed scent trails remain completed; -
one-shot events remain triggered; - exhausted NPC conversation sequences
remain exhausted; - untouched objects remain usable in their authored
initial state.

**Visual restoration is part of state restoration.**

### ActState

Use a small **Autoload `ActState`** as the Act-local state store.

Responsibility boundary:

-   `ActState` -\> stores/retrieves data.
-   `InvestigationPoint` -\> knows what its state means and
    saves/restores it.
-   `DigPoint` -\> knows what its state means and saves/restores it.
-   `Conversation/NPC` -\> knows what its state means and saves/restores
    it.
-   `EventTrigger` -\> knows/restores whether it has fired where
    applicable.
-   `SectionTransition` -\> loads sections; does not manage object
    persistence.

`ActState` must remain **storage, not intelligence**. It should not
understand investigation, digging, dialogue or story semantics.

### When state is recorded

Stateful objects update `ActState` **immediately when meaningful state
changes**, rather than the section gathering all state when it unloads.

Lifecycle: 1. First visit -\> no stored state -\> authored defaults. 2.
Interaction/event occurs -\> object updates its state -\> state
recorded. 3. Section unloads -\> no special persistence sweep required.
4. Section reloads -\> objects restore their state and visuals.

### Scope

-   State is primarily **Act-local**, not a general cross-Act narrative
    system.
-   Acts are intended to be self-contained.
-   Rare cross-Act requirements, if any, should be handled as
    exceptional cases later.
-   This is not yet a full disk save/load framework, though the data may
    later be useful to one.

### Stable IDs

-   Stateful authored objects require stable unique IDs that survive
    scene destruction/recreation.
-   IDs should live with the authored object/scene data and therefore be
    versioned in Git.
-   A separate generated/documented ID registry may be useful for
    **visibility, auditing and understanding ID generation**, but should
    not be the authoritative source.
-   Exact ID-generation/format rules remain to be designed.

------------------------------------------------------------------------

## 5. NPC Movement

NPC movement foundation needs two principal behaviours.

### Ambient / Idle

-   NPCs can meander naturally before/around interactions.
-   Examples: short walks, pauses, turns, wing flutters.
-   Keep behaviour authored/simple; no need for sophisticated AI or
    schedules.

### Follow

For companions such as the Badger: - Follows behind the dog with a
comfortable spacing. - Starts moving when the dog moves sufficiently far
away. - Stops when an appropriate following distance is restored. -
Generally walks when the dog walks and settles when the dog stops. - Can
catch up when necessary. - Should **not** mirror the dog's movement
exactly; some natural lag/independence is desirable.

### Behaviour switching

-   Avoid separate `AmbientNPC` and `FollowerNPC` architectures.
-   NPC behaviour can switch modes through external story/section logic.
-   Example: Badger conversation completes -\> section logic changes
    Badger from Ambient/Stationary to Follow.
-   More complex choreography/pathfinding should wait until Act I
    content demonstrates a concrete need.

------------------------------------------------------------------------

## 6. Overall Architecture Principles

-   Build reusable **capabilities**, but keep story meaning in authored
    section logic.
-   Prefer lightweight systems over speculative global managers or
    generic cutscene engines.
-   Acts are largely self-contained.
-   Exploration mechanics, dialogue, NPC behaviour and events report
    outcomes; external local logic determines narrative consequences.
-   The next milestone is intended to bridge the completed exploration
    prototype into actual authored narrative gameplay before full Act I
    production.
