# Chapter 4 — Low Pass Filter Simulation (MATLAB)

A signal made of a DC offset plus three sine waves is corrupted by high
frequency noise, then cleaned up with a **low pass filter**. Every step is
shown in both the time domain and the amplitude spectrum.

## Files

| File | Purpose |
|------|---------|
| `low_pass_filter.m` | Main script — build the signal, add noise, design the filter, plot the spectra. |

## What it does

| Section | Content |
|---------|---------|
| 1–2 | Input `x_in = 0.8 + 0.5 sin(10t) + 0.7 sin(20t) + 0.9 sin(30t)` and its amplitude spectrum. The peaks land on 0.5 / 0.7 / 0.9 as expected. |
| 3–4 | Adds noise at 250 and 400 rad/s — the spectrum now shows two clearly separated bands. |
| 5 | 4th order Butterworth filter, cut-off `wc = 100 rad/s` placed **between** the two bands. `filtfilt` runs the filter forward and backward, so there is no phase lag. |
| 6 | Noisy input, clean signal and filtered output plotted together in time. |
| 7 | Spectrum before and after filtering — the signal band survives, the noise band is gone. |

Two things worth remembering:

```matlab
[b, a] = butter(n, fc/(fs/2), 'low');   % cut-off normalized by Nyquist (fs/2)
```

`butter` works in Hz, so a cut-off given in rad/s must be converted first:
`fc = wc/(2*pi)`.

```matlab
amp = sqrt(2*power);      % pspectrum returns POWER; a sine of amplitude A gives A^2/2
amp(1) = amp(1)/2;        % DC has no mirrored -f component, so it is not doubled
```

## Run it

1. Open `low_pass_filter.m` in MATLAB and press **Run** (F5).
2. Things to try:
   - move the cut-off `wc` below 30 rad/s — the signal itself starts to disappear;
   - lower `n_order` to 1 or 2 — the noise is only partly removed;
   - replace `filtfilt` with `filter` — the output now lags in time.

Requires the **Signal Processing Toolbox** (`pspectrum`, `butter`, `filtfilt`).

## How to get the code

**Option A — download a single file:** open the file on GitHub and click
**“Download raw file.”**

**Option B — clone the whole course repository (recommended):**

```bash
git clone https://github.com/aimlabvideo-collab/ME435-Mechatonics.git
cd ME435-Mechatonics/simulation/chapter4
```

Then open the `.m` file in MATLAB. To get later updates, run `git pull` inside
the folder.

> CSUN students can install MATLAB for free — see the **Resources** page on the
> course site.
