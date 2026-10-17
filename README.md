# Recipe Community

Global recipe-first community app. This monorepo holds the NestJS API and Flutter mobile client. Product requirements live in [prd.md](prd.md).

## Apps

| Path | Stack | Role |
| --- | --- | --- |
| `apps/api` | NestJS, Prisma, PostgreSQL | REST API under `/api/v1` |
| `apps/mobile` | Flutter | Android and iOS client |

JavaScript packages are managed with **pnpm** and **Turborepo**. Flutter uses **pub**.

## Prerequisites

- Node.js 22+ (see `.nvmrc`)
- pnpm 12
- A [Supabase](https://supabase.com) project (hosted PostgreSQL)
- Flutter SDK (for the mobile app)

## Setup

```bash
pnpm install
cp apps/api/.env.example apps/api/.env
```

In the Supabase dashboard open **Project Settings → Database → Connection string** and paste into `apps/api/.env`:

- `DATABASE_URL` — **Transaction** pooler (port `6543`). Append `?pgbouncer=true`.
- `DIRECT_URL` — **Session** pooler or direct connection (port `5432`). Prisma uses this for `migrate` / `db push`.

Prisma client is generated on `pnpm install`. After the database schema is designed, run migrations from `apps/api`:

```bash
pnpm --filter api prisma:migrate
# or, during early development:
pnpm --filter api prisma:push
```

## Development

```bash
pnpm dev                 # API watch mode (and Flutter if a device is attached)
pnpm --filter api dev    # NestJS only, http://localhost:4000
cd apps/mobile && flutter run
```

- Health: [http://localhost:4000/api/v1/health](http://localhost:4000/api/v1/health)
- Swagger: [http://localhost:4000/api/docs](http://localhost:4000/api/docs)

The API connects to **Supabase PostgreSQL** via Prisma (`DATABASE_URL` + `DIRECT_URL`). NestJS does not use the Supabase JS client for data access.

## Scripts

```bash
pnpm lint
pnpm test
pnpm build
```

Mobile scripts wrap Flutter (`lint` → `dart analyze`, `test` → `flutter test`). Riverpod, GoRouter, and Dio are intentionally not added yet; they belong in the next product phase.
