# Three Cities

**Live site: https://pinklesoni.github.io/three-cities/**

Reader site for Pinkle's romcom trilogy: the cast, the setup, the three books, an author's note and an open comment wall.

Plain HTML, no build step. Comments are stored in Supabase (free tier).

## Turn on comments

1. Create a free project at supabase.com.
2. In the project, open **SQL Editor → New query**, paste the contents of `supabase-setup.sql` and click **Run**.
3. Open **Project Settings → API** and copy the **Project URL** and the **anon / publishable** key.
4. Paste both into `config.js`. Never use the `service_role` key here.

Until `config.js` is filled in, the page shows "Comments are opening soon" and links readers to Wattpad.

## Moderate

In Supabase, open **Table Editor → comments**. Set `hidden` to `true` on a row to hide it from the site, or delete the row.

## Preview locally

```bash
python3 -m http.server 4321
```

Then open http://localhost:4321.
