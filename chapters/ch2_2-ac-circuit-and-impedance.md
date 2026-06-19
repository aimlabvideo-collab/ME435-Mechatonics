---
title: "Ch 2.2 — AC Circuits and Impedance"
parent: Chapters
nav_order: 3
---

# Chapter 2.2 — AC Circuits and Impedance

> ME 435 · Mechatronics — Self-study companion notes.
> **Read these alongside the lecture slides.** The slides carry the figures, waveforms, and phasor diagrams; these notes carry the explanations and the *derivations* — the "where does this equation come from" reasoning we work through in class.

## Learning Objectives

By the end of this chapter you should be able to:

- Describe an AC signal with its **amplitude, frequency, and phase**, and convert between time-domain and phasor form.
- Explain why differentiating a sinusoid is the same as **multiplying by $j\omega$**, and use this to turn calculus into algebra.
- Define **impedance** $Z$ and derive it for the resistor, capacitor, and inductor.
- Combine impedances in **series and parallel** exactly like resistances, and solve AC circuits with Ohm's law in the form $V = IZ$.
- Read the **magnitude and phase** of an impedance and explain what they mean physically (current leads or lags voltage).

---

## 1. Why AC Needs New Tools

In Chapter 2.1 every source was DC — constant in time — so a single number described each voltage and current. The element equations told us that a capacitor and inductor only *react* when things change ($i = C\,dv/dt$, $v = L\,di/dt$). Under steady DC nothing changes, so they sit there as an open or a short.

**AC is the opposite world: everything is changing, all the time.** Now those $dv/dt$ and $di/dt$ terms are alive, and the capacitor and inductor become the interesting part of the circuit.

> **The whole problem this chapter solves:**
> Under AC, KVL and KCL turn into *differential equations* (because of the $d/dt$ in the element laws). Solving a differential equation for every circuit is painful. **Impedance** is the trick that turns all that calculus back into the simple algebra of Chapter 2.1 — so that $V = IZ$ works just like $V = IR$.

---

## 2. Describing an AC Signal

A sinusoidal voltage is written:

$$v(t) = V_m \cos(\omega t + \phi)$$

| Quantity | Symbol | Unit | Meaning |
|----------|:------:|:----:|---------|
| Amplitude | $V_m$ | volt (V) | Peak height of the wave |
| Angular frequency | $\omega$ | rad/s | How fast it oscillates; $\omega = 2\pi f$ |
| Frequency | $f$ | hertz (Hz) | Cycles per second; $f = 1/T$ |
| Period | $T$ | second (s) | Time for one full cycle |
| Phase | $\phi$ | rad | Horizontal shift — *where* in the cycle it starts |

The three numbers that *fully* define a sinusoid (at a fixed, known frequency) are **amplitude $V_m$** and **phase $\phi$**. Frequency is shared by every signal in a linear AC circuit — the source sets it, and resistors, capacitors, and inductors never change it. *(See the labeled waveform on the slides.)*

> 💡 **Key idea that motivates everything below.** Since every signal in the circuit has the *same* frequency $\omega$, the only things that differ from one signal to the next are **amplitude and phase**. So if we can carry just those two numbers around — and drop $\omega t$ — the bookkeeping gets enormously simpler. That pair *(amplitude, phase)* is exactly what a **phasor** stores.

---

## 3. Phasors: Turning a Wave into a Vector

A **phasor** represents a sinusoid as a single complex number holding its amplitude and phase:

$$v(t) = V_m\cos(\omega t + \phi) \quad\longleftrightarrow\quad \mathbf{V} = V_m\,e^{j\phi} = V_m\angle\phi$$

This works because of **Euler's formula**, the bridge between rotating exponentials and sinusoids:

$$e^{j\theta} = \cos\theta + j\sin\theta$$

Read $V_m e^{j(\omega t+\phi)}$ as a vector of length $V_m$ spinning counter-clockwise at rate $\omega$; the real (cosine) part is the actual voltage. Because **every** signal spins at the same $\omega$, we can freeze the rotation and keep only the snapshot $V_m e^{j\phi}$ — the phasor. *(The slides show the rotating-vector animation and its projection onto the cosine wave.)*

> ⚠️ **Misconception — "$j$ is just a math trick with no meaning."**
> The $j$ (engineers' name for $\sqrt{-1}$, to avoid clashing with current $i$) is what lets one number carry **two** pieces of information at once — magnitude *and* angle. The angle is physical: it's the phase shift you can see on an oscilloscope. Complex numbers aren't decoration here; they are the natural language for "size and timing."

### Why this is the whole game: $\dfrac{d}{dt} \rightarrow j\omega$

Here is the payoff that makes phasors worth learning. Differentiate the rotating exponential:

$$\frac{d}{dt}\Big(V_m e^{j(\omega t + \phi)}\Big) = j\omega\,V_m e^{j(\omega t + \phi)}$$

**Taking a time-derivative is identical to multiplying by $j\omega$.** That single fact collapses the element laws' calculus into multiplication:

$$\boxed{\frac{d}{dt} \;\longrightarrow\; j\omega}$$

Every $dv/dt$ and $di/dt$ from Chapter 2.1 becomes "$\times\,j\omega$," and the differential equations become ordinary algebra. That algebra is what we call impedance.

> 💡 **The recipe we'll use in §4.** To find any element's impedance: (1) write the signal in exponential form, $V_m e^{j(\omega t+\phi)}$ or $I_m e^{j(\omega t+\phi)}$; (2) substitute it into that element's _V_–_I_ law from Chapter 2.1; (3) differentiate — each $\dfrac{d}{dt}$ just drops a factor of $j\omega$; (4) read off $Z = \mathbf{V}/\mathbf{I}$. That's the entire derivation, three times over.

### A note on phase: lead vs. lag

The sign of $\phi$ tells you *when* a wave peaks relative to the reference:

- **$\phi > 0$ → leading** — the wave is shifted *earlier*; it peaks *before* the reference.
- **$\phi < 0$ → lagging** — the wave is shifted *later*; it peaks *after* the reference.

*Example (slide).* For $v(t) = 5\cos(\omega t - 1)$, the phase is $\phi = -1$ rad $< 0$, so this signal **lags** the reference cosine by 1 radian. Keeping track of these signs is the whole point of carrying phase through the analysis — they become the $\pm 90^\circ$ shifts of the inductor and capacitor below.

---

## 4. Impedance: Ohm's Law for AC

**Impedance $Z$** is the AC generalization of resistance — the ratio of the voltage phasor to the current phasor:

$$\boxed{\mathbf{V} = \mathbf{I}\,Z} \qquad Z = \frac{\mathbf{V}}{\mathbf{I}}$$

Impedance is a **complex number**, measured in ohms ($\Omega$), with two parts:

$$Z = R + jX$$

- $R$ — **resistance** (the real part): energy *dissipated*.
- $X$ — **reactance** (the imaginary part): energy *stored and returned* by capacitors/inductors. It is the reactance that creates the phase shift between voltage and current.

The key idea (slide "Finding impedance"): **the basic _V_–_I_ relationships of R, C, and L do not change.** They are still $v=iR$, $i=C\,dv/dt$, $v=L\,di/dt$. All we do is *substitute the exponential (phasor) form* of the signal into each law and read off the ratio $Z = \mathbf{V}/\mathbf{I}$. Each derivation below does exactly that, step by step.

### 4.1 Resistor — $Z_R = R$

Ohm's law has no derivative, so nothing changes:

$$v = iR \;\longrightarrow\; \mathbf{V} = \mathbf{I}R \;\Rightarrow\; \boxed{Z_R = R}$$

Purely real, no imaginary part. **Voltage and current stay perfectly in phase** — they peak at the same instant. A resistor doesn't care about frequency.

### 4.2 Inductor — $Z_L = j\omega L$ (full derivation)

Start from the inductor law and substitute the exponential form of the current, $i = I_m e^{j(\omega t + \phi)}$:

$$v = L\frac{di}{dt}
\;\longrightarrow\;
\mathbf{V} = L\,\frac{d}{dt}\Big(I_m e^{j(\omega t + \phi)}\Big)$$

Differentiating the exponential brings down a factor of $j\omega$ (this is the $\frac{d}{dt}\to j\omega$ rule in action):

$$\mathbf{V} = L\,(j\omega)\,I_m e^{j(\omega t + \phi)} = j\omega L\,\underbrace{I_m e^{j(\omega t + \phi)}}_{=\;\mathbf{I}} = j\omega L\,\mathbf{I}$$

Compare this with $\mathbf{V} = Z_L\,\mathbf{I}$ and read off the impedance:

$$\boxed{Z_L = j\omega L}$$

Purely imaginary and **positive**. In polar form,

$$Z_L = j\omega L = \omega L\,\angle\,90^\circ$$

- **Voltage leads current by $90^\circ$.** The $+j$ is a $+90^\circ$ rotation: the inductor's voltage peaks a quarter-cycle *before* its current does. (Physically: voltage must build *first* to drive the current up.)
- **Magnitude $|Z_L| = \omega L$ grows linearly with frequency** — quantified next in §4.4.

### 4.3 Capacitor — $Z_C = \dfrac{1}{j\omega C}$ (full derivation)

Same procedure, now substituting the exponential form of the *voltage*, $v = V_m e^{j(\omega t + \phi)}$, into the capacitor law:

$$i = C\frac{dv}{dt}
\;\longrightarrow\;
\mathbf{I} = C\,\frac{d}{dt}\Big(V_m e^{j(\omega t + \phi)}\Big) = C\,(j\omega)\,V_m e^{j(\omega t + \phi)} = j\omega C\,\mathbf{V}$$

Solve for the voltage-to-current ratio:

$$\mathbf{V} = \frac{1}{j\omega C}\,\mathbf{I} = Z_C\,\mathbf{I}
\;\Rightarrow\;
\boxed{Z_C = \frac{1}{j\omega C} = -\,\frac{1}{\omega C}\,j}$$

(The sign flip uses $\dfrac{1}{j} = -j$.) Purely imaginary and **negative** — the mirror image of the inductor. In polar form,

$$Z_C = \frac{1}{\omega C}\,\angle\,-90^\circ$$

- **Current leads voltage by $90^\circ$.** The $-j$ is a $-90^\circ$ rotation on the voltage. (Physically: charge must flow *first* before the voltage across the plates can build.)
- **Magnitude $|Z_C| = \dfrac{1}{\omega C}$ shrinks with frequency** — the opposite of the inductor.

> 💡 **A memory hook — "ELI the ICE man."**
> In an inductor (**L**): voltage (**E**) leads current (**I**) → **E-L-I**.
> In a capacitor (**C**): current (**I**) leads voltage (**E**) → **I-C-E**.

### 4.4 The Three Impedances — Wrap-Up

| Element | _V_–_I_ law (Ch 2.1) | Impedance $Z$ | At DC ($\omega\to 0$) | At high $\omega$ | Phase (V relative to I) |
|---------|:---:|:---:|:---:|:---:|:---:|
| **Resistor** | $v = iR$ | $R$ | $R$ | $R$ | in phase ($0^\circ$) |
| **Inductor** | $v = L\,di/dt$ | $j\omega L$ | short (0) | open ($\infty$) | leads by $90^\circ$ |
| **Capacitor** | $i = C\,dv/dt$ | $1/j\omega C$ | open ($\infty$) | short (0) | lags by $90^\circ$ |

Notice the same **mirror symmetry** as Chapter 2.1: swap $L\leftrightarrow C$ and the inductor and capacitor behaviors trade places.

### 4.5 What Happens as Frequency Changes

This is the single most important consequence of impedance: **unlike a resistor, the inductor and capacitor change their "resistance" with frequency.** Their magnitudes are

$$|Z_L| = \omega L \qquad\qquad |Z_C| = \frac{1}{\omega C}$$

so they pull in *opposite* directions as $\omega$ sweeps from DC up to very high frequency.

**Inductor — $|Z_L| = \omega L$ rises with frequency.**

$$\omega \to 0 \;\Rightarrow\; Z_L \to 0 \quad(\text{short circuit}) \qquad\qquad
\omega \to \infty \;\Rightarrow\; Z_L \to \infty \quad(\text{open / "high resistance"})$$

An inductor **passes low frequencies (and DC) freely but blocks high frequencies.** Physically, the faster the current tries to change, the harder Faraday's law fights back — so fast (high-$\omega$) signals see a large opposing voltage.

**Capacitor — $|Z_C| = 1/\omega C$ falls with frequency.**

$$\omega \to 0 \;\Rightarrow\; Z_C \to \infty \quad(\text{open circuit}) \qquad\qquad
\omega \to \infty \;\Rightarrow\; Z_C \to 0 \quad(\text{short circuit})$$

A capacitor **blocks low frequencies (and DC) but passes high frequencies** — this is the **"blocks DC, passes AC"** rule from Chapter 2.1, now made quantitative. At DC ($\omega=0$) nothing changes, $dv/dt = 0$, no current flows; the higher the frequency, the more readily charge sloshes on and off the plates.

| | DC ($\omega = 0$) | Low $\omega$ | High $\omega$ | $\omega \to \infty$ |
|---|:---:|:---:|:---:|:---:|
| **Inductor** $\;\omega L$ | short (0) | small $Z$ | large $Z$ | open ($\infty$) |
| **Capacitor** $\;1/\omega C$ | open ($\infty$) | large $Z$ | small $Z$ | short (0) |

> 💡 **This frequency-dependence is the seed of every filter.** Pair a resistor with a capacitor (or inductor) and the way they split the voltage now *depends on frequency* — so the circuit naturally passes some frequencies and rejects others. That is exactly how the low-pass / high-pass filters of Chapter 4 work; we'll build on these two limits there.

---

## 5. Combining Impedances

Here is the reward for all this setup: **because $V = IZ$ has exactly the same form as $V = IR$, impedances combine by exactly the same rules as resistors.** Every series/parallel result from Chapter 2.1 §5 carries over — just replace $R$ with $Z$.

**Series — same current, impedances add:**

$$\boxed{Z_{eq} = Z_1 + Z_2 + \cdots}$$

**Parallel — same voltage, reciprocals add:**

$$\boxed{\frac{1}{Z_{eq}} = \frac{1}{Z_1} + \frac{1}{Z_2} + \cdots}$$

The only new wrinkle is that the arithmetic is now with **complex numbers**, so keep the real and imaginary parts separate.

> 💡 **Why one rule now covers all three elements.** In Chapter 2.1, capacitors combined "backwards" from resistors and inductors (reciprocal in series, add in parallel). That was only because we tracked *charge* for capacitors. Once everything is expressed as impedance, **all three elements obey the same single rule** — add in series, reciprocal in parallel. Impedance unifies them.

### Magnitude and Phase of an Impedance

Any impedance $Z = R + jX$ can be read in **polar form**:

$$|Z| = \sqrt{R^2 + X^2}, \qquad \theta = \tan^{-1}\!\frac{X}{R}$$

These two numbers are exactly what you measure:

- $|Z|$ — the **ratio of voltage amplitude to current amplitude**: $V_m = |Z|\,I_m$.
- $\theta$ — the **phase angle between voltage and current**. Positive $\theta$ (inductive) → voltage leads; negative $\theta$ (capacitive) → voltage lags.

---

## 6. Worked Example — A Series RC Circuit

**Problem.** A source $v(t) = 10\cos(\omega t)$ V drives a resistor $R = 1\text{ k}\Omega$ in series with a capacitor $C = 1\ \mu\text{F}$, at $\omega = 1000$ rad/s. Find the current and the voltage across each element.

We solve it the way we do in class: **write each impedance, combine, then apply $V = IZ$.**

### Step 1 — Impedances

$$Z_R = R = 1000\ \Omega$$

$$Z_C = \frac{1}{j\omega C} = \frac{1}{j\,(1000)(10^{-6})} = \frac{1}{j\,(10^{-3})} = -j\,1000\ \Omega$$

So here the resistor and capacitor happen to have **equal-magnitude** impedances (1 kΩ each).

### Step 2 — Combine (series → add)

$$Z_{eq} = Z_R + Z_C = 1000 - j\,1000\ \Omega$$

In polar form:

$$|Z_{eq}| = \sqrt{1000^2 + 1000^2} = 1000\sqrt{2} \approx 1414\ \Omega, \qquad
\theta = \tan^{-1}\!\frac{-1000}{1000} = -45^\circ$$

### Step 3 — Current (Ohm's law, $\mathbf{I} = \mathbf{V}/Z$)

Take the source phasor as $\mathbf{V} = 10\angle 0^\circ$:

$$\mathbf{I} = \frac{\mathbf{V}}{Z_{eq}} = \frac{10\angle 0^\circ}{1414\angle{-45^\circ}} = 7.07\angle{+45^\circ}\ \text{mA}$$

So the current is $i(t) = 7.07\cos(\omega t + 45^\circ)$ mA.

> ⚠️ **Read the phase, not just the number.** The current has a **positive** $45^\circ$ angle — it *leads* the source voltage. That is the capacitor at work (ICE: current leads voltage). The negative impedance angle and the positive current angle are the same fact stated two ways.

### Step 4 — Voltage across each element

$$\mathbf{V}_R = \mathbf{I}\,Z_R = (7.07\angle 45^\circ\ \text{mA})(1000\angle 0^\circ) = 7.07\angle 45^\circ\ \text{V}$$

$$\mathbf{V}_C = \mathbf{I}\,Z_C = (7.07\angle 45^\circ\ \text{mA})(1000\angle{-90^\circ}) = 7.07\angle{-45^\circ}\ \text{V}$$

### The intuition

Two checks confirm the answer:

- **They add back to the source (KVL still holds — as phasors).** $\mathbf{V}_R + \mathbf{V}_C = 7.07\angle 45^\circ + 7.07\angle{-45^\circ}$. The imaginary parts cancel and the reals add: $5 + 5 = 10\angle 0^\circ$ V. ✓
- **The amplitudes do *not* add as plain numbers.** Each element holds 7.07 V yet they sum to only 10 V, not 14.1 V — because they peak at *different times* (different phases). This is the defining feature of AC: **you must add voltages as vectors, never as scalars.**

---

## 7. Where This Goes Next

Impedance is the gateway to the rest of the course:

- **Filters.** Because $Z_C$ and $Z_L$ depend on frequency, a simple RC or RL network passes some frequencies and blocks others — the basis of every low-pass / high-pass filter (Chapter 4).
- **Resonance.** When $Z_L$ and $Z_C$ cancel ($\omega L = 1/\omega C$), the reactance vanishes and the circuit responds maximally — the principle behind tuning and oscillators.
- **Transfer functions.** Replacing $j\omega$ with the Laplace variable $s$ turns impedance into the system-dynamics tool of Chapter 3.

---

## Key Takeaways

- AC makes the $d/dt$ terms in the element laws *active*, so KVL/KCL become differential equations — **impedance turns them back into algebra**.
- A **phasor** stores a sinusoid's amplitude and phase as one complex number; this works because every signal shares the same frequency $\omega$.
- The master trick is $\dfrac{d}{dt}\to j\omega$. Applying it to the Chapter 2.1 laws gives $Z_R = R$, $Z_L = j\omega L$, $Z_C = 1/j\omega C$.
- $Z = R + jX$: the **real part dissipates**, the **imaginary part (reactance) stores and shifts phase**. $|Z|$ is the amplitude ratio; the angle is the phase between $V$ and $I$.
- **Inductor:** voltage leads current (ELI); **capacitor:** current leads voltage (ICE).
- **Frequency is everything for L and C:** $|Z_L| = \omega L$ rises with $\omega$ (inductor → short at DC, open at high $\omega$); $|Z_C| = 1/\omega C$ falls with $\omega$ (capacitor → open at DC, short at high $\omega$). The resistor is flat. This opposite frequency behavior is the seed of all filters.
- With $V = IZ$, impedances **combine exactly like resistances** — add in series, reciprocal in parallel — and one rule now covers all three elements.
- AC voltages and currents add as **vectors (phasors), not scalars** — equal-amplitude signals at different phases do not sum arithmetically.

---

## Course Materials

- 📊 Slides: [Chapter 2.2 — AC Circuits and Impedance](../slides/)
- 📒 Prerequisite: [Chapter 2.1 — Electrical Circuits and Components](ch2_1-electrical-circuits.md)
