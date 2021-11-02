LABELS:

- TRAP
- CRAP (discard)

FILTER:

- Any email where the sender is NOT in the whitelist OR the blacklist gets the TRAP (and skips the inbox)
- Any email where the sender is in the blacklist gets the CRAP (and skips the inbox)

APP:

- Any email where we whitelist or blacklist the sender get TRAP label removed
  - whitelist: send to the inbox.
  - blacklist: add CRAP label.

Pro:
Most features work free of the app.
Cons:
Managing the filters could get tricky, as they are limited to 16000 characters for the criteria.
If the app goes down, no easy way to manage trapped emails without manually disabling filters

---

Use push notifications (via webhooks) from Google/GMail to notify our app of new messages, and
and check the blacklist/whitelist we keep internally to apply/remove labels.

LABELS:

- TRAP
- CRAP (discard)

Pro:
Likely a simpler implementation overall, no limit to the number of emailaddresses that can be black/white listed

Cons:
If the app goes down, no functionality at all. NOOP
