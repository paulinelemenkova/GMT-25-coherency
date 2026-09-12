# GMT Coherency — Gravity-Bathymetry Spectral Coherence Scripts

GMT (Generic Mapping Tools) shell scripts for spectral analysis of the marine gravity field and seafloor relief. Using the 2D Fast Fourier Transform, the scripts compute the cross-spectrum and coherence between gravity and bathymetry/topography grids, a proxy for lithospheric isostasy and flexural response, and present the input fields as a multi-panel figure. The scripts have been used to generate figures in the author's marine-geophysical publications.

## What the scripts do

- extract regional subsets from global grids (grdcut) and satellite-gravity .img grids (img2grd)
- compute the 2D FFT cross-spectrum and coherence between gravity and bathymetry (grdfft) with detrending, tapering and grid extension
- generate colour palettes (makecpt) for each field
- render multi-panel maps (grdimage, psbasemap): bathymetry, geoid, free-air gravity, vertical gravity gradient, and detrended/extended fields
- plot the coherence-squared spectrum versus wavelength with error bars (psxy)
- add annotations and the GMT logo (pstext, logo)
- export to raster (psconvert) at high resolution

## Data sources

- Relief / bathymetry: GMT earth_relief (ETOPO1, 1 arc-minute)
- Gravity and vertical gravity gradient: Sandwell/Smith satellite-altimetry .img grids (converted with img2grd)
- Geoid: EGM96 global model

## Files

- Coherency.sh, Coherency_CF.sh: full gravity-bathymetry coherence workflows
- example_37.sh: the GMT 2D-FFT / coherence example the workflow is based on

## Requirements

- GMT 6.x (Generic Mapping Tools): https://www.generic-mapping-tools.org
- A POSIX shell (bash)
- The relevant relief grid, gravity .img grid and geoid grid available locally

## Usage

Place the required grids in the working directory, adjust the -R regions at the top of the script, then run:

    bash Coherency.sh

The script writes a PostScript file and converts it to a raster image (JPG/PNG) via psconvert.

## Author and citation

Polina Lemenkova
ORCID: https://orcid.org/0000-0002-5759-1089

These scripts accompany figures in the author's marine-geophysical papers; please cite the specific article a given figure appears in. The full publication list is available via the ORCID record above.

## License

See the LICENSE file in this repository.
