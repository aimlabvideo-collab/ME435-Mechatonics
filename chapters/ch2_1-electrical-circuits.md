---
title: "Ch 2.1 — Electrical Circuits and Components"
parent: Chapters
nav_order: 2
---

# Chapter 2.1 — Electrical Circuits and Components

> ME 435 · Mechatronics — Self-study concept notes.
> A quick refresher of the core ideas from ECE 240, focused on *concepts* rather than worked problems.

## Learning Objectives

By the end of this chapter you should be able to:

- Explain voltage, current, and resistance, and why circuit analysis reduces to finding $V$ and $I$.
- Describe the three basic passive elements — resistor, capacitor, inductor — by their voltage–current relationships.
- State **Ohm's law** and **Kirchhoff's voltage/current laws (KVL/KCL)**.
- Combine elements in series and parallel into an equivalent element.

---

## 1. The Big Picture: It's All About $V$ and $I$

Analyzing a circuit ultimately comes down to finding two quantities: **voltage ($V$)** and **current ($I$)**. Understanding any mechatronic system means knowing these two values throughout its circuits.

The key idea that ties the whole chapter together:

> **Every circuit element defines its own relationship between $V$ and $I$.**
> The resistor, capacitor, and inductor each have a *different* $V$–$I$ relationship — and that relationship *is* what the element "is."

| Quantity | Symbol | Unit | Meaning |
|----------|:------:|:----:|---------|
| Voltage | $V$ | volt (V) | Potential difference between two points — the "push" |
| Current | $I$ | ampere (A) | Flow of electric charge |
| Resistance | $R$ | ohm ($\Omega$) | Opposition to current flow |

**DC vs. AC:**
- **DC** — voltage and current are constant in time (e.g., a battery).
- **AC** — voltage and current vary with time (e.g., a wall outlet).

---

## 2. The Circuit: Source and Load

- **Voltage source** — provides energy to the circuit (battery, power supply, generator). Conventional current flows from the **+** terminal, through the circuit, back to the **−** terminal.
- **Load** — a network of elements that *dissipates* or *stores* electrical energy (e.g., a bulb, or a system doing useful work).

> ⚠️ **Key misconception — current direction.**
> By historical convention, *conventional current* flows from **+** to **−**. But in a metal wire it is the **electrons (negative charge)** that actually move — in the *opposite* direction. The convention was fixed in the 1700s, before electrons were understood, and we still keep it today.
> **Positive charges do not move — electrons do.**

---

## 3. The Three Basic Passive Elements

There are three basic **passive** elements, each defined by its own $V$–$I$ relationship:

| Element | Symbol | Role | Energy |
|---------|:------:|------|--------|
| **Resistor** | $R$ | Converts electrical energy to heat | Dissipates |
| **Capacitor** | $C$ | Builds an **electric** field between plates | Stores |
| **Inductor** | $L$ | Builds a **magnetic** field around a coil | Stores |

---

### 3.1 Resistor

A resistor is a **dissipative** element that converts electrical energy into heat. Unit: ohm ($\Omega$).

**Ohm's law** — the $V$–$I$ relationship of an ideal resistor:

$$V = I R$$

For an *ideal* resistor, $V$ and $I$ are perfectly **linear** (a straight line through the origin, slope $R$). Real resistors deviate — for example, resistance drifts with temperature.

**Resistivity.** Resistance depends on material and geometry:

$$R = \frac{\rho L}{A}$$

where $\rho$ is the material's **resistivity**, $L$ the length, $A$ the cross-sectional area. Longer wire → more resistance; thicker wire → less; lower-resistivity material → less.

> Silver has the lowest resistivity, with copper close behind. Because copper is far cheaper, it is the most common material for real wiring — a balance of **conductivity and cost**.

**Reading color bands** (standard 4-band resistor):

| Band | Meaning |
|:----:|---------|
| 1st | First digit |
| 2nd | Second digit |
| 3rd | Multiplier (power of 10) |
| 4th | Tolerance |

---

### 3.2 Capacitor

A capacitor is a passive element that stores energy in an **electric field**. The simplest form is two parallel conducting plates separated by a dielectric. Opposite charges accumulate on the plates, creating a field that maintains a voltage difference. Unit: **farad (F)**.

**Voltage–current relationship:**

$$i = C\,\frac{dv}{dt}$$

Current is proportional to how *fast* the voltage changes.

**Key behavior — blocks DC, passes AC.** At steady DC, $dv/dt = 0 \Rightarrow i = 0$, so the capacitor acts like an **open circuit**. For fast-changing signals it readily passes current.

> 💡 Capacitors are used to **control and stabilize voltage** in a circuit.

> ⚠️ **Misconception — "current flows through a capacitor."**
> Strictly, DC does **not** flow *through* a capacitor. Charge is *displaced* — pushed onto one plate and pulled off the other through the external circuit — building up the electric field. The charge movement in the surrounding wires is what we observe as "current."

---

### 3.3 Inductor

An inductor is a passive element that stores energy in a **magnetic field**. In its simplest form it is a coil of wire. Unit of inductance: **henry (H)**.

**Faraday's law** is the governing principle: a *changing* magnetic field induces a voltage that **opposes the change in current**.

**Flux and inductance.** *Magnetic flux* is the amount of magnetic field passing through a surface. Flux is proportional to current, with the inductance $L$ as the proportionality constant.

**Voltage–current relationship:**

$$v = L\,\frac{di}{dt}$$

Voltage is proportional to how *fast* the current changes. A consequence: current through an inductor **cannot change instantly** — it builds up over time.

> 💡 Inductors are used to **control and stabilize current** in a circuit (e.g., the inductor in a buck converter stepping 12 V down to 5 V).

---

### 3.4 Passive Components — Wrap-Up

| | Resistor | Capacitor | Inductor |
|---|:---:|:---:|:---:|
| **Role** | Dissipative element | Stores energy in an **electric** field | Stores energy in a **magnetic** field |
| **$V$–$I$ relationship** | $V = IR$ | $i = C\,\dfrac{dv}{dt}$ | $v = L\,\dfrac{di}{dt}$ |
| **At steady DC** | normal resistor | open circuit | short circuit |
| **Stabilizes** | — | voltage | current |

---

## 4. Kirchhoff's Laws

Kirchhoff's laws are the foundation of **all** circuit analysis — from a single loop to transistor circuits, op-amps, and ICs with hundreds of elements. (Think of them as "Newton's laws for circuits.")

### 4.1 Kirchhoff's Voltage Law (KVL)

> **The sum of voltages around any closed loop equals zero.**

$$\sum_{\text{loop}} V = 0$$

Equivalently: around a closed loop, the total voltage supplied by sources equals the total voltage dropped across the elements. Voltage rises balance voltage drops — **energy is conserved**.

**How to apply it:**

1. **Assume a current direction** on each branch.
2. **Assign voltage polarity** to each passive element, assuming the voltage *drops* in the direction of the assumed current.
3. **Sum the voltages around the loop, set equal to 0**, and solve.

### 4.2 Kirchhoff's Current Law (KCL)

> **The sum of all currents entering and leaving a node equals zero.**

$$\sum_{\text{node}} I = 0$$

**Convention:** currents *entering* a node are positive; currents *leaving* are negative (or vice versa — just stay consistent).

### 4.3 You Can Guess Current Directions Freely

When analyzing a circuit you **arbitrarily** choose current directions and draw arrows. The assumed voltage polarities must be consistent with those arrows.

> 💡 If your guess is wrong, you don't start over — the math simply returns a **negative value**, telling you the real current flows the other way. Consistent KVL/KCL gives the correct result regardless of your initial assumption.

---

## 5. Series and Parallel Combinations

### Series — same current through every element

$$R_{eq} = R_1 + R_2 + \cdots$$

$$\frac{1}{C_{eq}} = \frac{1}{C_1} + \frac{1}{C_2} + \cdots$$

$$L_{eq} = L_1 + L_2 + \cdots$$

### Parallel — same voltage across every element

$$\frac{1}{R_{eq}} = \frac{1}{R_1} + \frac{1}{R_2} + \cdots$$

$$C_{eq} = C_1 + C_2 + \cdots$$

$$\frac{1}{L_{eq}} = \frac{1}{L_1} + \frac{1}{L_2} + \cdots$$

> **Notice the symmetry:** resistors and inductors combine the same way (add in series, reciprocal in parallel); capacitors are the **opposite** (reciprocal in series, add in parallel). Understanding *why* matters more than memorizing.

---

## Key Takeaways

- Circuit analysis reduces to finding $V$ and $I$; **each element defines its own $V$–$I$ relationship**.
- Conventional current flows + → −, but **electrons move the other way**.
- Three passive elements, three defining equations: $V = IR$, $\ i = C\,dv/dt$, $\ v = L\,di/dt$.
- A capacitor **blocks DC / passes AC** and **stabilizes voltage**; an inductor **resists sudden current changes** and **stabilizes current**.
- **KVL:** voltages around a loop sum to 0. **KCL:** currents at a node sum to 0.
- Guessing a current direction wrong just gives a **negative answer** — not an error, as long as you stay consistent.

---

## Course Materials

- 📊 Slides: [Chapter 2.1 — Electrical Circuits and Components](../slides/)
