# Product Funnel & Retention Dashboard

End-to-end funnel and retention analysis on e-commerce event data:
where users drop off, and who comes back.

## Stack
- **SQL** (DuckDB) — funnel, drop-off, cohort retention
- **Dashboard** — (Power BI / Tableau, coming soon)

## Dataset
`events.csv` — 9,676 events across 4,000 users.
Columns: event_id, user_id, event_name, event_date, channel, user_type.
Funnel events: signup → activation → purchase.

## Findings so far
| Step | Users | Drop-off |
|------|-------|----------|
| Signup | 4,000 | — |
| Activation | 2,911 | 27% lost |
| Purchase | 1,410 | 52% of activated lost |

**Biggest leak:** activation → purchase. Over half of activated users never buy.

## Files
- `01_funnel.sql` — conversion funnel by step