---
title: "Ch 3 — Motors & System Dynamics"
parent: Chapters
nav_order: 4
---

# Chapter 3 — Motors and System Dynamics

> ME 435 · Mechatronics — Self-study companion notes.
> **Read these alongside the lecture slides.** The slides carry the photos, motor cutaways, spec sheets, and circuit/free-body diagrams; these notes carry the explanations and the *derivations* — the "where does this equation come from" reasoning we work through in class. This chapter spans both decks: **3-1 Motor and System Dynamics** and **3-2 DC Motor Simulation with MATLAB**.

## Learning Objectives

By the end of this chapter you should be able to:

- Explain what an **actuator** is and why DC motors dominate modern mechatronics.
- Describe the **working principle** of a DC motor — magnetic attraction/repulsion, the right-hand rule, and the job of the **commutator** — and contrast **brushed vs. brushless (BLDC)**, **servo vs. stepper**, and **radial vs. axial flux** motors.
- Explain how a **BLDC commutates electronically**: how three **Hall sensors** encode rotor position as a **3-bit code**, and how that code selects which two of the three **U-V-W phases** to energize in **six-step commutation**.
- **Select a motor** for an application: read a spec sheet, use the torque/speed constants, and stay inside the torque–speed curve.
- Derive the **two coupled equations** of a DC motor — the **armature circuit** (KVL) and the **rotational dynamics** (Newton) — and identify the **back-EMF** that links them.
- Classify a system as **zero-, first-, or second-order**, and write the time response of each (time constant $\tau$; the three damping cases).
- Assemble the motor model into **state-space form** and simulate it numerically with MATLAB **`ode45`**.

---

## 1. Actuators: How a System Acts on the World

A sensor lets a system *perceive*; an **actuator** lets it *act*. Almost every mechatronic system — an EV, a drone, a robot arm — needs one to produce the desired motion (linear or angular displacement) that satisfies its requirements. Actuators are grouped by the energy they convert:

| Type | Energy source | Example |
|------|---------------|---------|
| **Electrical** | current + magnetic field | DC motor, BLDC, stepper |
| **Hydraulic** | fluid pressure | excavator arm |
| **Pneumatic** | air pressure | factory grippers |

This chapter focuses on **electrical actuators — specifically DC motors** — because robots and drones overwhelmingly rely on them.

> **Two questions that motivate the whole chapter (from the slides):**
> **Why does motor selection matter?** → *Code can't fix a bad motor choice.* If the motor is undersized, no amount of clever control rescues it.
> **Why do we need simulation?** → *To predict system behavior* before building hardware, so design mistakes are caught on a laptop, not on a burned-out motor.

---

## 2. Inside a DC Motor

A DC motor turns electrical energy into rotation through three core parts:

| Part | Role |
|------|------|
| **Stator** | The stationary outer piece that supplies a **constant magnetic field** (permanent magnets or field windings). |
| **Rotor (armature)** | The rotating inner piece that **carries current** and produces torque by interacting with the stator's field, turning the shaft. |
| **Commutator** | A mechanical switch that **automatically reverses the current direction** in the rotor windings to keep rotation continuous. |

### 2.1 The Working Principle — Make a Magnet Chase a Magnet

Picture two bar magnets, "magnet 1" (the rotor) and "magnet 2" (the stator field). Like poles **repel**, opposite poles **attract**. If you align them so the poles fight, magnet 1 swings around to flip itself — but once opposite poles meet, it **stops**, perfectly aligned. You get *half a turn and then nothing.*

> **The core problem of motor design:** alignment is the enemy of rotation. The instant the rotor reaches the lowest-energy (aligned) position, the torque dies. To keep spinning, you must **keep moving the target** — repeatedly flip the magnetic poles so the rotor is always chasing, never caught.

Flipping real magnets by hand is absurd, so we make an **electromagnet** out of the rotor and flip *its* poles by reversing the **current**. Which way the poles point is set by **Ampère's right-hand rule** for a coil:

> **Ampère's right-hand rule (coil):** curl your fingers in the direction the **current** flows around the coil; your **thumb** points to the coil's **north pole** (the magnetic-field direction).

Reverse the current and the north/south poles swap. So controlling rotation reduces to controlling *when* the current reverses.

### 2.2 The Commutator — Automatic Current Reversal

The **commutator** does the flipping for you. It reverses the winding current **every half rotation (180°)**, so:

1. the rotor's magnetic poles keep switching positions,
2. the rotor is always being pushed toward a target that has just moved, and
3. the torque keeps acting in the **same rotational direction** — continuous spin.

> 💡 **Why "every half turn" is exactly right.** A magnet takes half a turn to go from "repelled" to "aligned." Flipping the current precisely at that point turns the would-be stopping point into a fresh repulsion, so the rotor never settles. The commutator is just a rotary timing switch synchronized to the shaft.

---

## 3. Families of Electric Motors

### 3.1 Brushed vs. Brushless (BLDC)

Every DC motor needs commutation — the question is *how it's done.*

| | **Brushed DC** | **Brushless DC (BLDC)** |
|---|---|---|
| Commutation | **Mechanical** — brushes rub on a commutator | **Electronic** — a controller switches the current |
| What moves the current | physical sliding contact | transistors in a motor controller |
| What rotates | the **wound rotor** | usually the **magnet rotor**; the **stator** windings are energized in sequence |
| Wear | brushes wear out (friction, sparking) | no brushes → long life, less maintenance |

In a BLDC the controller energizes stator coils in sequence to create a **rotating magnetic field** that the permanent-magnet rotor follows — the same idea as an AC motor, but with the rotating field *actively generated and timed electronically* rather than coming from an AC line. This is why a BLDC needs a controller to spin at all: there is no mechanical commutator to do the timing.

#### 3.1.1 How a BLDC Knows *When* to Switch — Hall Sensors and 3-Phase Commutation

> 🖱️ **Interactive demo — open this and play with it as you read:** [**BLDC Hall-sensor commutation (live)**](https://aimlabvideo-collab.github.io/ME435-Mechatonics/simulation/chapter3/BLDC_Hall_3Phases/bldc_hall_demo.html). Spin the rotor (drag it, or hit play) and watch the three Hall sensors turn the rotor's position into a 3-bit code, and the code pick which two of the three phases (**U V W**) get energized. Everything in this section is something you can *see move* on that page.

The brushed motor solved "when to flip the current" mechanically — the commutator is a rotary switch bolted to the shaft, so it is *automatically* synchronized to rotor position (§2.2). A BLDC throws that switch away. So it faces a new problem:

> **The BLDC's core problem:** with no commutator, the controller must **independently know where the rotor is** before it can decide which coils to energize. Energize the wrong coils and you push the rotor toward a pole it's already near — no torque, or worse, backwards. *Commutation now depends on sensing position.*

**The sensor: three Hall-effect switches.** A **Hall sensor** outputs a voltage when a magnetic field passes it; as a digital switch it reads **1** near a magnet's **N** pole and **0** near its **S** pole. Mount **three** of them around the stator, spaced **120° apart** (electrically). As the permanent-magnet rotor turns, each sensor sees N then S then N… and toggles between 1 and 0. Read all three together and you get a **3-bit code** `A B C`.

**Why three bits give exactly six steps.** Three bits can express $2^3 = 8$ patterns, but two of them — `000` and `111` — can never occur, because the three sensors are spread 120° apart and can't all see the same pole at once. That leaves **six valid codes**. Each one is unique to a **60° slice** of one electrical revolution:

| Hall code `A B C` | Commutation step | Stator-field direction it commands |
|:---:|:---:|:---:|
| `0 1 1` | 1 | 0° |
| `0 0 1` | 2 | 60° |
| `1 0 1` | 3 | 120° |
| `1 0 0` | 4 | 180° |
| `1 1 0` | 5 | 240° |
| `0 1 0` | 6 | 300° |

> 💡 **The code *is* a coarse position encoder.** Three cheap digital sensors don't tell you the angle exactly — they tell you which of six 60° sectors the rotor is in. That is *just enough* to know which way to push. The rotor walks through the six codes in a fixed cyclic order; run them backwards and the motor spins the other way. (Watch the rolling 3-channel trace at the bottom of the demo — those are the three Hall lines as square waves, 120° out of phase, exactly like the slides.)

**The action: 6-step commutation of the U-V-W phases.** A BLDC stator has **three phase windings — U, V, and W**. For each Hall code the controller energizes **two** of them (current in through one, out through another) and lets the **third float** (off). That two-phase pair produces a stator magnetic field pointed in one of six directions — the "field direction" column above. The controller always aims that field about **90° ahead of the rotor**, so the rotor is forever *chasing* a target that just jumped ahead — the same "make a magnet chase a magnet" trick from §2.1, now done by transistors instead of brushes.

> 💡 **Six discrete kicks, one smooth spin.** Each time the rotor crosses into a new 60° sector, the Hall code flips one bit, the controller switches to the next phase pair, and the stator field jumps 60°. Six jumps = one electrical revolution. The field moves in steps; the rotor, carried by its inertia, glides through smoothly. This stepped, two-phases-on pattern is called **six-step (trapezoidal) commutation** — the most common way to drive a BLDC.

> ⚠️ **This is electronic commutation, full stop.** Everything the brushes did mechanically — sense position, reverse current at the right instant, keep torque in one direction — is now done in software/transistors: *Hall sensors sense → controller decodes the 3-bit code → it switches the U/V/W phase pair.* No contact, no sparking, no wear (§3.1). The cost is that a BLDC **cannot spin without its controller and a position signal** — which is exactly what the live demo lets you feel by scrubbing the rotor by hand.

### 3.2 Servo vs. Stepper — Position Control

| Motor | How position is commanded | Mental model |
|-------|---------------------------|--------------|
| **Servo** | by the **width** of a pulse (PWM) | "go to *this angle*" |
| **Stepper** | by the **number** of pulses | "advance *this many steps*" |

A servo uses feedback to hold a commanded angle; a stepper moves in fixed discrete increments, one step per pulse, and can run open-loop. Picking between them is a real engineering decision (slide: *"Which motor fits best?"*) — steppers give cheap, precise open-loop positioning at low speed; servos give smooth high-speed motion with feedback.

### 3.3 Take-Home: Radial vs. Axial Flux

| | **Radial flux** | **Axial flux** |
|---|---|---|
| Shape | conventional **cylinder** | flat **disc / pancake** |
| Flux path | flows **radially**, rotor → stator | flows **along the axis** |
| Trade-off | simple, familiar, cheap | higher **torque density**, but mechanically more complex |

---

## 4. Choosing a Motor

> **Step 0 — mindset.** *Code can't fix a bad motor choice.* Selection comes **before** control design, not after.

The slides lay out a three-step procedure.

**Step 1 — Define the application (the most important step).** Pin down what you actually need:

- **Required torque** — how heavy is the load?
- **Required speed** — how fast must the system move?
- **Accuracy** — do you truly need high precision?
- **Price** — do you really need the expensive motor?

**Step 2 — Choose the motor type.** Linear or rotary? Stepper or servo? Brushed or brushless? Each answer follows from Step 1.

**Step 3 — Read the spec sheet carefully.** Check the **torque–speed curve** against your operating range, find the **peak/limit values** (every motor has limits), and note the **torque constant** so you can predict torque from current.

### 4.1 Key Spec-Sheet Parameters

| Parameter | Meaning |
|-----------|---------|
| **Nominal voltage** | the rated voltage the motor is designed for |
| **No-load speed** | the speed at nominal voltage with **no load** |
| **Stall torque** | the **maximum** torque, produced at **zero speed** (rotor held still, the instant it starts to move) |
| **Max continuous current** | the highest current it can carry **continuously** without overheating |
| **Max continuous torque** | the highest torque it can deliver continuously without overheating |
| **Torque constant $K_t$** | torque produced per unit **current** |
| **Speed constant $K_v$** | speed produced per unit **voltage** |

### 4.2 Estimating Performance from the Constants

The two constants turn the spec sheet into quick predictions:

$$\boxed{\tau = K_t  I} \qquad\qquad \boxed{\omega = K_v  V}$$

Know the current, estimate the torque; know the voltage, estimate the speed. (We will see in §6 that $K_t$ and $K_v$ are actually the *same physical constant* in consistent SI units — torque-per-amp and back-EMF-per-rad/s are two faces of one electromechanical coupling.)

### 4.3 The Torque–Speed Curve

The torque–speed curve is the motor's **safe operating envelope**. The two anchor points are the ones above: **stall torque** on the torque axis (zero speed) and **no-load speed** on the speed axis (zero torque); for a DC motor the line between them is roughly straight.

- Keep your system inside the **recommended continuous range** — sustained operation there won't overheat the motor.
- If your demand falls **outside** that range, you generally need a **different motor**.
- For **very brief** moments you can exceed the continuous range (higher torque/speed) — but only briefly, or you cook the windings.

> ⚠️ **Stall is the dangerous corner.** At stall, speed is zero so the back-EMF is zero (§6), and the only thing limiting current is the small armature resistance. Current — and therefore heating — is at its worst exactly when the motor isn't moving. This is why "max continuous current" matters most near stall.

### 4.4 Group Challenge — Worked Logic (Maxon RE 25)

> **Scenario.** A delivery robot must climb a slope needing a **constant 20 mN·m** of torque, using a **Maxon RE 25 (118752)**.
> **Goal 1.** Prove by calculation whether the motor handles the task **without overheating**.
> **Goal 2.** What if the slope steepens to **50 mN·m**?

The reasoning pattern (numbers come from the spec sheet you read in class):

1. **Is 20 mN·m below the max *continuous* torque?** If yes, the motor can hold it indefinitely. Cross-check the current it implies, $I = \tau / K_t$, against the **max continuous current** — both tests must pass.
2. **For 50 mN·m**, compare against continuous *and* stall torque. If 50 mN·m exceeds the continuous limit but is below stall, the motor can produce it only **transiently**; held constant on a long climb it will **overheat**. The honest conclusion is usually "fine for a short burst, not for a sustained 50 mN·m climb — pick a larger motor or add a gearhead."

> 💡 **The gearbox escape hatch.** A reduction gear multiplies torque by the gear ratio (at the cost of speed). Often the right answer to "not enough torque" isn't a bigger motor but a **gearhead** — which is exactly why Maxon sells them paired.

---

## 5. From a Motor to a *Model*

Everything above is qualitative. To **simulate** or **control** a motor we need equations. A DC motor is a beautiful teaching example because it lives in **two domains at once** — electrical and mechanical — linked by the magnetic field. We model each domain with the laws you already know, then couple them.

- **Electrical side** → **Kirchhoff's Voltage Law** (Chapter 2) applied to the *armature circuit*.
- **Mechanical side** → **Newton's second law** for rotation applied to the *shaft*.
- **The coupling** → two electromechanical relations: current makes **torque**, and rotation makes **back-EMF**.

The next two sections build each equation; §7 fuses them.

---

## 6. The Two Governing Equations of a DC Motor

### 6.1 Electrical Side — the Armature Circuit (KVL)

The rotor winding, seen from its terminals, is just a series circuit: a **resistance** $R_a$ (the copper wire), an **inductance** $L_a$ (the coil), and one new element — a voltage the *spinning motor generates by itself*, the **back-EMF** $e_b$. Apply KVL around the armature loop with applied voltage $v_a$:

$$\boxed{v_a = R_a  i_a + L_a\frac{di_a}{dt} + e_b}$$

Read it term by term, exactly as in Chapter 2.1: $R_a i_a$ is the resistive drop, $L_a di_a/dt$ is the inductor's "resists sudden current change" term, and $e_b$ is the motor pushing back against its own supply.

**Where the back-EMF comes from.** A spinning coil in a magnetic field is a **generator** (Faraday's law, Chapter 2.1). So the moment the rotor turns, it generates a voltage that, by **Lenz's law, opposes the very voltage driving it**. That induced voltage is proportional to how fast the shaft spins:

$$\boxed{e_b = K_e \omega}$$

where $\omega$ is the angular velocity and $K_e$ is the **back-EMF (speed) constant**.

> 💡 **Back-EMF is the motor's built-in speed governor.** As the motor speeds up, $e_b = K_e\omega$ rises, which *shrinks* the net voltage $v_a - e_b$ available to push current, so the current — and thus the torque — drops. The motor naturally settles at the speed where torque just balances the load. No back-EMF, no self-regulation: this single term is why a DC motor doesn't run away. It is also why current is highest at **stall** ($\omega = 0 \Rightarrow e_b = 0$).

### 6.2 Mechanical Side — Rotational Dynamics (Newton)

The shaft is a rotating mass. Newton's second law for rotation says the inertia times angular acceleration equals the net torque:

$$\boxed{J\frac{d\omega}{dt} + b \omega = \tau_m - \tau_L}$$

- $J$ — rotor + load **inertia**
- $b$ — **viscous friction** coefficient (a damping torque $\propto \omega$)
- $\tau_m$ — the **motor torque** the windings produce
- $\tau_L$ — the external **load torque** (the slope, the payload, …)

**Where the motor torque comes from.** The force on a current-carrying conductor in a magnetic field ($F = BIL$) becomes, summed over the windings, a torque proportional to the armature current:

$$\boxed{\tau_m = K_t  i_a}$$

with $K_t$ the **torque constant** — the same $\tau = K_t I$ used for spec-sheet estimates in §4.2.

### 6.3 The Two Constants Are One

Conservation of energy forces the electrical-to-mechanical and mechanical-to-electrical conversions to use the **same** constant. In consistent SI units:

$$\boxed{K_t = K_e  \equiv  K}\qquad [ \text{N·m/A} = \text{V·s/rad} ]$$

> ⚠️ **Why they look different on a spec sheet.** Manufacturers quote $K_t$ in mN·m/A and $K_v$ in rpm/V, so the printed numbers differ and even sit in different columns. That's a *unit* artifact — convert to SI and torque-per-amp equals volts-per-rad/s. They are one electromechanical coupling viewed from the two sides.

### 6.4 The Coupled System — How the Two Equations Talk

Put the pieces together and notice the **feedback loop** built into the physics:

$$
\underbrace{v_a = R_a i_a + L_a\frac{di_a}{dt} + K_e\omega}_{\text{electrical}}
\qquad
\underbrace{J\frac{d\omega}{dt} + b\omega = K_t i_a - \tau_L}_{\text{mechanical}}
$$

Trace the loop: voltage drives **current** → current makes **torque** → torque spins the shaft, raising **$\omega$** → $\omega$ makes **back-EMF**, which feeds back into the electrical equation and limits the current. The current $i_a$ and speed $\omega$ are mutually dependent — which is exactly why we can't solve one equation alone and need the **state-space** machinery of §8.

> 💡 **The thread from Chapter 2.2.** There we saw a mass behaves like an inductor and a damper like a resistor — *impedance is universal.* The DC motor is that analogy made literal: the electrical inductor $L_a$ and the mechanical inertia $J$ are the two energy-storing states, coupled through $K$. The motor is one system wearing two costumes.

---

## 7. System Dynamics: Order and Time Response

Before simulating, we classify the model. **Many real systems are linear ODEs with constant coefficients**, derived from Newton's laws (mechanical) and Kirchhoff's laws (electrical). We sort them by the **highest derivative** in the governing equation.

| Order | Highest derivative | Physical feel | Example |
|------|:---:|---|---|
| **Zero-order** | none | output instantly tracks input | ideal potentiometer |
| **First-order** | $dy/dt$ | one energy store; smooth exponential approach | RC circuit, motor speed (electrical part ignored) |
| **Second-order** | $d^2y/dt^2$ | two energy stores; can oscillate | mass–spring–damper, full DC motor |

### 7.1 First-Order Systems

A first-order system obeys

$$\boxed{\tau\frac{dy}{dt} + y(t) = K x(t)}$$

where $\tau$ is the **time constant**, $K$ the **gain (DC gain)**, $x$ the input, $y$ the output. The solution splits into two pieces (just like solving any linear ODE):

- **Homogeneous (transient) part** — the system's natural decay, $y_h(t) = C e^{-t/\tau}$. It dies out with time constant $\tau$.
- **Steady-state (particular) part** — what's left after the transient fades; for a step input of size $X$, $y_{ss} = KX$.

For a step input starting from rest, the full response is the classic exponential rise:

$$y(t) = KX\left(1 - e^{-t/\tau}\right)$$

> 💡 **What $\tau$ means.** After one time constant the response has covered **63%** of its final change; after $\sim 5\tau$ it's essentially done. Small $\tau$ = fast system. For a motor, the *electrical* time constant $L_a/R_a$ is usually far smaller than the *mechanical* one $J/b$ — which is why people often ignore $L_a$ and treat motor **speed** as first-order.

### 7.2 Second-Order Systems

A second-order linear homogeneous ODE with constant coefficients:

$$a x'' + b x' + c x = 0$$

Guess $x = e^{st}$, substitute, and divide out $e^{st}$ to get the **characteristic equation** — an algebraic stand-in for the calculus:

$$\boxed{a s^2 + b s + c = 0}$$

Its **roots set the behavior**, and the **discriminant $D = b^2 - 4ac$** decides which of three cases you're in:

| Case | Condition | Roots | Solution form | Behavior |
|------|:---:|---|---|---|
| **1. Overdamped** | $D > 0$ | two distinct real $s_1, s_2$ | $x = C_1 e^{s_1 t} + C_2 e^{s_2 t}$ | sluggish, no oscillation |
| **2. Critically damped** | $D = 0$ | one repeated real $s$ | $x = (C_1 + C_2 t) e^{s t}$ | fastest non-oscillating |
| **3. Underdamped** | $D < 0$ | complex pair $\sigma \pm j\omega_d$ | $x = e^{\sigma t}(C_1\cos\omega_d t + C_2\sin\omega_d t)$ | oscillates, decaying |

> 💡 **The discriminant is the damping switch.** $D>0$ means friction dominates (crawls to rest); $D<0$ means inertia/stiffness dominate (it overshoots and rings); $D=0$ is the knife-edge between them — the **critically damped** case engineers aim for when they want the quickest settle with *no* overshoot. This is the same $\zeta$ (damping ratio) story you'll meet in vibrations: $\zeta>1$, $\zeta=1$, $\zeta<1$.

> ⚠️ **Complex roots are not "imaginary motion."** A complex root pair $\sigma \pm j\omega_d$ describes a perfectly real, physical oscillation: the **real part $\sigma$** sets how fast the envelope decays (it must be negative for stability), and the **imaginary part $\omega_d$** sets the ringing frequency. Same $\frac{d}{dt}\leftrightarrow j\omega$ spirit as Chapter 2.2 — the algebra of complex numbers encodes "decay + oscillation" in one symbol.

---

## 8. Simulation: State-Space Form and `ode45`

We have two coupled equations (§6.4), one with $di_a/dt$ and one with $d\omega/dt$. To hand them to a numerical solver we put them in **state-space form** — the single most useful representation for simulation.

### 8.1 What State-Space Is

> **State-space form represents a dynamic system as a set of *first-order* differential equations.** The **state variables** are the system's internal memory: they store everything about the past needed to predict the future. Give the solver the current state and the input, and it can step forward.

The rule of thumb: **one state per independent energy store.** The DC motor has two — the inductor (electrical energy, $\tfrac12 L i^2$) and the inertia (kinetic energy, $\tfrac12 J\omega^2$) — so we need **two states**:

$$x_1 = \omega  (\text{shaft speed}), \qquad x_2 = i_a  (\text{armature current}).$$

### 8.2 Building the Two First-Order Equations

Solve each governing equation in §6.4 for its top derivative.

**From the mechanical equation** ($J\dot\omega + b\omega = K i_a - \tau_L$):

$$\dot{x}_1 = \dot\omega = -\frac{b}{J} \omega + \frac{K}{J} i_a - \frac{1}{J}\tau_L$$

**From the electrical equation** ($v_a = R_a i_a + L_a\dot{i}_a + K\omega$):

$$\dot{x}_2 = \dot{i}_a = -\frac{K}{L_a} \omega - \frac{R_a}{L_a} i_a + \frac{1}{L_a} v_a$$

### 8.3 Matrix Form

Stack them ($\tau_L = 0$ for simplicity; input $u = v_a$):

$$
\boxed{ 
\begin{bmatrix}\dot\omega \\[4pt] \dot{i}_a\end{bmatrix}
=
\begin{bmatrix} -\dfrac{b}{J} & \dfrac{K}{J} \\[8pt] -\dfrac{K}{L_a} & -\dfrac{R_a}{L_a} \end{bmatrix}
\begin{bmatrix}\omega \\[4pt] i_a\end{bmatrix}
+
\begin{bmatrix} 0 \\[4pt] \dfrac{1}{L_a} \end{bmatrix} v_a
 }
$$

This is the standard $\dot{\mathbf{x}} = A\mathbf{x} + Bu$. The **off-diagonal terms $+K/J$ and $-K/L_a$ are the electromechanical coupling** — they are literally the back-EMF and the motor-torque links from §6.4. The minus sign on $-K/L_a$ *is* Lenz's law in matrix form. **Now we're ready to code.**

### 8.4 Why We Solve It Numerically

You *could* solve this 2-state linear system by hand. But the slides make the broader point: real engineering models are often **nonlinear or uncertain**, so **exact analytical solutions are frequently impossible**. The general tool is **numerical integration** — stepping the state forward in small time steps using numbers instead of formulas:

- MATLAB's **`ode45`** integrates $\dot{\mathbf x} = f(t,\mathbf x)$ over time. It's based on the **Runge–Kutta** method (a smarter cousin of Euler's method that takes trial sub-steps and weights them for accuracy).
- It needs only **three inputs** — don't be nervous:

| Input | Meaning |
|-------|---------|
| `odefun` | a function returning $\dot{\mathbf x}$ — *your* system dynamics |
| `tspan` | the time range `[start end]` |
| `y0` | the **initial conditions** of the states |

It returns `t` (the time points it chose) and `x` (the state at each one). *(Background video referenced in class: `ode45` tutorial, youtu.be/-DmTK868J4A.)*

### 8.5 The DC Motor in MATLAB

The dynamics function encodes the matrix from §8.3. With states `x(1)=`$\omega$ and `x(2)=i_a`:

```matlab
function dx = odefun(t, x)
    % --- Motor parameters (from the spec sheet) ---
    Ra = 1.0;     % armature resistance [Ohm]
    La = 0.5e-3;  % armature inductance [H]
    K  = 0.01;    % torque = back-EMF constant [N·m/A = V·s/rad]
    J  = 2e-5;    % rotor inertia [kg·m^2]
    b  = 1e-6;    % viscous friction [N·m·s]
    Va = 12;      % applied armature voltage [V]

    omega = x(1);
    ia    = x(2);

    % --- State equations (Section 8.3) ---
    domega = (-b/J)*omega + (K/J)*ia;          % mechanical
    dia    = (-K/La)*omega - (Ra/La)*ia + Va/La; % electrical

    dx = [domega; dia];
end
```

```matlab
% --- Run the simulation ---
tspan = [0 2];     % simulate 0 to 2 seconds
x0    = [0; 0];    % initial state [omega; ia], both start at rest

[t, x] = ode45(@(t,x) odefun(t,x), tspan, x0);

plot(t, x(:,1));   % shaft speed omega vs. time
xlabel('Time (s)'); ylabel('\omega (rad/s)');
```

> 💡 **What the plot shows — and how it ties the chapter together.** At $t=0$ the current rushes up (small $L_a/R_a$ → fast electrical transient), torque spins the rotor, and $\omega$ climbs. As $\omega$ rises, **back-EMF grows and throttles the current**, so the speed eases into a steady value — a textbook second-order rise toward $\omega_{ss}\approx V_a/K$. You are watching §6's coupling and §7's transient response play out in one curve. *(Quiz 3 builds on exactly this setup.)*

> ⚠️ **`@(t,x) odefun(t,x)` — why the wrapper?** `ode45` insists on calling a function of `(t, x)` only. The **anonymous function** `@(t,x) ...` is how you pass *extra* things (a different voltage, a load profile) into `odefun` while still handing `ode45` the two-argument function it expects.

---

## Key Takeaways

- An **actuator** makes a system act; **DC motors** are the workhorse electrical actuator. *Code can't fix a bad motor choice* — selection comes first.
- A motor spins because the **commutator keeps flipping the rotor's magnetic poles** (via current reversal, set by the right-hand rule), so the rotor is always chasing a target that just moved.
- **Brushed** = mechanical commutation (brushes wear); **BLDC** = electronic commutation (a controller makes a rotating field). In a BLDC, three **Hall sensors** encode rotor position as a **3-bit code** (six valid states = six 60° sectors), and each code selects which two of the **U-V-W** phases to energize — **six-step commutation**. See the [live Hall-commutation demo](https://aimlabvideo-collab.github.io/ME435-Mechatonics/simulation/chapter3/BLDC_Hall_3Phases/bldc_hall_demo.html). **Servo** = position by pulse *width*; **stepper** = position by pulse *count*.
- **Select** a motor by defining the application, picking a type, then reading the spec sheet. Use $\tau = K_t I$ and $\omega = K_v V$, and stay inside the **torque–speed curve**; respect continuous limits (current is worst at **stall**).
- A DC motor is **two coupled equations**: the armature circuit $v_a = R_a i_a + L_a di_a/dt + K_e\omega$ (KVL) and the rotation $J d\omega/dt + b\omega = K_t i_a - \tau_L$ (Newton). **Back-EMF** $K_e\omega$ is the coupling that self-regulates speed; $K_t = K_e$ in SI units.
- Classify systems by order: **first-order** has one time constant $\tau$ (63% in one $\tau$); **second-order** behavior is decided by the **discriminant** of its characteristic equation — over-, critically, or under-damped.
- **State-space form** = one first-order equation per energy store. The motor's two states are $\omega$ and $i_a$; the off-diagonal $A$ terms *are* the electromechanical coupling.
- **`ode45`** numerically integrates $\dot{\mathbf x}=f(t,\mathbf x)$ from just `odefun`, `tspan`, and `y0` — letting us predict motor behavior before building hardware.

---

## Course Materials

- 📊 Slides: Chapter 3-1 — Motor and System Dynamics; Chapter 3-2 — DC Motor Simulation with MATLAB
- 🖱️ Live demo: [**BLDC Hall-sensor commutation**](https://aimlabvideo-collab.github.io/ME435-Mechatonics/simulation/chapter3/BLDC_Hall_3Phases/bldc_hall_demo.html) — an interactive page (no install) where you spin the rotor and watch the three Hall sensors form a 3-bit code that drives the U-V-W phases (§3.1.1).
- 💻 MATLAB simulation: [Chapter 3 code on GitHub](https://github.com/aimlabvideo-collab/ME435-Mechatonics/tree/main/simulation/chapter3) — DC motor step response (`ode45`). The folder's README explains how to run it and how to clone the code.
- 📒 Prerequisites: [Chapter 2.1 — Electrical Circuits and Components](ch2_1-electrical-circuits.md) (KVL, R/L/C elements) · [Chapter 2.2 — AC Circuits and Impedance](ch2_2-ac-circuit-and-impedance.md) (the mass↔inductor, damper↔resistor analogy)
- 🎥 Background: `ode45` tutorial — youtube.com/watch?v=-DmTK868J4A
