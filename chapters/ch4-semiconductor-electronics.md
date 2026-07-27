---
title: "Ch 4 — Semiconductor Electronics"
parent: Chapters
nav_order: 5
---

# Chapter 4 — Semiconductor Electronics

> ME 435 · Mechatronics — Self-study companion notes.
> **Read these alongside the lecture slides.** The slides carry the photos, animations, band diagrams, and circuit figures; these notes carry the explanations and the *reasoning* — the "why does this actually work" story we build in class. This chapter spans both decks: **4-1 Semiconductor Electronics (Working Principle)** and **4-2 Semiconductor Electronics (BJT and MOSFET)**.

## Learning Objectives

By the end of this chapter you should be able to:

- Explain **why mechatronics needs semiconductors** — that controlling a motor means controlling electrons, and the switch that does it (the transistor) is a semiconductor device.
- Distinguish **conductors, insulators, and semiconductors** using the **energy-band** picture (valence band, conduction band, band gap), and explain what a **hole** is.
- Describe **doping**: how **n-type** (donor) and **p-type** (acceptor) impurities create majority carriers, and why a doped crystal stays **electrically neutral**.
- Explain the **pn-junction diode** — the depletion region, forward vs. reverse bias, and why it acts as a **one-way valve (rectifier)** — and read its **I–V curve**, forward drop, and ratings.
- Use the **Zener diode** in reverse breakdown as a **voltage regulator**, and analyze the series circuit with KVL and Ohm's law.
- Explain the **BJT** as a **current-controlled** amplifier/switch: how a thin, lightly-doped base lets a small base current steer a large collector current, and what **saturation (fully ON)** means.
- Explain the **MOSFET** as a **voltage-controlled** switch: how a gate voltage past **threshold** forms an inversion channel, and why *no current flows into the gate*.
- Close the loop back to Chapter 3 by recognizing the **H-bridge switches Q1–Q4 as MOSFETs**.

---

## 1. From Motors to Semiconductors

In Chapter 3 a motor spun because current flowed through the **U-V-W** coils in a precise, timed sequence. But *something* had to switch that current on and off, in the right order, thousands of times a second. That something is a **transistor** — and a transistor is a lump of **semiconductor**.

Look at the **H-bridge**, the circuit that drives a DC motor forward and backward:

| Switch pair closed | Current through motor | Result |
|---|---|---|
| Q1 + Q4 | left → right | spins one way |
| Q2 + Q3 | right → left | spins the other way |

Each switch **Q1–Q4 is a transistor** — an electronic switch built from semiconductor material, with **no moving parts**. This is the whole reason for the chapter:

> **The thesis of Chapter 4:** to control a motor (or *any* actuator), we must control **electrons**. The device that lets a small electrical signal control a large flow of electrons — with no mechanical contact — is the **semiconductor switch**. Master the semiconductor and you can build every switch, amplifier, sensor interface, and logic gate in the rest of the course.

We'll build up from the raw physics (what even *is* a semiconductor?) to the two workhorse transistors — the **BJT** and the **MOSFET** — and then return to this exact H-bridge and name its switches. Everything connects back here.

---

## 2. What Makes a Material Conduct?

### 2.1 Conductors vs. Insulators — It's About Free Electrons

> **Group challenge (from the slides):** *Between metal and rubber, which conducts electricity better? And why doesn't rubber conduct?*

Metal wins — everyone knows that. The useful question is *why*. **Current is the movement of charge — specifically, the movement of free electrons.** So the real question is: *does the material have electrons that are free to move?*

| | **Conductor** | **Insulator** |
|---|---|---|
| Example | metals: copper, aluminum, gold | ceramic, glass, rubber |
| Electrons | loosely held → **free to move** | tightly bound to their atoms |
| Resistance | **low** — electricity flows easily | **high** — electricity barely flows |

In an insulator, every electron is locked in orbit close to its atomic nucleus; it can't wander, so no current. In a conductor, the outermost electrons break free of any single atom and drift through the whole material — that drift *is* the current.

> **Group challenge:** *So how could you make an insulator like rubber conduct better?* → **Give its electrons enough energy to break free** — by adding **heat**, shining **light**, or mixing in **impurities (doping)**. That last trick is exactly how semiconductors are made useful.

### 2.2 The Energy-Band Picture

Physicists sharpen "free to move" into two energy bands every solid has:

| Band | Meaning |
|---|---|
| **Valence band** | the highest-energy band where electrons are still **bound** to atoms — they **cannot** carry current here |
| **Conduction band** | the band where electrons are **free** to move — electrons here **do** carry current |

Between them sits the **band gap** — the energy an electron must gain to jump from "bound" up to "free." The **size of that gap** is the entire difference between the three material classes:

| Material | Band gap | Consequence |
|---|:---:|---|
| **Conductor** | none / overlapping | electrons are *already* free → always conducts |
| **Insulator** | **large** | electrons can't get across → (almost) never conducts |
| **Semiconductor** | **small** | electrons cross *if given a little help* → conducts **on demand** |

> 💡 **The band gap is the whole story.** A conductor's electrons live in the conduction band by default. An insulator's gap is a wall too tall to climb. A **semiconductor's gap is small** — a little voltage, heat, or light lifts electrons across it. That "conducts only when we tell it to" behavior is precisely what makes a **switch** possible.

### 2.3 Semiconductors — Electrons *and* Holes

Give a semiconductor a nudge (voltage, heat, or light) and an electron jumps the small gap into the conduction band, free to drift under an **electric field** and make current. But it leaves something behind: an **empty spot in the valence band, called a hole.**

The hole is not just "nothing." A neighboring bound electron can slide over to fill it — which leaves a *new* hole where that electron came from. Repeat, and the empty spot appears to **travel through the crystal in the direction opposite to the electrons.** We treat that moving vacancy as a real, mobile, **positive** charge carrier.

> 💡 **Two carriers, not one.** A metal conducts with electrons only. A semiconductor conducts with **two** kinds of carrier: **electrons** (negative) drifting one way, and **holes** (positive) drifting the other. Holes are the accounting trick that lets us track "the motion of the missing electron" as if it were a particle — and, as we'll see, doping lets us *choose* which carrier dominates.

**A quick word on the electric field.** What actually pushes these carriers? An **electric field** — a region around a charge where another charge feels a force. It's a **vector field** (magnitude *and* direction), defined as force per unit charge:

$$\boxed{E = \frac{F}{q}}$$

- $E$ — electric field (N/C, equivalently V/m)
- $F$ — force on the charge (N)
- $q$ — the test charge (C)

By convention the field points **from + toward −**, so a positive charge is pushed along the field and a **negative** charge (an electron) is pushed **against** it. Keep this direction rule in mind — every diode and transistor below is really a story about *which way the field pushes electrons and holes.*

**Why silicon?** Common semiconductors are **silicon (Si)** and **germanium (Ge)**. Silicon dominates for two reasons the slides stress:

- **Economics** — silicon comes from sand (silica), which is absurdly cheap and abundant.
- **Physics** — its band gap is *just right*: not so small it conducts uncontrollably, not so large it never conducts. That "Goldilocks" gap is what lets silicon work as a switch.

---

## 3. Doping — Engineering the Carriers

Pure ("intrinsic") silicon at room temperature has very few free carriers, so it barely conducts. **Doping** fixes that: we mix in a tiny amount of a different element to *deliberately* add electrons or holes.

### 3.1 The Silicon Lattice — Four Hands

> **Analogy (from the slides):** picture a silicon atom as a **person with four hands.** Silicon has **4 valence electrons**, and to be stable it "wants" 8 (the octet rule). So each silicon atom **shakes hands with four neighbors** — sharing one electron with each in a **covalent bond.** Every hand is occupied; no hand is left free.

With all bonds satisfied, pure silicon has almost no free carriers → **low conductivity**. Doping intentionally **breaks that perfect stability** — either by adding an atom with a spare electron, or one that's missing a bond.

### 3.2 N-type — the "Five-Handed Friend" (Donor)

Replace an occasional silicon atom with a **Group-V** element — **phosphorus (P), arsenic (As), or antimony (Sb)** — which has **5 valence electrons**, a "five-handed friend." Four hands make the normal covalent bonds; the **fifth electron has no bond to join**, so it's only loosely attached. With very little energy it breaks away and enters the conduction band, free to carry current.

- The impurity **donated** a free electron → it's called a **donor**.
- **Electrons are the majority carriers.** ("N" for **negative.**)

### 3.3 P-type — the "Three-Handed Friend" (Acceptor)

Now replace a silicon atom with a **Group-III** element — **boron (B) or gallium (Ga)** — which has only **3 valence electrons.** Three hands make bonds; the **fourth bond is left empty.** That missing bond **is a hole.**

- A neighboring electron can hop in to fill the hole — moving the hole to *its* old spot. So the hole drifts through the crystal.
- The impurity **accepts** an electron from a neighbor → it's called an **acceptor.**
- **Holes are the majority carriers.** ("P" for **positive.**)

### 3.4 The Question Everyone Gets Wrong

> **Group challenge:** *After doping, is the material positively charged? Negatively charged? Or neutral?*

**It stays electrically neutral.** This trips people up, so state it carefully: a phosphorus atom brought **one extra proton along with its one extra electron**; a boron atom brought **one fewer proton along with its one fewer electron.** The count of protons still equals the count of electrons.

> ⚠️ **"Majority carrier" ≠ "net charge."** N-type silicon has *extra mobile electrons*, but each came with a matching proton fixed in the lattice — so the whole crystal is **neutral.** Doping changes **which carrier is free to move**, not the total charge. Forgetting this makes the pn-junction (next) impossible to understand.

| | **N-type** | **P-type** |
|---|---|---|
| Dopant group | Group V (P, As, Sb) | Group III (B, Ga) |
| Nickname | donor | acceptor |
| Majority carrier | **electrons** (−) | **holes** (+) |
| Net charge of crystal | **neutral** | **neutral** |

---

## 4. The PN-Junction Diode

Take a piece of p-type and a piece of n-type silicon and join them. This single junction is the **diode** — the first real semiconductor device, and the foundation for every transistor after it.

### 4.1 The Junction and the Depletion Region

> **Group challenge:** *Put p-type (holes) next to n-type (electrons). What happens right at the boundary?*

At the interface, the two carrier populations **diffuse** into each other: electrons from the n-side wander into the p-side, holes from the p-side wander into the n-side. Where they meet, they **recombine** (an electron drops into a hole) and both vanish as carriers. This clears out a thin zone right at the junction — the **depletion region** — now empty of mobile carriers.

But recall §3.4: those dopant atoms are still there, now stripped of their mobile partner. The n-side near the junction is left with **fixed positive** donor ions; the p-side with **fixed negative** acceptor ions. Those exposed fixed charges create a **built-in electric field** (n-side + toward p-side −) and a **potential barrier** across the junction:

> 💡 **The junction builds its own wall.** Diffusion tries to mix the carriers; the exposed fixed ions build a field that pushes them back. The two effects reach a standoff — the **built-in potential barrier** — and net current stops. Nothing flows, *yet.* Everything the diode does is about whether an applied voltage **tears this wall down or builds it higher.**

### 4.2 Forward Bias — Tear the Wall Down

Connect the battery's **+ to the p-side and − to the n-side** (this is **forward bias**). The applied field opposes the built-in field and pushes majority carriers *toward* the junction:

- the depletion region **narrows**,
- the potential barrier **drops**,
- once the applied voltage overcomes the barrier, **current flows easily.**

For silicon, that barrier is about **0.6–0.7 V** — the diode's **forward voltage drop**, $V_F$. Below it, almost nothing flows; above it, current rises steeply.

### 4.3 Reverse Bias — Build the Wall Higher

Flip the battery: **+ to the n-side, − to the p-side** (**reverse bias**). Now the applied field *reinforces* the built-in field and pulls majority carriers *away* from the junction:

- the depletion region **widens**,
- the barrier **grows**,
- current is **blocked** — only a tiny **leakage current** trickles through.

### 4.4 The Payoff — a One-Way Valve

Put §4.2 and §4.3 together:

> **A diode passes current in only one direction** — from the **anode (p-side)** to the **cathode (n-side)** — and blocks it the other way.

Because it turns "both ways" into "one way," a silicon diode is also called a **rectifier.** This is the property behind every AC-to-DC power supply and every "protect the circuit from reversed polarity" trick.

> **Group challenge — "Which LED turns on?"** Given two LEDs wired in opposite orientations across the same source, only the **forward-biased** one lights. An LED is just a diode that emits light when forward current flows — so the direction of the junction decides everything. (Work this on the slide before reading on.)

### 4.5 The Diode Equation (Shockley)

The full current–voltage relationship of a diode is:

$$\boxed{I = I_S\left(e^{\frac{qV}{nkT}} - 1\right)}$$

| Symbol | Meaning |
|---|---|
| $I$ | diode current |
| $I_S$ | reverse **saturation current** (tiny — typically $10^{-12}$ to $10^{-6}$ A) |
| $V$ | voltage across the diode |
| $q$ | elementary charge, $1.602\times10^{-19}$ C |
| $k$ | Boltzmann constant, $1.381\times10^{-23}$ J/K |
| $T$ | temperature in kelvin |
| $n$ | ideality factor (1 for an ideal diode, ~1–2 in practice) |

Read the shape of the curve, not the algebra:

- **Reverse bias** ($V<0$): the exponential dies, leaving $I \approx -I_S$ — a minuscule leakage current. An *ideal* diode would pass nothing; a real one leaks a hair, and if you push the reverse voltage far enough it **breaks down** and conducts backward (the basis of the Zener diode, §5).
- **Forward bias** ($V>0$): past ~0.6–0.7 V the exponential explodes and current shoots up. *Ideally* current would start the instant $V>0$; really it needs to clear the **forward-drop** barrier first.

> ⚠️ **Don't memorize this equation for exams.** Its job is to justify the *shape* of the I–V curve (flat-then-steep forward, near-zero reverse). For circuit problems we almost always use the simple model: **"a conducting silicon diode drops ~0.7 V, period."**

### 4.6 Ratings — Every Diode Has Limits

A datasheet bounds where the diode is safe:

| Rating | Meaning |
|---|---|
| **Forward voltage $V_F$** | the ~0.6–0.7 V needed to overcome the barrier and conduct |
| **Max continuous forward current $I_F$** | the most forward current it can carry *continuously* without overheating |
| **Peak forward surge current** | a much larger current tolerated only for **milliseconds** |
| **Breakdown voltage $V_{BR}$** | the largest **reverse** voltage before it breaks down; exceed it and reverse current spikes → likely **instant, permanent failure** |

### 4.7 Worked Example — Is the Circuit Safe?

> **Setup:** a diode rated $I_{F,\max} = 300$ mA and $V_{BR} = 100$ V.

**Example 1 — 12 V DC source, 200 Ω load, diode forward-biased in series.**
The conducting diode drops ~1 V, so the resistor sees $12 - 1 = 11$ V:

$$I_F = \frac{12\ \text{V} - 1\ \text{V}}{200\ \Omega} = 55\ \text{mA}$$

$55$ mA is well under the $300$ mA limit, and there's no reverse voltage. **✅ Safe.**

**Example 2 — 120 V DC source, diode reverse-biased.**
In reverse, the diode must withstand the full $120$ V. But $V_{BR}=100$ V:

$$120\ \text{V} > V_{BR} = 100\ \text{V} \;\Rightarrow\; \textbf{breakdown}$$

The diode breaks down, a large reverse current flows, and it's likely destroyed. **❌ Unsafe.** (Forward-current is irrelevant here — the diode never conducts forward.)

> 💡 **The design lesson.** "Safe" means checking **both** limits against the actual operating point: forward current below $I_{F,\max}$, *and* reverse voltage below $V_{BR}$. A part can pass one test and fail the other.

---

## 5. The Zener Diode — Breakdown by Design

A normal diode dies in reverse breakdown. A **Zener diode** is deliberately built (by heavy doping) to **survive** it — and to break down at a precise, low voltage.

### 5.1 The Trick

Heavy doping makes the depletion region thin, so breakdown happens at a controlled, **low reverse voltage** — the **Zener voltage $V_Z$** (commonly 3.3–15 V, versus 50–100 V for ordinary diodes). Crucially, **once it reaches $V_Z$, the voltage across the Zener stays nearly constant even as the current through it changes a lot.**

> 💡 **A flat spot in the I–V curve.** Past $V_Z$ the reverse curve goes almost vertical: current can swing widely while voltage barely budges. A device that "pins" a voltage regardless of current is exactly what you need to **regulate** a supply.

### 5.2 Application — the Voltage Regulator

The classic use is a **voltage regulator**: a circuit that holds its output at a constant level despite changes in input voltage or load. Wire a Zener in **reverse** across the load, in series with a resistor $R$. As long as the Zener is in breakdown, the load sees a steady $V_Z$ — cheap, simple voltage stabilization.

### 5.3 Circuit Analysis — Just KVL and Ohm's Law

We're back to Chapter 2 circuit analysis, now with a Zener. For the series loop (source $V_S$, resistor $R$, Zener at $V_Z$):

**KVL** around the loop:

$$V_S = I R + V_Z$$

Solve for the series current with **Ohm's law** on the resistor:

$$\boxed{I = \frac{V_S - V_Z}{R}}$$

The resistor drops the *difference* between the supply and the Zener voltage; the Zener holds the rest fixed at $V_Z$. If $V_S$ drifts up or down, $R$ absorbs the change and the load stays at $V_Z$.

> ⚠️ **Don't memorize — derive.** This formula is specific to *this* series topology. Redraw the loop, apply KVL + Ohm's law, and it falls out every time. That habit (write the loop, not the answer) is the whole point of Chapter 2.

---

## 6. The Bipolar Junction Transistor (BJT)

A diode has **one** junction. Stack the doped regions three-deep and you get **two** junctions — and something far more powerful: a device where a **small current controls a large current.**

### 6.1 Two Diodes Become One Transistor

Picture two pn-junction diodes. Rotate one, slide them together so their like-doped sides merge, and you get a single crystal with **three doped regions in a row** — for example **n-p-n.** That's a **bipolar junction transistor.** The three regions each get a terminal:

| Terminal | Role |
|---|---|
| **Emitter (E)** | **supplies** the majority carriers (**heavily doped**) |
| **Base (B)** | the thin middle layer that **controls** the flow (lightly doped, **very thin**) |
| **Collector (C)** | **collects** the carriers that make it across |

BJTs come as **npn** or **pnp**; we'll use **npn** throughout. The two junctions are base–emitter and base–collector.

### 6.2 How It Works — Biasing the Two Junctions

The magic requires biasing the two junctions **oppositely**:

- **Base–emitter junction: forward-biased.** This lets the heavily-doped emitter inject a flood of electrons into the base.
- **Base–collector junction: reverse-biased.** This sets up a field that sweeps carriers from the base into the collector.

Now the key geometric trick: **the base is extremely thin and only lightly doped**, so it has *very few holes.* An electron injected from the emitter finds almost nothing to recombine with, and the reverse-biased collector junction is right there pulling it across:

> 💡 **Why a small base current controls a big collector current.** Emitter electrons flood into the thin base. Only a *tiny fraction* find a hole to recombine with — that trickle is the **base current $I_B$.** The overwhelming majority shoot straight through to the collector — that flood is the **collector current $I_C$.** The little base current is the *control knob*; the big collector current is what it steers. **The BJT is a current amplifier.**

> **Group challenge (npn biasing):** *which terminal connects to the + of the source so electrons flow emitter → collector?* Think about field direction (§2.2): to push **electrons** from emitter to collector, the field — and thus the **+** terminal — must be at the **collector.** Electrons flow *against* the field, from emitter up to the positive collector.

### 6.3 The Current-Amplifier Equations

Every electron leaving the emitter goes *either* to the base *or* to the collector, so the currents split:

$$\boxed{I_E = I_B + I_C}$$

The recombination in the base is small, quantified by a **loss ratio**:

$$\text{recombination loss} = \frac{I_B}{I_E} \quad(\text{small})$$

Because that loss is small, $I_C$ is a large multiple of $I_B$. We name that multiple the **current gain $\beta$**:

$$\boxed{I_C = \beta\ I_B}$$

A typical $\beta$ is 100+, meaning **1 µA into the base can steer 100 µA (or more) through the collector.** This operating condition — base–emitter forward, base–collector reverse, $I_C = \beta I_B$ — is the transistor's **active mode**, where it behaves as a linear **amplifier.**

### 6.4 Common-Emitter Circuit — Amplifier *and* Switch

The most common configuration grounds the emitter, feeds the input to the **base**, and takes the output from the **collector.** Walk the cause-and-effect chain as the input rises:

1. input voltage raises the **base current $I_B$**,
2. collector current rises proportionally, $I_C=\beta I_B$,
3. more $I_C$ means a bigger drop across the collector resistor, so the **collector–emitter voltage $V_{CE}$ falls.**

Keep pushing $I_B$ and $V_{CE}$ keeps falling — but it **can't go below ~0.2 V.** There it flattens out: the transistor is **saturated.**

> 💡 **Saturation = fully ON = a closed switch.** When $V_{CE}$ collapses to nearly zero, the collector–emitter path is essentially a **short** (resistance ≈ 0). The transistor can't amplify anymore — it's just *on.* Drive $I_B$ to zero instead and $I_C$ stops: the path is **open** (**cutoff = OFF**). Slam between cutoff and saturation and the "amplifier" becomes a **switch** — which is exactly how it's used in an H-bridge or any digital circuit.

| Region | Base drive | $V_{CE}$ | Behaves as |
|---|---|---|---|
| **Cutoff** | $I_B \approx 0$ | ≈ supply | **open** switch (OFF) |
| **Active** | moderate $I_B$ | in between | **amplifier** ($I_C=\beta I_B$) |
| **Saturation** | large $I_B$ | ≈ 0.2 V | **closed** switch (ON) |

### 6.5 Light In, Current Out — the Phototransistor

Replace the electrical base drive with **light**: in a **phototransistor**, photons striking the base–emitter junction generate the base current. **Light → base current → (amplified) collector current.** Pair an LED with a phototransistor and you get an **optoisolator** (signal crosses as light, with no electrical connection) or an **optical encoder** (a slotted wheel chops a light beam into pulses to measure rotation) — a direct callback to the position-sensing of Chapter 3.

---

## 7. The Field-Effect Transistor (FET / MOSFET)

The BJT is controlled by **current** into the base. The **FET** is controlled by **voltage** on a **gate** — and *no current flows into that gate at all.* This difference makes FETs the switch of choice for modern digital and power electronics.

### 7.1 The Big Idea — Control by Field, Not Current

> **Group challenge:** *A metal plate sits on a thin insulator on top of p-type silicon. Apply + voltage to the metal. We're NOT connected to the silicon (the oxide blocks any current) — so what happens inside?*

The positive gate can't inject current (the oxide is an insulator), but its **electric field** reaches through and reshapes the silicon underneath. That's the entire principle:

| | **BJT** | **FET (MOSFET)** |
|---|---|---|
| Control terminal | Base | Gate |
| Controlled by | **current** ($I_B$) | **voltage** ($V_{GS}$) |
| Control-terminal current | small but real $I_B$ | **≈ zero** (gate is insulated) |
| Nickname | **current**-controlled | **voltage**-controlled |
| Structure | Emitter · Base · Collector | Source · Gate · Drain |

### 7.2 Structure of an n-Channel Enhancement MOSFET

The most common type layers up like this:

- **Substrate** — a **p-type** silicon base.
- **Source & Drain** — two **n-type** regions embedded in the substrate (these are the two terminals current flows between).
- **Gate** — a **metal** electrode sitting on a thin **silicon-dioxide (SiO₂) insulating layer** over the channel region. (**M-O-S** = Metal–Oxide–Semiconductor.)

> ⚠️ **No current flows into the gate — ever.** The oxide fully insulates the gate from the silicon. The device is controlled **purely by the gate voltage's electric field.** That's why a MOSFET's control terminal draws essentially no steady current, unlike a BJT's base.

### 7.3 How It Switches — Threshold and the Inversion Channel

Between source and drain sits p-type substrate, whose majority carriers are **holes** — so at rest there's **no path** for electrons. Now raise the gate voltage:

- **$V_{GS} = 0$ (or below threshold):** no channel. Source and drain are isolated → **OFF (cutoff).**
- **$V_{GS} >$ threshold $V_{th}$** (typically ~2 V): the gate's positive field **repels holes** from the region just under the oxide and **attracts electrons** there. Enough electrons gather to form a thin **n-type "inversion" channel** bridging source to drain. Current flows → **ON.**

| State | Condition | Channel | Source↔Drain |
|---|---|---|---|
| **OFF** | $V_{GS} < V_{th}$ | none | blocked |
| **ON** | $V_{GS} > V_{th}$ | n-channel forms | conducts |

> 💡 **"Enhancement mode."** With zero gate voltage the device is **OFF by default** — you must *enhance* it (build the channel) with $V_{GS} > V_{th}$ to turn it ON. A small gate **voltage** — drawing no gate current — opens and closes a high-current source-to-drain path. That is the ideal switch: near-zero control power, and nothing to wear out.

---

## 8. Full Circle — the H-Bridge Switches Are MOSFETs

Return to §1's H-bridge. We can finally name the four switches:

> **Q1–Q4 are MOSFETs** — the very transistors of §7. Used as switches, each turns **ON/OFF with a small gate voltage** (e.g. 5 V) — no current into the gate, no moving contacts, no flipping anything by hand. Energize the Q1+Q4 gates and the motor spins one way; energize Q2+Q3 and it spins the other.

That's the whole arc of the chapter: Chapter 3 needed to switch motor current in a precise sequence; a **semiconductor** makes the switch; **doping** builds the p- and n-type material; a **junction** makes a diode; **three** regions make a **transistor**; and a gate-controlled **MOSFET** is the clean, wear-free switch that drives the motor. *To control the motor, we controlled the electrons.*

---

## Key Takeaways

- **Why semiconductors:** controlling an actuator means switching current; the switch (transistor) is a semiconductor device. The H-bridge's **Q1–Q4 are transistors.**
- **Bands & carriers:** conductor / insulator / semiconductor differ by **band-gap size**. A semiconductor's **small gap** lets electrons cross on demand, leaving mobile **holes** behind → it conducts with **two** carriers (electrons − and holes +).
- **Doping** sets the majority carrier without changing net charge: **n-type** (Group V donors → free **electrons**), **p-type** (Group III acceptors → **holes**). A doped crystal is still **electrically neutral**.
- **Diode = one pn junction = one-way valve.** A **depletion region** and built-in barrier form at the junction; **forward bias** narrows it (conducts, ~0.7 V drop), **reverse bias** widens it (blocks). Hence **rectifier.** Respect both ratings: $I_{F,\max}$ *and* $V_{BR}$.
- **Zener diode** lives in reverse **breakdown** at a fixed $V_Z$ → a **voltage regulator.** Analyze with KVL + Ohm: $I = (V_S - V_Z)/R$.
- **BJT = current-controlled.** A thin, lightly-doped base means a small $I_B$ steers a large $I_C=\beta I_B$ ($I_E = I_B + I_C$). Active = **amplifier**; **saturation = fully ON**, cutoff = OFF → a **switch.**
- **MOSFET = voltage-controlled.** A gate voltage past **$V_{th}$** forms an **inversion channel** (source↔drain conducts); **no current flows into the insulated gate.** Enhancement mode is **OFF by default.**
- **Full circle:** the H-bridge's four switches are **MOSFETs** — small gate voltage, no moving parts, driving the Chapter 3 motor.

---

## Course Materials

- 📊 Slides: Chapter 4-1 — Semiconductor Electronics (Working Principle); Chapter 4-2 — Semiconductor Electronics (BJT and MOSFET)
- 📒 Prerequisites: [Chapter 2.1 — Electrical Circuits and Components](ch2_1-electrical-circuits.md) (KVL, Ohm's law, R/L/C) · [Chapter 3 — Motors & System Dynamics](ch3-motors-and-system-dynamics.md) (the H-bridge and why we need to switch motor current)
- ➡️ Next: [Chapter 5 — Operational Amplifiers](ch5-op-amps.md) — building useful circuits from these devices.
- 🔗 Interactive: Zener voltage-regulator simulation (Tinkercad, linked on the slide) — build the §5 circuit and watch $V_Z$ hold steady as the source varies.
