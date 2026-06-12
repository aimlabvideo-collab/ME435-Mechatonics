---
title: "Ch 2.1 — Electrical Circuits and Components"
parent: Chapters
nav_order: 2
---

# Chapter 2.1 — Going Deeper

> ME 435 · Mechatronics — **Extra-depth notes.**
> These notes go *beyond* the lecture. In class we don't have time to chase down every "why," so this page does it for you. Each section starts with a one-line reminder of the in-class point (*In class:* …), then digs into the reasoning, physics, and practical consequences we had to skip.
>
> *Assumes you've seen the slides and know basic calculus. Keep the slides handy for the figures.*

---

## 1. Current: What's Actually Moving?

*In class:* current is the flow of charge, $I = dq/dt$, and conventional current runs from **+** to **−**.

**The part we skip — electrons barely move.** Here's something surprising. When you flip a switch and a light turns on "instantly," the electrons in the wire are *not* racing from the switch to the bulb. In a copper wire carrying an ordinary current, the average electron **drift velocity** is on the order of a fraction of a millimeter per second — slower than a snail.

So how does the bulb light up immediately? Because what propagates near the speed of light is the **electric field**, not the electrons themselves. The field tells *every* electron in the wire to start drifting almost at once — like a tube already full of water: push one end and water comes out the other end immediately, even though no single water molecule traveled the whole length.

> ⚠️ **Misconception — current direction.**
> Conventional current flows **+** → **−**, but in a metal the **electrons (negative)** drift the *opposite* way. The convention was fixed in the 1700s before electrons were understood, and we kept it. **Positive charges don't move — electrons do.** (None of your circuit math changes; it's just a labeling convention.)

---

## 2. Resistor: Why "Ideal" Is a Lie (a Useful One)

*In class:* a resistor obeys $V = IR$, a straight line, and dissipates energy as heat.

**Where resistance physically comes from.** A metal is a lattice of fixed ions with free electrons drifting through it. As electrons drift, they **scatter** off the vibrating lattice — each collision transfers energy to the lattice as heat. That scattering *is* resistance. This picture explains the formula $R = \rho L/A$: more length means more lattice to scatter through; more area means more parallel paths for electrons.

**Why real resistors aren't straight lines.**
- **Temperature.** Heat the metal and the lattice vibrates harder → more scattering → resistance *rises*. So a real resistor's _V_–_I_ line bends as it heats under load. (Semiconductors do the *opposite*: heat frees more charge carriers, so their resistance *drops* — which is why thermistors work.)
- **Power rating.** Every real resistor has a wattage limit. Past it, $V=IR$ still holds right up until the part overheats and changes value or fails. The "ideal" linear line assumes you never get there.

> The takeaway: $V=IR$ is an *empirical, approximate* law for a specific operating range — not a fundamental law of nature like charge conservation. It's astonishingly good for the conditions we use resistors in, which is why we lean on it.

---

## 3. Capacitor: How Does "Current" Cross a Gap That Blocks It?

*In class:* $i = C dv/dt$; a capacitor blocks DC and passes AC; it stores energy in an electric field.

**The puzzle.** The two plates are separated by an **insulator** (dielectric). No electron ever crosses the gap. So how can an ammeter read a steady "current through" the capacitor while it charges?

**The resolution.** Nothing crosses the gap. What happens is: electrons pile onto one plate and are pulled *off* the other plate, through the external wires. From outside, the wires carry a real current; *inside* the gap, no charge moves — instead a **changing electric field** builds between the plates. Maxwell named this changing-field term the **displacement current**, and it's exactly what "completes" the circuit so current continuity is never violated. (You'll meet displacement current by name in electromagnetics; here, just know the gap is bridged by a *field*, not by charge.)

**Why this gives "blocks DC, passes AC" for free.** Look at $i = C dv/dt$:
- **DC** → voltage is constant → $dv/dt = 0$ → $i = 0$. The field is already built and static, nothing flows. **Open circuit.**
- **AC** → voltage keeps changing → $dv/dt \neq 0$ → current keeps flowing as the field is repeatedly built and torn down. The faster the signal, the more it passes.

**Where the energy lives, and how much.** The stored energy sits in the electric field between the plates. You can derive the amount by integrating the power $vi$ as it charges:

$$W = \int v i dt = \int v \left(C\frac{dv}{dt}\right) dt = \int_0^V C v dv = \tfrac{1}{2}CV^2$$

**Bonus — what the dielectric is doing.** Inserting a dielectric *increases* capacitance. Why? The dielectric's molecules polarize and partially cancel the field, so the same stored charge produces a *lower* voltage. Since $C = q/V$, lower $V$ for the same $q$ means higher $C$.

---

## 4. Inductor: The Component That Fights Change (and Bites Back)

*In class:* $v = L di/dt$; an inductor stores energy in a magnetic field and stabilizes current.

**The defining behavior — opposition to change (Lenz's law).** Run current through a coil and it builds a magnetic field. If you try to *change* that current, the changing field induces a voltage that **opposes the change** — fights a rising current, props up a falling one. That's why inductor current can't jump: a sudden change would need infinite voltage ($v = L di/dt$).

**Where the energy lives, and how much.** Energy is stored in the magnetic field around the coil:

$$W = \int v i dt = \int \left(L\frac{di}{dt}\right) i dt = \int_0^I L i di = \tfrac{1}{2}LI^2$$

**The part that's genuinely important and always rushed — back-EMF.** This is the inductor's "bite." Suppose current is flowing through a relay coil or a motor (both inductors) and you suddenly **open a switch**. You've just forced $di/dt$ to be enormous and negative in an instant. Through $v = L di/dt$, the inductor generates a huge voltage spike — often hundreds of volts from a 12 V circuit — trying to keep its current flowing. That spike will **arc across the switch contacts** or destroy a transistor driving the coil.

> 💡 **This is why you see a diode across every relay and motor coil.** That "flyback" or "freewheeling" diode gives the inductor's current a safe path to die down gradually instead of spiking. If you've ever wondered why a tiny diode sits backwards across a relay in every Arduino motor circuit — *this* is the reason. Most courses never have time to explain it.

**Application — buck converter (12 V → 5 V).** A buck converter steps voltage down by switching the input on/off very fast. A bare switch would make the load current jolt up and down uselessly. The inductor's "current can't jump" property **smooths the pulses into a steady current**. (Full switching/duty-cycle analysis, $V_{out}=D V_{in}$, belongs to power electronics — here it's just inductor behavior in action.)

---

## 5. Kirchhoff's Laws: They're Conservation Laws in Disguise

*In class:* KVL — voltages around a loop sum to 0; KCL — currents at a node sum to 0.

**What they *really* are.** These aren't arbitrary circuit rules — they're two of the deepest laws in physics wearing circuit clothing:

- **KVL is energy conservation.** Voltage is energy per charge. Carry a charge once around a loop and back to its start, and it must have the same potential energy it began with — so the net energy gained and lost (rises and drops) cancels to zero.
- **KCL is charge conservation.** Charge can't be created, destroyed, or piled up at a junction. So whatever flows into a node must flow out.

**The fine print nobody mentions — when they break.** KVL and KCL rely on the **lumped-element assumption**: that the circuit is small compared to the signal's wavelength, so a voltage or current is "the same value everywhere along a wire at one instant." This is true for almost everything you'll build. But at very high frequencies (GHz) or over long cables, signals take measurable *time* to travel down a wire, and the wire itself behaves like a distributed network. Then you need **transmission-line theory**, not plain KVL/KCL. Knowing *where* the simple laws stop applying is what separates a technician from an engineer.

**Why guessing the wrong current direction is harmless.** When you label a branch current $i$ with an arrow, $i$ is just an algebraic variable. The KVL/KCL equations are **linear** in these variables. If the true current actually runs opposite to your arrow, the algebra doesn't break — it simply solves to a **negative number**, which reads as "the real current is this big, in the direction opposite to my arrow." The sign carries the correction automatically. You never have to redo the problem; just keep your conventions consistent.

---

## 6. Series & Parallel: The Shortcuts, and Where They Fail

*In class:* combine resistors/inductors by adding in series, capacitors by adding in parallel (and reciprocals for the other cases).

These rules come straight from the laws above. **Series** means one shared current; apply KVL. **Parallel** means one shared voltage; apply KCL.

| | Series (shared current) | Parallel (shared voltage) |
|---|:---:|:---:|
| **R** | $R_1 + R_2$ | $\left(\tfrac{1}{R_1}+\tfrac{1}{R_2}\right)^{-1}$ |
| **L** | $L_1 + L_2$ | $\left(\tfrac{1}{L_1}+\tfrac{1}{L_2}\right)^{-1}$ |
| **C** | $\left(\tfrac{1}{C_1}+\tfrac{1}{C_2}\right)^{-1}$ | $C_1 + C_2$ |

Capacitors look "backwards" because $C$ relates *charge* to voltage, flipping the roles that $R$ and $L$ play. (In series, capacitors share the same charge $q$; their voltages $q/C$ add — giving the reciprocal rule.)

**Where the shortcut quietly fails — the engineer's footnote:**
- **Inductors that "see" each other.** The series rule $L_{eq}=L_1+L_2$ assumes the two coils' magnetic fields don't interact. Place them close and their fields couple — **mutual inductance $M$** — and the real result becomes $L_1 + L_2 \pm 2M$. This is the basis of transformers, and a trap if you lay out coils carelessly.
- **Real parts aren't pure.** A real resistor has a little parasitic inductance and capacitance; a real capacitor has series resistance and inductance (ESR/ESL). At low frequency these vanish and the simple rules hold. At high frequency a "resistor" can behave partly like an inductor. The ideal combination rules are a low-frequency approximation — excellent, but not eternal.

---

## Key Takeaways (the deep version)

- Electrons drift astonishingly slowly; it's the **field** that propagates near light speed.
- $V=IR$ is an empirical approximation; real resistance is electron **scattering**, and it shifts with temperature.
- A capacitor's "current" never crosses the gap — a changing **field** (displacement current) bridges it; energy $=\tfrac12 CV^2$.
- An inductor **fights changes in its current** and **bites back** with a voltage spike when interrupted — hence the flyback diode; energy $=\tfrac12 LI^2$.
- **KVL = energy conservation, KCL = charge conservation**; both rely on the lumped-element assumption and break down at high frequency.
- A wrong direction guess self-corrects to a **negative sign** because the equations are linear.
- Series/parallel rules are KVL/KCL shortcuts that assume **no coupling and ideal parts** — watch for mutual inductance and parasitics.

---

## Course Materials

- 📊 Slides: [Chapter 2.1 — Electrical Circuits and Components](../slides/)
