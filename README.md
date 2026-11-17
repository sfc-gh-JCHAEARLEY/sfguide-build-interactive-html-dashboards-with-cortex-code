# Build Interactive HTML Dashboards with Cortex Code

Companion code for the Snowflake quickstart **Build Interactive HTML Dashboards with Cortex Code**.

The guide is prompt-driven: each step gives you a prompt for Cortex Code (CoCo), explains which words in the prompt produce which feature or animation, and tells you what to check. This repo has the sample data and a finished example of every report, so you can compare your result with one built from the same prompt.

## Contents

| Path | What it is |
|---|---|
| `setup.sql` | Creates `HTML_REPORTS_QS.DEMO` with five small synthetic tables |
| `teardown.sql` | Drops `HTML_REPORTS_QS` |
| `reports/` | One HTML report per prompt in the guide |

## Reports

| File | Guide step | Shows |
|---|---|---|
| `01-q3-revenue-review.html` | Build Your First Report | Count-up KPIs, bar and doughnut charts, collapsed View SQL, summary table |
| `02-q3-revenue-review-edited.html` | Iterate with Targeted Edits | Report 01 after the three edit prompts: highlighted bar with $M labels, "What changed vs Q2" callout, sortable table |
| `03-qbr-slide-deck.html` | Turn Findings into a Slide Deck | Full-bleed slides, arrows, dots, slide counter, wrap-around, arrow keys, crossfade |
| `04-weekly-digest-spec.html` | Build a Designed Spec with a Prototype | Toggle switch, day picker, live "Next digest" line, animated panel |
| `05-chartjs-weekly-active-users.html` | Realm of Possible: Charts | Chart.js range slider, line/bar toggle, seeded Randomize |
| `06-plotly-query-latency.html` | Realm of Possible: Charts | Plotly log-log scatter, zoom/pan/hover, Add cohort, Reset, legend toggles |
| `07-vegalite-brush-crossfilter.html` | Realm of Possible: Charts | Vega-Lite brush on a scatter filtering a bar chart |
| `08-d3-dependency-network.html` | Realm of Possible: Networks, 3D, and Diagrams | D3 force graph: drag, neighbor highlight, Shake it |
| `09-threejs-credits-skyline.html` | Realm of Possible: Networks, 3D, and Diagrams | Three.js 3D bars: orbit, hover tooltip, idle auto-rotate, grow-in |
| `10-mermaid-publish-flow.html` | Realm of Possible: Networks, 3D, and Diagrams | Mermaid flowchart and sequence diagram |
| `11-katex-live-math.html` | Realm of Possible: Live Math and Markdown | Live LaTeX editor with presets |
| `12-markdown-live-preview.html` | Realm of Possible: Live Math and Markdown | Live Markdown preview with code highlighting |
| `13-capstone-showcase.html` | Capstone: A Full Showcase Page | Hero, scroll-tracking sticky nav, tabbed demos, count-up stats, sticky footer |

## Viewing the reports

The reports load their libraries from Snowflake's vendored `/libs/` path, so open them where that path is served:

- **Snowsight Workspaces:** upload the file to a workspace and open it.
- **CoCo Desktop:** open the file in your project.

Opened directly from disk in a browser, charts won't render because `/libs/` doesn't exist there.

Each report embeds the data it was built from. The numbers come from `setup.sql`, which uses random values, so a report you generate will show different numbers than these examples.
