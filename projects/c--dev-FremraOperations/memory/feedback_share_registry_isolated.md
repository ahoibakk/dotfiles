---
name: ShareRegistry er et eget domene — ikke trekk inn i CRM/Activities-arbeid
description: Aksjeregister og CRM/Activities er separate domener; ikke bruk det ene som mønster eller inspirasjon for det andre
type: feedback
originSessionId: 3b1def72-35e7-4861-95b6-25890663bce4
---
ShareRegistry (aksjeregister, cap table, `Pages/Shareholders/`, `Shared/Shareholders/`) og CRM/Activities (`Pages/Crm/`, `Shared/Crm/`) er to separate domener. De har ingenting med hverandre å gjøre og må aldri blandes.

**Why:** Da jeg planla CRM-audit-logg (fase 6.4), foreslo jeg å «speile ShareRegistryAuditLog-mønsteret». Eier sa eksplisitt: «ShareRegistryAuditLog er noe HELT annet og må aldri blandes. ShareRegistry og /Activities har ingenting med hverandre å gjøre.» Even mønster-referanser som «inspirert av X» fra et annet domene er forvirrende — det kobler ting som ikke skal være koblet, og åpner for at noen senere lurer på om de skal dele infrastruktur.

**How to apply:**
- Når jeg planlegger eller implementerer noe i `Pages/Crm/` eller `Shared/Crm/`: ikke trekk inn ShareRegistry som referanse, eksempel, eller mønster, selv om koden ser strukturelt lik ut.
- Generiske mønstre (audit-logg, RowVersion, FK-er) beskrives på egne premisser — ingen «mirror», «speil», «inspirert av» fra et annet domene.
- Samme regel gjelder andre veien (CRM som mønster for ShareRegistry) og generelt mellom alle separate domener i kodebasen — Salary, Allocation, Tripletex, Platforms, Flowcase er også selvstendige.
- Hvis to domener faktisk trenger samme abstraksjon, snakk om det som en egen avklaring først, ikke smug det inn via planreferanse.
