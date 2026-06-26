# Chapter 3 — DC Motor Simulation (MATLAB)

A state-space simulation of a brushed DC motor's **step response**, matching the
coupled electrical + mechanical model derived in Chapter 3.

## Files

| File | Purpose |
|------|---------|
| `dc_motor_sim.m` | Main script — set the parameters, run `ode45`, plot current and speed. |
| `dc_motor_ode.m` | The two coupled state equations (called by the solver). |
| [`BLDC_Hall_3Phases/`](BLDC_Hall_3Phases/) | Interactive **BLDC Hall-sensor commutation** demo (browser-only). [Open it live.](https://aimlabvideo-collab.github.io/ME435-Mechatonics/simulation/chapter3/BLDC_Hall_3Phases/bldc_hall_demo.html) |

## What it does

Applies a step voltage to a motor starting from rest and integrates

```
d(omega)/dt = -(b/J) omega + (K/J) i_a - (1/J) tau_L     (Newton)
d(i_a)/dt   = -(K/La) omega - (Ra/La) i_a + (1/La) v_a    (KVL, with back-EMF)
```

producing plots of armature current `i_a(t)` and shaft speed `omega(t)`.

## Run it

1. Put `dc_motor_sim.m` and `dc_motor_ode.m` in the same folder.
2. Open `dc_motor_sim.m` in MATLAB and press **Run** (F5).
3. Change `p.v_a` (voltage), `p.tau_L` (load torque), or the motor constants at
   the top of the script to experiment.

Uses only built-in `ode45` — no extra toolboxes required.

## How to get the code

**Option A — download a single file:** open the file on GitHub and click
**“Download raw file.”**

**Option B — clone the whole course repository (recommended):**

```bash
git clone https://github.com/aimlabvideo-collab/ME435-Mechatonics.git
cd ME435-Mechatonics/simulation/chapter3
```

Then open the `.m` files in MATLAB. To get later updates, run `git pull` inside
the folder.

> CSUN students can install MATLAB for free — see the **Resources** page on the
> course site.
