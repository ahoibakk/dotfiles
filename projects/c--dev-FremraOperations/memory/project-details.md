# TripletexCommissionSalary - Detailed Notes

## Architecture

Single-page Razor Pages app. Most logic lives in:
- `SalaryCalculator.cs` (Web project) - pure calculation, no API calls
- `TripletexClient.cs` (Shared) - all Tripletex API calls
- `Index.cshtml.cs` - orchestrates: load timesheets → calculate → optionally post salary

## Tripletex API
- Auth: Basic auth with "0:sessionToken" (Base64 encoded)
- Session token stored in `~/.tripletex/config.json` or env var `TRIPLETEX_SESSION_TOKEN` (env takes priority)
- Token generation: run `TripletexCommissionSalary.CreateToken` console app (creates 10-year token)
- JSON responses have variable structure; `JsonHelper.cs` uses recursive search to find arrays

## Norwegian-specific logic
- "Grunnbeløp" (G) = base salary unit from NAV API, used for minimum salary floor (6G/12 per month)
- Voucher date = 10th of month, adjusted back if weekend/holiday
- `NorwegianBusinessDay.cs` implements Computus algorithm for Easter date calculation

## Testing
- `FakeHandler.cs` mocks HttpMessageHandler for Tripletex API tests
- Tests cover: TokenStore save/load, JsonHelper parsing, TripletexClient HTTP calls

## Deployment
- GitHub Actions: `.github/workflows/main_tripletexcommissionsalary.yml`
- Builds → publishes Web project only → deploys to Azure App Service
- Production credentials via Azure publish profile secret
