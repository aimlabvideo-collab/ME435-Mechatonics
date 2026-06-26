# BLDC Hall-Sensor Commutation — Live Demo

An interactive, browser-only visualization of how a **brushless DC (BLDC)** motor
commutates electronically. It accompanies **Chapter 3, §3.1.1** of the course notes.

## ▶ Open the live demo (no install)

**<https://aimlabvideo-collab.github.io/ME435-Mechatonics/simulation/chapter3/BLDC_Hall_3Phases/bldc_hall_demo.html>**

Just click the link — it runs in any modern browser.

## What it shows

- Three **Hall sensors** (spaced 120° around the stator) read the rotor's magnet
  poles and output **1 / 0**, forming a 3-bit code `A B C`.
- The six valid codes map to **six 60° sectors** of one electrical revolution
  (`000` and `111` never occur).
- Each code selects which **two of the three phases (U, V, W)** are energized and
  which one floats — **six-step (trapezoidal) commutation**.
- The energized phases make a stator field that stays ~90° ahead of the rotor, so
  the rotor keeps "chasing" — continuous torque without brushes.
- A rolling scope plots the three Hall outputs as square waves, 120° out of phase.

## How to use it

- **Play / Pause** the rotation, or **Step** one sector at a time.
- **Drag the rotor** inside the circle to scrub position by hand and watch the
  Hall code and the energized phases change.
- Adjust **Speed** and toggle **Show drive field**.
- Keyboard: **Space** = play/pause.

## Files

| File | Purpose |
|------|---------|
| `bldc_hall_demo.html` | The entire self-contained demo (HTML + CSS + JS, no dependencies). |

## How to get the code

**Option A — view it live:** use the link above.

**Option B — run it locally:** download `bldc_hall_demo.html` (on GitHub, open the
file and click **"Download raw file"**) and double-click it to open in a browser.

**Option C — clone the whole course repository:**

```bash
git clone https://github.com/aimlabvideo-collab/ME435-Mechatonics.git
cd ME435-Mechatonics/simulation/chapter3/BLDC_Hall_3Phases
```

Then open `bldc_hall_demo.html` in your browser. Run `git pull` to get updates.
