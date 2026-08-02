# Personal Website

This is my personal website.

To enable visitor analytics later, update the `analytics` section in `content.js`.

## Update visitor map

This site uses `visitor-map.json` for the map shown on the page.

For a semi-automatic update:

1. Put your latest country counts into `visitor-map-source.csv`
2. Run:

```powershell
.\update-visitor-map.ps1
```

That command will:

- regenerate `visitor-map.json`
- update `updatedAt` to today
- keep the map data in the format the website expects

The CSV file must have these columns:

```csv
Country,Count
United States,12
China,5
```
