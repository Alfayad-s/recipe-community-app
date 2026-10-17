# Recipe Community --- Product Requirements Document (PRD)

**Version:** 1.0\
**Status:** Planning\
**Product type:** Global, recipe-first community application\
**Clients:** Flutter for Android and iOS\
**Backend:** NestJS REST API\
**Database:** PostgreSQL\
**Primary ORM:** Prisma\
**Development model:** Solo developer\
**Business model:** Community-first; monetization deferred

------------------------------------------------------------------------

## 1. Executive Summary

Recipe Community is a global platform for people to publish structured
recipes, discover food from different cultures, save recipes, follow
home cooks, and share cooking knowledge.

The product is **recipe-first, not video-first**. Structured recipes are
the primary content type. Social features help people discover trusted
recipes and connect with creators.

The first release should validate the core loop:

1.  A user discovers a recipe.
2.  The user reads the ingredients and preparation steps.
3.  The user saves the recipe or follows its creator.
4.  A creator publishes a recipe.
5.  Other users interact with it through likes and comments.

The application should launch on Android and iOS from a shared Flutter
codebase. The backend should start as a modular monolith in NestJS to
keep development and deployment manageable for one developer.

## 2. Product Decisions

  -----------------------------------------------------------------------
  Decision                            Selected direction
  ----------------------------------- -----------------------------------
  Target audience                     Global cooking community

  Content format                      Structured recipes with photos;
                                      additional media can be supported

  Languages                           Regional and multilingual content,
                                      with a localized app interface

  Business model                      Community first; monetization
                                      considered after validation

  Platforms                           Android and iOS

  Development setup                   Solo developer

  Mobile framework                    Flutter

  Backend framework                   NestJS with TypeScript

  API style                           REST, versioned under `/api/v1`

  Database                            PostgreSQL

  ORM                                 Prisma

  Initial architecture                Modular monolith

  Media                               Object storage using signed uploads
  -----------------------------------------------------------------------

## 3. Vision and Positioning

### Vision

Create one welcoming community where people can share, discover,
preserve, and improve recipes from cultures around the world.

### Product positioning

Recipe Community combines the utility of a structured recipe book with
the participation of a social community. A cook can publish a family
recipe; another person can discover, save, cook, and comment on it.

### Differentiation opportunities

-   Structured recipes that are easy to follow while cooking.
-   Community feedback and, in a later phase, documented cooking
    attempts.
-   Regional cuisine and multilingual discovery.
-   Creator profiles and a simple following feed.
-   Recipe-linked photos and optional media without making video the
    primary content format.

These are product hypotheses to validate with early users, not claims
that competitors lack similar features.

## 4. Goals and Success Metrics

### Product goals

-   Make publishing a complete recipe easy and consistent.
-   Help users find recipes by title, ingredient, cuisine, category, and
    dietary preference.
-   Support meaningful community participation.
-   Help creators build a profile and following.
-   Support regional-language recipe content and localized UI.
-   Keep infrastructure and operational complexity suitable for a solo
    developer.

### Initial success targets

Targets are hypotheses for beta validation, not guarantees.

  -----------------------------------------------------------------------
  Metric                                                   Initial target
  ------------------------------ ----------------------------------------
  Onboarding activation             60% complete onboarding and perform a
                                                        meaningful action

  First recipe save                  40% of activated users save a recipe
                                                            within 7 days

  Creator activation                       20% of active users publish or
                                                contribute within 30 days

  30-day retention               20% of new users return in the following
                                                                    month

  Recipe completeness                       90% of published recipes have
                                                    ingredients and steps

  Crash-free sessions                          At least 99.5% during beta
  -----------------------------------------------------------------------

Track these metrics after launch and revise targets using observed
behavior.

## 5. User Personas and Roles

### 5.1 Home cook

Publishes family or personal recipes, discovers dishes, saves favorites,
and shares cooking knowledge.

### 5.2 Recipe creator

A regular user who builds a recipe collection, attracts followers,
receives feedback, and improves published recipes.

### 5.3 Recipe explorer

Searches recipes, applies filters, saves dishes, and follows creators.
This user may initially contribute little content.

### 5.4 Administrator or moderator

Reviews reports, handles harmful or misleading content, manages account
restrictions, and curates content.

Home cooks, creators, and explorers should use the same standard user
account. Administrative permissions should be separate and enforced on
the backend.

## 6. Scope and Priorities

Priority definitions:

-   **P0:** Required for the initial public MVP.
-   **P1:** Valuable follow-up after the core MVP is stable.
-   **P2:** Future enhancement.

  -----------------------------------------------------------------------
  Feature                 Scope                   Priority
  ----------------------- ----------------------- -----------------------
  Authentication          Registration, login,    P0
                          email verification,     
                          password reset, logout  

  User profile            Username, display name, P0
                          bio, avatar, locale,    
                          interests               

  Recipe authoring        Title, description,     P0
                          cover image,            
                          ingredients, steps,     
                          timing, servings,       
                          cuisine, tags           

  Drafts and publishing   Save draft, edit,       P0
                          publish, unpublish,     
                          delete own recipes      

  Home feed               Following feed and      P0
                          basic discovery feed    

  Recipe search           Title and ingredient    P0
                          search; cuisine and     
                          category filters        

  Community               Follow, unfollow, like, P0
                          comment                 

  Saved recipes           Bookmarks and basic     P0
                          collections             

  In-app notifications    Follows, likes, and     P0
                          comments                

  Moderation              Reports, moderation     P0
                          queue, content actions  

  Basic admin dashboard   Web interface for       P0
                          reports and             
                          account/content         
                          management              

  App localization        Localized UI and recipe P0
                          language metadata       

  Ratings and reviews     Numeric score and       P1
                          optional review text    

  Cooking attempts        Photo and notes from    P1
                          users who made a recipe 

  Push notifications      Device registration and P1
                          push delivery           

  Advanced feed ranking   Personalization based   P1
                          on engagement and       
                          preferences             

  Meal planner            Plan recipes by day     P2

  Shopping lists          Build a list from       P2
                          recipe ingredients      

  AI assistance           Recipe drafting and     P2
                          ingredient              
                          substitutions           

  Creator monetization    Subscriptions or other  P2
                          creator revenue         
                          features                

  Live cooking and chat   Real-time features      P2
  -----------------------------------------------------------------------

### MVP exclusions

Do not build initially:

-   Microservices or Kubernetes.
-   Real-time chat or live streaming.
-   Complex machine-learning recommendations.
-   Payment processing and creator subscriptions.
-   Grocery marketplace integrations.
-   Advanced video editing or a dedicated video-processing pipeline.
-   Separate mobile applications for administrators.
-   Nutrition data presented as medically reliable without validated
    sources.

## 7. Functional Requirements

### 7.1 Authentication and account management

-   Users can register with email and password.
-   Users can verify their email address.
-   Users can sign in, sign out, refresh a session, and reset a
    forgotten password.
-   Users can edit their profile and preferences.
-   The system enforces unique normalized email addresses and usernames.
-   Users can request account deletion.
-   Public browsing should be allowed where practical; authentication is
    required for actions such as saving, following, liking, commenting,
    and publishing.

### 7.2 User profiles

A profile should contain:

-   Username and display name.
-   Optional bio and avatar.
-   Preferred UI language.
-   Cuisine and dietary interests.
-   Public recipes.
-   Follower and following counts.
-   Account creation date or other appropriate public metadata.

Profile visibility and account deletion behavior must be defined before
launch.

### 7.3 Recipe creation and publishing

A recipe should support:

-   Title and description.
-   Cover image and optional additional images.
-   Ordered ingredients with quantity, unit, and optional notes.
-   Ordered preparation steps.
-   Preparation time, cooking time, total time, and servings.
-   Cuisine, category, difficulty, and dietary tags.
-   Primary content language.
-   Creator, publication status, and timestamps.

A draft may be incomplete. A published recipe must have a title, valid
ingredient data, at least one instruction step, and required metadata.

Users can edit or delete only their own recipes unless an authorized
moderator takes action. The backend must validate all fields even when
the Flutter client also performs validation.

Ingredient quantities may be scaled proportionally when servings change.
Automatic unit conversion should be deferred unless ingredient-specific
conversion rules are implemented and tested.

### 7.4 Feed and discovery

-   The following feed shows eligible public recipes from followed
    creators.
-   The discovery feed shows public recipes based on a simple ranking
    strategy.
-   Feed results are paginated.
-   Deleted, unpublished, blocked, or moderation-restricted content is
    excluded.
-   Feed ranking should initially favor relevance, freshness, reasonable
    engagement, and content variety.
-   Complex recommendation models are not required for MVP.

### 7.5 Search and filtering

Users should be able to search by recipe title and ingredients. Filters
may include cuisine, category, dietary tags, difficulty, and cooking
time.

Start with PostgreSQL full-text search and indexed ingredient matching.
Test multilingual behavior with real data; language tokenization differs
across scripts. Trigram indexes may be added for typo tolerance when
useful.

### 7.6 Community interactions

-   Users can follow and unfollow creators.
-   Users can like and unlike recipes.
-   Users can comment on recipes.
-   Comments may support replies through an optional parent comment ID.
-   Users can save recipes into collections.
-   Users can report recipes, comments, or profiles.
-   Repeated requests must not create duplicate likes, follows, or
    ratings.

Ratings and cooking attempts are planned for P1 unless time permits
after the core MVP is stable.

### 7.7 Notifications

The initial release should include in-app notifications for relevant
follows, likes, and comments.

-   Create notifications only after the underlying action succeeds.
-   Avoid duplicate notifications on retried requests.
-   Allow users to mark notifications as read.
-   Push notifications are P1 and should be optional and configurable.

### 7.8 Moderation and administration

-   Users can report content and select a reason.
-   Reports enter a review queue.
-   Moderators can review the report and related context.
-   Moderators can dismiss reports, hide content, restore content, or
    restrict accounts according to policy.
-   Privileged actions must record an audit entry.
-   A report should not automatically delete content.
-   Admin routes must enforce roles and permissions on the server.

### 7.9 Localization and multilingual content

-   Use Flutter localization facilities and avoid hardcoded UI strings.
-   Support Unicode throughout the system.
-   Store a primary language for each recipe.
-   Keep the original recipe as the canonical record.
-   Store translated versions in separate linked translation records.
-   Define a translation strategy for title, description, ingredients,
    steps, and other user-facing fields.
-   A recipe without a translation should remain discoverable, with its
    original language clearly indicated.
-   Locale preferences should be editable.

## 8. User Journeys and Acceptance Criteria

### Journey A: Discover and save a recipe

1.  Open the app.
2.  Choose an app language.
3.  Register or continue browsing as a guest where supported.
4.  Select optional cuisine and dietary interests.
5.  Open a recipe from the feed or search.
6.  Read the ingredients and instructions.
7.  Sign in if necessary and save the recipe.
8.  Find the saved recipe later in the Saved section.

**Acceptance criteria**

-   Onboarding preferences are optional and editable.
-   Recipe details can be read without signing in where the recipe is
    public.
-   Saving requires authentication.
-   Saved recipes persist across app restarts.

### Journey B: Publish a recipe

1.  Tap Create.
2.  Enter recipe details.
3.  Add ingredients and ordered steps.
4.  Upload a cover image.
5.  Save as draft or publish.
6.  Review the published recipe.
7.  Find the recipe in the user's profile and eligible feeds.

**Acceptance criteria**

-   Drafts can be incomplete.
-   Invalid publishing requests receive field-specific errors.
-   Upload failure does not erase entered recipe text.
-   Users cannot modify another user's recipe.
-   Unpublished or deleted recipes stop appearing in public feeds.

### Journey C: Community interaction

1.  Discover a recipe.
2.  Follow the creator, like the recipe, or comment.
3.  The creator receives an in-app notification.
4.  The recipient opens the related recipe or profile.
5.  Either user can report inappropriate content.

### Journey D: Search by ingredient

1.  Enter an ingredient such as chickpeas.
2.  Receive matching recipes.
3.  Filter by cuisine, diet, or cooking time.
4.  Sort by relevance or recency.
5.  Open a result and view the complete recipe.

### Journey E: Review a report

1.  A user submits a report.
2.  The backend records the target, reason, and status.
3.  A moderator reviews the report.
4.  The moderator dismisses it or takes action.
5.  The system records the outcome and moderator action.

## 9. Flutter Application Architecture

### Recommended stack

  Concern                    Recommendation
  -------------------------- ---------------------------------------------
  UI framework               Flutter and Dart
  State management           Riverpod
  Navigation                 GoRouter
  HTTP                       Dio
  Models and serialization   Freezed and `json_serializable`
  Localization               Flutter `gen_l10n`
  Secure token storage       Platform-backed secure storage package
  Images                     Cached image loading package
  Testing                    Flutter unit, widget, and integration tests

Equivalent packages are acceptable. Consistency matters more than using
every recommended library.

### Suggested folder structure

``` text
lib/
  app/
    app.dart
    router.dart
    theme/
    localization/
  core/
    api/
    auth/
    storage/
    errors/
    widgets/
  features/
    auth/
      data/
      domain/
      presentation/
    home/
      data/
      domain/
      presentation/
    recipes/
      data/
      domain/
      presentation/
    search/
    social/
    collections/
    notifications/
    profile/
    settings/
  shared/
    models/
    widgets/
  main.dart
```

Keep UI, data access, and business rules appropriately separated. Avoid
excessive abstractions for simple screens.

### Main navigation

1.  **Home:** following feed and discovery content.
2.  **Explore:** search, filters, cuisines, and categories.
3.  **Create:** prominent recipe creation action.
4.  **Saved:** bookmarks and collections.
5.  **Profile:** recipes, followers, settings, and preferences.

Notifications should be accessible from the app bar. The recipe-detail
screen should prioritize readable ingredients and steps.

## 10. NestJS Backend Architecture

### Recommended stack

  -----------------------------------------------------------------------
  Concern                             Recommendation
  ----------------------------------- -----------------------------------
  Framework                           NestJS

  Language                            TypeScript

  API                                 REST under `/api/v1`

  Database                            PostgreSQL

  ORM                                 Prisma

  Validation                          DTOs with `class-validator` and
                                      `class-transformer`

  Documentation                       Swagger / OpenAPI

  Authentication                      Short-lived access tokens and
                                      rotating refresh tokens

  Media                               Object storage with signed uploads

  Push notifications                  Firebase Cloud Messaging

  Background jobs                     BullMQ and Redis later if needed

  Testing                             Jest and Supertest
  -----------------------------------------------------------------------

### Suggested backend structure

``` text
src/
  main.ts
  app.module.ts
  common/
    decorators/
    filters/
    guards/
    interceptors/
    pipes/
  config/
  database/
    prisma/
  modules/
    auth/
    users/
    recipes/
    media/
    feed/
    search/
    follows/
    likes/
    comments/
    collections/
    notifications/
    reports/
    admin/
```

Use feature modules with their own controllers, services, and DTOs. Keep
shared authorization, validation, exception handling, and database setup
centralized.

### Backend rules

-   Use database transactions when a recipe and its ingredients or steps
    must be saved together.
-   Paginate feeds and lists on the server.
-   Enforce ownership and permissions in NestJS, not only in Flutter.
-   Generate Swagger documentation as the API contract.
-   Keep privileged database and storage credentials off the mobile
    client.
-   Add caching and background jobs only when workload justifies them.

## 11. Database Plan

PostgreSQL is the source of truth. Final column types, indexes,
constraints, and migrations should be confirmed during schema design.

### 11.1 Core tables

#### `users`

Suggested fields: `id`, `email`, `password_hash`, `username`,
`display_name`, `bio`, `avatar_url`, `preferred_locale`, `role`,
`status`, `created_at`, `updated_at`.

Requirements: - Unique normalized email and username. - Store password
hashes, never raw passwords. - Keep administrative role and account
status explicit.

#### `user_preferences`

Suggested fields: `user_id`, `locale`, cuisine preferences, dietary
preferences, onboarding status.

Use normalized join tables if preference querying becomes complex.

#### `recipes`

Suggested fields: `id`, `author_id`, `title`, `slug`, `description`,
`language_code`, `cuisine_id`, `prep_time_minutes`, `cook_time_minutes`,
`servings`, `difficulty`, `status`, `published_at`, `created_at`,
`updated_at`.

Keep publication state separate from moderation state.

#### `recipe_ingredients`

Suggested fields: `id`, `recipe_id`, `name`, `quantity`, `unit`,
`notes`, `sort_order`.

Use a decimal-compatible quantity representation or an explicit fraction
strategy. Allow optional quantity or unit for entries such as "salt to
taste."

#### `recipe_steps`

Suggested fields: `id`, `recipe_id`, `instruction`, `sort_order`,
optional `media_id`.

#### `media_assets` and `recipe_media`

Store media metadata and storage keys, not binary files in PostgreSQL.
Suggested metadata includes owner, type, processing status, dimensions,
and creation time.

#### Social tables

-   `follows(follower_id, following_id)`
-   `likes(user_id, recipe_id)`
-   `comments(id, user_id, recipe_id, parent_id, body, status, created_at)`
-   `ratings(user_id, recipe_id, score, review_text)` --- P1
-   `cooking_attempts(id, user_id, recipe_id, notes, created_at)` --- P1
-   `cooking_attempt_media(attempt_id, media_id)` --- P1

Use composite unique constraints for follows, likes, and ratings.

#### Collections

-   `collections(id, user_id, name, visibility)`
-   `collection_items(collection_id, recipe_id, added_at)`

Define whether duplicate recipes are allowed within a collection;
normally they should not be.

#### Operational tables

-   `refresh_tokens`
-   `notifications`
-   `device_tokens`
-   `content_reports`
-   `moderation_actions`
-   `audit_logs`
-   `recipe_translations`

### 11.2 Relationship summary

-   One user can create many recipes.
-   One recipe has many ingredients, steps, and media records.
-   Users can follow many other users.
-   Users can like and comment on recipes.
-   Users can own collections containing many recipes.
-   Users can rate and record cooking attempts for recipes in later
    phases.
-   Reports refer to content or users and record review state.
-   Recipe translations reference the canonical recipe.

### 11.3 Database rules and indexes

-   Add foreign keys and suitable deletion behavior.
-   Index foreign keys and common filters.
-   Add unique constraints for normalized email, username, follows,
    likes, and collection membership.
-   Index recipe publication status, publication date, creator ID, and
    search fields.
-   Use transactions for multi-table recipe changes.
-   Add denormalized counters only when needed and reconcile them with
    source records.
-   Test query plans with `EXPLAIN ANALYZE` before adding excessive
    indexes.
-   Define account deletion, content deletion, and audit-retention
    policies before launch.

## 12. REST API Roadmap

All endpoints should use `/api/v1`. Responses should use consistent
error formats, validation details, and pagination metadata.

### 12.1 Authentication and profile

  Method   Endpoint                  Purpose
  -------- ------------------------- ------------------------
  POST     `/auth/register`          Create account
  POST     `/auth/login`             Sign in
  POST     `/auth/refresh`           Rotate refresh token
  POST     `/auth/logout`            Revoke session
  POST     `/auth/verify-email`      Verify email
  POST     `/auth/forgot-password`   Request password reset
  GET      `/users/me`               Current profile
  PATCH    `/users/me`               Update profile
  GET      `/users/:username`        Public profile
  GET      `/users/:id/recipes`      Public recipes
  GET      `/users/:id/followers`    List followers
  GET      `/users/:id/following`    List followed users

Authentication endpoints need rate limiting, safe token handling, and
appropriate verification and recovery controls.

### 12.2 Recipes and media

  Method   Endpoint                   Purpose
  -------- -------------------------- -------------------------------
  POST     `/recipes`                 Create draft
  GET      `/recipes/:id`             Get recipe details
  PATCH    `/recipes/:id`             Update own recipe
  DELETE   `/recipes/:id`             Delete own recipe
  POST     `/recipes/:id/publish`     Publish validated recipe
  POST     `/recipes/:id/unpublish`   Unpublish recipe
  GET      `/users/me/recipes`        Own recipes and drafts
  POST     `/media/upload-url`        Request signed upload URL
  POST     `/media/:id/complete`      Confirm upload and processing

Recipe creation may include title, description, timings, servings,
ingredients, steps, tags, and uploaded media IDs. The server must
validate media ownership and save related recipe data transactionally.

### 12.3 Community

  Method   Endpoint                               Purpose
  -------- -------------------------------------- ---------------------------
  POST     `/users/:id/follow`                    Follow creator
  DELETE   `/users/:id/follow`                    Unfollow creator
  PUT      `/recipes/:id/like`                    Like recipe
  DELETE   `/recipes/:id/like`                    Remove like
  GET      `/recipes/:id/comments`                List comments
  POST     `/recipes/:id/comments`                Add comment
  PATCH    `/comments/:id`                        Edit own comment
  DELETE   `/comments/:id`                        Delete own comment
  POST     `/recipes/:id/ratings`                 Submit rating; P1
  POST     `/recipes/:id/attempts`                Share cooking attempt; P1
  POST     `/collections`                         Create collection
  PUT      `/collections/:id/recipes/:recipeId`   Save recipe
  DELETE   `/collections/:id/recipes/:recipeId`   Remove saved recipe

Repeated requests should not create duplicate likes, follows, or
ratings.

### 12.4 Feed, search, and notifications

  Method   Endpoint                    Purpose
  -------- --------------------------- --------------------------------
  GET      `/feed/following`           Recipes from followed creators
  GET      `/feed/discover`            Discovery feed
  GET      `/search/recipes`           Search recipes
  GET      `/search/users`             Find creators
  GET      `/cuisines`                 Cuisine list
  GET      `/categories`               Category list
  GET      `/notifications`            In-app notifications
  PATCH    `/notifications/:id/read`   Mark notification read
  POST     `/devices`                  Register push device; P1
  DELETE   `/devices/:id`              Remove device token; P1

Use cursor pagination for feeds where practical. A response can include
`items` and `nextCursor`.

### 12.5 Moderation and admin

-   `POST /reports` --- report a recipe, comment, or user.
-   `GET /admin/reports` --- retrieve reports for moderators.
-   `PATCH /admin/reports/:id` --- update report review status.
-   `POST /admin/users/:id/restrict` --- restrict an account with a
    reason.
-   `PATCH /admin/recipes/:id/moderation` --- hide or restore content.
-   `GET /admin/overview` --- basic counts and moderation statistics.

All admin endpoints require explicit role and permission checks on the
backend.

## 13. Feed and Search Strategy

### Following feed

Return recently published, eligible public recipes from followed
creators, ordered by publication time. Exclude deleted, unpublished,
blocked, and moderation-restricted content.

### Discovery feed

Start with a simple score based on: - Match with cuisine and dietary
preferences. - Recipe freshness. - Normalized engagement. - Variety of
creators and cuisines. - Whether the user has already seen or saved the
recipe.

This can begin as a weighted SQL query or a small NestJS service. Record
feed impressions and meaningful actions before implementing more
sophisticated ranking.

### Search

Use PostgreSQL full-text search for titles and descriptions, indexed
ingredient matching, and structured filters. Consider trigram indexes
for typo tolerance. Test regional scripts separately because search
behavior varies by language.

## 14. Authentication, Security, and Media Uploads

### Media upload flow

1.  Flutter requests upload authorization from NestJS.
2.  NestJS authenticates the user and issues a short-lived signed URL.
3.  Flutter uploads directly to object storage.
4.  Flutter confirms the upload.
5.  NestJS validates ownership, type, size, and processing status before
    attaching media to a recipe.

### Security requirements

-   Hash passwords with a modern algorithm such as Argon2id.
-   Use short-lived access tokens and securely stored, rotating refresh
    tokens.
-   Store mobile credentials using platform-backed secure storage.
-   Apply rate limits, DTO validation, and authorization checks.
-   Restrict upload MIME types and file sizes; verify actual file
    content.
-   Prevent users from attaching another user's media.
-   Use short-lived signed URLs and correct storage permissions.
-   Keep secrets in environment configuration or a secrets manager.
-   Use HTTPS in production.
-   Record privileged actions in audit logs.
-   Provide report/block functionality, account deletion, and
    appropriate privacy controls.

For MVP, direct signed uploads are suitable for images. Large video
uploads, transcoding, and streaming infrastructure should wait until
needed.

## 15. Non-Functional Requirements

### Performance

-   Paginate feed and search results.
-   Optimize and resize images.
-   Avoid unnecessary database queries.
-   Measure API latency and upload failures.

### Security

-   Validate every request.
-   Enforce ownership and administrative permissions on the server.
-   Protect secrets and personal data.
-   Rate-limit sensitive endpoints.

### Reliability

-   Configure automated database backups.
-   Test restoration procedures.
-   Log server errors and monitor crash rates.
-   Handle partial media-upload failures safely.

### Accessibility

-   Support scalable text and screen readers.
-   Use sufficient contrast and meaningful labels.
-   Provide useful alternative text for images where appropriate.

### Internationalization

-   Avoid hardcoded UI strings.
-   Support Unicode.
-   Store timestamps in UTC.
-   Keep original recipe language and translations explicit.

### Scalability

-   Start with a modular monolith.
-   Add Redis, background jobs, or a dedicated search system only when
    measured demand justifies the operational cost.

## 16. Deployment and Operations

Recommended initial deployment: - Flutter releases through Google Play
and Apple App Store. - NestJS on a managed application host. - Managed
PostgreSQL with automated backups. - Object storage for recipe images. -
HTTPS, production secrets, and API monitoring. - Firebase Cloud
Messaging when push notifications are implemented. - CI for linting,
testing, and build checks.

Maintain separate development, staging, and production configurations.
Do not run destructive migrations against production without a backup
and rollback plan.

Choose an initial hosting region based on the expected audience,
provider availability, and latency. Media CDN delivery can be introduced
without immediately distributing the database across regions.

## 17. Implementation Roadmap

Estimated timeline for one developer: **10--14 weeks**, depending on
weekly availability, prior familiarity, testing depth, and store-review
timing. This is a planning estimate, not a delivery guarantee.

### Phase 1 --- Product and setup (Week 1)

-   Finalize requirements, wireframes, database ERD, and API contract.
-   Create Flutter and NestJS projects.
-   Set up PostgreSQL, Prisma migrations, environment configuration,
    Git, linting, and basic CI.
-   Define the theme and reusable UI components.

**Deliverable:** runnable application and backend foundation.

### Phase 2 --- Authentication and profiles (Weeks 2--3)

-   Registration, login, email verification, and password recovery.
-   Session management and protected routes.
-   Profile creation and editing.
-   Initial localization and language selection.

**Deliverable:** users can securely register and manage profiles.

### Phase 3 --- Recipe engine (Weeks 4--5)

-   Recipe drafts, editing, publishing, and deletion.
-   Ingredients and instruction management.
-   Image uploads and recipe detail pages.
-   Recipe lists on creator profiles.

**Deliverable:** complete recipe publishing lifecycle.

### Phase 4 --- Social community (Weeks 6--7)

-   Follow/unfollow.
-   Likes and comments.
-   Saved recipes and collections.
-   Following and basic discovery feeds.

**Deliverable:** core community loop.

### Phase 5 --- Discovery and operations (Weeks 8--9)

-   Search and filters.
-   In-app notifications.
-   Reports and moderation.
-   Basic admin web dashboard.

**Deliverable:** discoverable content and manageable platform
operations.

### Phase 6 --- Testing and launch (Weeks 10--12+)

-   API, widget, integration, and security tests.
-   Android and iOS device testing.
-   Closed beta and bug fixes.
-   Store submissions and initial creator onboarding.
-   Basic product analytics.

**Deliverable:** tested release candidate ready for launch.

Keep a buffer through week 14 for app-store feedback, integration
problems, and usability improvements. Add P1 features only if the core
schedule remains healthy.

## 18. Testing and Release Checklist

### Authentication and permissions

-   Registration, login, logout, and refresh work correctly.
-   Users cannot edit another user's profile or recipes.
-   Expired and revoked sessions are rejected.
-   Sensitive endpoints are rate-limited.

### Recipes and media

-   Drafts survive app restarts and upload failures.
-   Ingredients and steps retain their order.
-   Invalid uploads and unauthorized media references are rejected.
-   Publishing and deletion update feeds correctly.

### Community and discovery

-   Duplicate likes and follows are prevented.
-   Notifications link to the correct content.
-   Pagination does not repeatedly return the same recipes.
-   Search and filters work with multilingual sample data.

### Production readiness

-   Android and iOS builds pass real-device tests.
-   Database backups and restoration are verified.
-   Errors, API latency, and upload failures are monitored.
-   Privacy policy, terms, reporting, and account deletion are ready.

## 19. Immediate Next Steps

1.  Finalize wireframes for onboarding, home feed, recipe detail, recipe
    creation, search, saved recipes, profile, and notifications.
2.  Finalize the database ERD, column types, constraints, translations,
    visibility, and deletion behavior.
3.  Write the API contract, including DTOs, errors, pagination, and
    authorization.
4.  Create the Flutter application and NestJS backend repositories,
    migrations, and API documentation.
5.  Build one complete vertical slice: **register user → create recipe →
    upload image → persist recipe → discover recipe in Flutter**.
6.  Extend the same pattern to follows, feeds, likes, comments, and
    collections.
7.  Test permissions and failure cases before expanding features.

The first milestone is not a polished home feed. It is a reliable
end-to-end flow from user registration through recipe creation, media
upload, database persistence, and recipe discovery. Once this works, the
rest of the product can be developed incrementally.

------------------------------------------------------------------------

## Appendix A --- Initial Definition of Done

A feature is ready when: - Its happy path works on the client and
backend. - Inputs are validated on the server. - Authorization is
tested. - Loading, empty, error, and retry states are handled in
Flutter. - API behavior is documented. - Relevant automated tests
pass. - Logs do not expose secrets or sensitive user data. - The feature
has been tested on a real device where applicable.

## Appendix B --- Decisions to Confirm During Technical Design

-   Initial list of UI locales and translation ownership.
-   Whether guest browsing is included in the first build.
-   Initial hosting provider, storage provider, and deployment region.
-   Account deletion and content retention policy.
-   Whether recipe ratings are MVP or P1.
-   Exact admin dashboard technology.
-   Media file limits and image processing strategy.
-   Privacy, moderation, and store-policy requirements for initial
    launch markets.
