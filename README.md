# 🛍️ LUMINA — High-Performance Product Catalog & Faceted Filter System

<div align="left">

[![Live Demo](https://img.shields.io/badge/Live%20Demo-lumina--catalog.vercel.app-000000?style=for-the-badge&logo=vercel&logoColor=white)](https://lumina-catalog.vercel.app/)
[![Next.js 16](https://img.shields.io/badge/Next.js%2016-000000?style=for-the-badge&logo=next.js&logoColor=white)](https://nextjs.org/)
[![React 19](https://img.shields.io/badge/React%2019-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)](https://react.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript%205-3178C6?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
[![Tailwind CSS 4](https://img.shields.io/badge/Tailwind_CSS_4-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)
[![Vitest](https://img.shields.io/badge/Tests-92%20Passed-10B981?style=for-the-badge&logo=vitest&logoColor=white)](https://vitest.dev/)
[![ESLint](https://img.shields.io/badge/ESLint-4B32C3?style=for-the-badge&logo=eslint&logoColor=white)](https://eslint.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

</div>

🌐 **Live Demo:** [https://lumina-catalog.vercel.app/](https://lumina-catalog.vercel.app/)  
📦 **Repository:** [https://github.com/parikshit245/Entrata-ai-coding-challange-Task-1](https://github.com/parikshit245/Entrata-ai-coding-challange-Task-1)

An enterprise-grade, responsive e-commerce product catalog built with **Next.js 16 (App Router)**, **React 19**, **TypeScript**, and **Tailwind CSS**. It features deterministic faceted filtering (multi-category, dynamic price range, rating threshold), multi-attribute sorting, state-preserving pagination, responsive mobile drawer controls, and an isolated pure business logic pipeline verified with **92 automated unit and integration tests**.

---

## 📑 Table of Contents

1. [System Architecture & Processing Pipeline](#-system-architecture--processing-pipeline)
2. [Component Hierarchy](#-component-hierarchy)
3. [Key Features & Capabilities](#-key-features--capabilities)
4. [State Management Architecture](#-state-management-architecture)
5. [Tech Stack](#-tech-stack)
6. [Project Structure](#-project-structure)
7. [Getting Started & Installation](#-getting-started--installation)
8. [Available Scripts](#-available-scripts)
9. [Testing Strategy](#-testing-strategy)
10. [Deploy to AWS with Terraform](#-deploy-to-aws-with-terraform)
11. [Design System & Accessibility](#-design-system--accessibility)
12. [Jenkins Integration with GitHub](#-jenkins-integration-with-github)

---

## 🏛️ System Architecture & Processing Pipeline

The application isolates **pure computational business logic** from **UI presentation components**. Filtering, counting, sorting, and pagination operate in a strictly ordered, deterministic pipeline that prevents stale reads, race conditions, or off-by-one pagination traps.

### Data Processing Pipeline Diagram

```mermaid
flowchart TD
    A["Raw Product Dataset (48 Products)"] --> B["Step 1: filterProducts<br/>Category + Price Range + Rating"]
    B --> C["Step 2: Calculate Filtered Count<br/>totalCount = filtered.length"]
    C --> D["Step 3: sortProducts<br/>Relevance, Price Asc/Desc, Rating, Name"]
    D --> E["Step 4: paginateProducts<br/>Window slicing + Page Clamping"]
    E --> F["Render CatalogPage<br/>ProductGrid, ActiveFilters, Pagination, Summary"]

    subgraph StateManagement ["State Management"]
        Q["CatalogQuery State<br/>filters, sort, page, pageSize"] -->|useMemo| Pipeline["applyCatalogQuery"]
        Pipeline --> R["CatalogResult<br/>products, totalCount, totalPages, currentPage"]
    end
```

### Text Flow Representation

```text
┌────────────────────────────────────────────────────────┐
│ Raw Products Dataset (48 items across 7 categories)    │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 1. Filter Phase (filterProducts)                       │
│    • Category: Multi-select OR within category         │
│    • Price: min <= price <= max                        │
│    • Rating: rating >= minRating                       │
│    • Combination: strict AND across all active filters │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 2. Count Phase (Capture Total Filtered Count)          │
│    • totalCount calculated on filtered set             │
│    • Independent of pagination slice                   │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 3. Sort Phase (sortProducts)                           │
│    • Global sorting applied to the full filtered set   │
│    • Never mutates original dataset (pure slice)       │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 4. Paginate Phase (paginateProducts)                   │
│    • totalPages = ceil(totalCount / pageSize)          │
│    • Automatic page clamping [1, totalPages]           │
│    • Slice to current page window                      │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│ 5. Presentation Layer (ProductGrid, Sidebar, Toolbar)  │
└────────────────────────────────────────────────────────┘
```

---

## 🧩 Component Hierarchy

```text
Root Layout (src/app/layout.tsx)
│
└── CatalogPage (src/app/page.tsx) [Single Source of Truth via useCatalog()]
    │
    ├── Navbar (src/components/layout/Navbar.tsx)
    │   ├── Brand Logo & Identity
    │   ├── Quick Category Shortcuts
    │   └── E-Commerce Utility Badges (Cart, Wishlist, Profile)
    │
    ├── HeroSection (src/components/layout/HeroSection.tsx)
    │   ├── Live Metrics & Inventory Counter
    │   ├── Headline & Value Propositions
    │   └── Interactive Quick Filter Pills with Smooth Scroll
    │
    ├── MobileFilterDrawer (src/components/catalog/MobileFilterDrawer.tsx)
    │   ├── Backdrop Blur & Accessible Dialog Trap
    │   ├── Reusable Filter Controls (Category, Price, Rating)
    │   └── Quick Reset & Apply CTA Actions
    │
    └── Main Content Container
        ├── Top Toolbar
        │   ├── Mobile Filter Open Trigger
        │   ├── ResultsSummary (src/components/catalog/ResultsSummary.tsx)
        │   └── SortControl (src/components/catalog/SortControl.tsx)
        │
        ├── ActiveFilters (src/components/catalog/ActiveFilters.tsx)
        │   └── Dismissible Pill Badges with Individual '✕' & 'Clear all'
        │
        └── Two-Column Layout
            ├── FilterSidebar (src/components/catalog/FilterSidebar.tsx) [Desktop lg+]
            │   ├── CategoryFilter (src/components/catalog/CategoryFilter.tsx)
            │   ├── PriceFilter (src/components/catalog/PriceFilter.tsx)
            │   └── RatingFilter (src/components/catalog/RatingFilter.tsx)
            │
            └── Product Area
                ├── ProductGrid (src/components/catalog/ProductGrid.tsx)
                │   ├── ProductCard (src/components/catalog/ProductCard.tsx) [Grid Items]
                │   └── Empty State Illustration (when 0 results match)
                │
                └── Pagination (src/components/catalog/Pagination.tsx)
```

---

## ✨ Key Features & Capabilities

- **Multi-Select Category Filtering**: Choose one or multiple categories simultaneously (OR within categories, AND across other criteria).
- **Price Range Boundaries**: Numeric minimum and maximum price inputs with instant error detection when `min > max`.
- **Minimum Star Rating**: Toggleable minimum rating filter (4.5+, 4.0+, 3.5+, 3.0+) with rendered vector stars.
- **Deterministic Sorting**:
  - _Relevance_ (Editorial default order)
  - _Price: Low to High_ / _Price: High to Low_
  - _Highest Rated_ (with review count secondary tie-breaker)
  - _Name: A–Z_ (alphabetical)
- **Preserving State across Pagination**: Navigating between pages never discards active filters or sort options.
- **Intelligent Page Clamping**: If applying a strict filter on page 4 reduces total pages to 1, the system automatically clamps to page 1 without breaking.
- **Dismissible Active Filter Chips**: Real-time summary pills allowing one-click removal of individual filters or clearing all filters at once.
- **Responsive Mobile Experience**: Dedicated slide-in filter drawer with blurred backdrop, native touch scrolling, and instant synchronization with the desktop view.
- **High-Resolution Photography**: Optimized product cards with Unsplash image photography, category badges, and hover lift effects.
- **Rich Zero-State Handling**: Context-aware empty state with a direct "Clear all filters" recovery action.

---

## 🔄 State Management Architecture

All catalog state is managed in [`src/hooks/useCatalog.ts`](file:///c:/7th%20Semester/Entrata-challange/product-catalog-challenge/src/hooks/useCatalog.ts) through a single atomic `CatalogQuery` state object:

```typescript
export interface CatalogQuery {
  filters: {
    categories: ProductCategory[];
    priceRange: { min: number | null; max: number | null };
    minRating: number | null;
  };
  sort: SortOption;
  page: number;
  pageSize: number;
}
```

### State Transition Invariants

1. **Filter Change** → Updates filter state and atomically resets `page = 1`.
2. **Sort Change** → Updates sort parameter and atomically resets `page = 1`.
3. **Page Change** → Modifies only the `page` index, preserving all active filters and sort settings.
4. **Reset Action** → Restores all parameters to `DEFAULT_CATALOG_QUERY` in a single update.
5. **Derived Result** → Fully computed via `useMemo(() => applyCatalogQuery(PRODUCTS, query), [query])`.

---

## 🛠️ Tech Stack

| Technology         | Purpose                                                   |
| ------------------ | --------------------------------------------------------- |
| **Next.js 16.3.3** | React Framework (App Router, Turbopack)                   |
| **React 19.2.8**   | UI Library & Hooks (`useMemo`, `useState`, `useCallback`) |
| **TypeScript 5**   | Static type safety and strict schema definitions          |
| **Tailwind CSS 4** | Design-token-driven utility styling                       |
| **Vitest 4.1.11**  | Unit & Integration test runner                            |
| **ESLint 9**       | Code quality & static linting                             |
| **Prettier**       | Code formatting                                           |

---

## 📁 Project Structure

```text
product-catalog-challenge/
├── src/
│   ├── app/
│   │   ├── favicon.ico
│   │   ├── globals.css              # Design tokens (colors, radii, typography)
│   │   ├── layout.tsx               # Root layout & meta tags
│   │   └── page.tsx                 # Main client page coordinating useCatalog()
│   ├── components/
│   │   ├── catalog/
│   │   │   ├── ActiveFilters.tsx    # Dismissible filter chips
│   │   │   ├── CatalogHeader.tsx    # Page header
│   │   │   ├── CategoryFilter.tsx   # Category checkboxes
│   │   │   ├── FilterSidebar.tsx    # Desktop sticky sidebar
│   │   │   ├── MobileFilterDrawer.tsx # Mobile slide-in drawer
│   │   │   ├── Pagination.tsx       # Accessible page navigation
│   │   │   ├── PriceFilter.tsx      # Min/max budget inputs with alert
│   │   │   ├── ProductCard.tsx      # Responsive card with photography
│   │   │   ├── ProductGrid.tsx      # Grid container & empty state
│   │   │   ├── RatingFilter.tsx     # Star rating selectors
│   │   │   ├── ResultsSummary.tsx   # Results count summary
│   │   │   └── SortControl.tsx      # Dropdown sort selector
│   │   └── layout/
│   │       ├── HeroSection.tsx      # E-commerce hero banner & shortcut pills
│   │       └── Navbar.tsx           # Top navigation bar
│   ├── data/
│   │   └── products.ts              # Deterministic dataset (48 items)
│   ├── hooks/
│   │   └── useCatalog.ts            # Single-source-of-truth state hook
│   ├── lib/
│   │   └── catalog/
│   │       ├── catalog.ts           # Pure business logic functions
│   │       └── catalog.test.ts      # 46 pure function unit tests
│   ├── test/
│   │   ├── catalog.integration.test.ts # 38 scenario integration tests
│   │   ├── sanity.test.ts           # 8 dataset structural tests
│   │   └── setup.ts                 # Test environment setup
│   └── types/
│       └── product.ts               # Domain types & interfaces
├── next.config.ts                   # Next.js configuration
├── package.json                     # Scripts & dependencies
├── tsconfig.json                    # TypeScript strict compiler config
└── vitest.config.ts                 # Vitest configuration
```

---

## 🚀 Getting Started & Installation

### Prerequisites

- **Node.js**: v18.18.0 or higher (v20+ recommended)
- **npm**: v9+ or **pnpm** / **yarn** / **bun**

### 1. Clone the Repository

```bash
git clone https://github.com/parikshit245/Entrata-ai-coding-challange-E.git
cd Entrata-ai-coding-challange-E/product-catalog-challenge
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Start the Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser to view the application.

### 4. Create Production Build

```bash
npm run build
npm start
```

### Run with Docker

```bash
docker compose up -d --build
```

Open [http://localhost:3002](http://localhost:3002) for the app. Adminer is available at [http://localhost:8081](http://localhost:8081); connect with System `PostgreSQL`, Server `db`, User `lumina`, Password `lumina_pass`, and Database `lumina_db`.

Stop the services with:

```bash
docker compose down
```

Use `docker compose down -v` when you also want to delete the database volume.

---

## 📜 Available Scripts

| Command             | Description                                            |
| ------------------- | ------------------------------------------------------ |
| `npm run dev`       | Starts Next.js development server with Turbopack       |
| `npm run build`     | Builds optimized production bundle                     |
| `npm start`         | Runs the production server                             |
| `npm test`          | Runs the full Vitest suite (92 tests) in headless mode |
| `npm run lint`      | Runs ESLint across all source files                    |
| `npm run typecheck` | Validates TypeScript with `tsc --noEmit`               |
| `npm run format`    | Formats all code using Prettier with Tailwind sorting  |

---

## 🧪 Testing Strategy

The test suite contains **92 automated tests** across 3 test suites:

```bash
npm test
```

### Test Coverage Breakdown

```text
✓ src/test/sanity.test.ts (8 tests)
  - Dataset validity, ID uniqueness, price/rating boundary spreads

✓ src/lib/catalog/catalog.test.ts (46 tests)
  - Pure filtering (category, min price, max price, min/max range, rating)
  - Global sorting (price-asc, price-desc, rating-desc, name-asc, relevance)
  - Pagination mechanics, page bounds, and clamping logic
  - Helper functions (hasActiveFilters, getPriceRange, isPriceRangeActive)

✓ src/test/catalog.integration.test.ts (38 tests)
  - 12 Acceptance scenarios:
    1. Default view with all 48 products
    2. Single & multi-category filtering
    3. Min price filtering
    4. Max price filtering
    5. Min + Max range filtering & invalid range
    6. Minimum star rating threshold
    7. Multi-filter combination (AND semantics)
    8. Sorting while filters are active
    9. State preservation across page changes
    10. Automatic page clamping when filters shrink results
    11. Clean filter reset to defaults
    12. Contextual empty-result handling
```

---

## ☁️ Deploy to AWS with Terraform

The `terraform/` directory deploys the application to one **Amazon EC2**
instance. The instance installs Docker, clones this public repository, builds
the existing Dockerfile, and publishes the app on port 80. This avoids ECR,
ECS, and a load balancer, keeping the deployment suitable for a small
learning account. The catalog uses its checked-in product data at runtime, so
this deployment does not create a database.

### Prerequisites

Install these tools on your machine:

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/)

You also need an AWS account with permission to create EC2 instances, VPC
security groups, and public IP addresses. For a personal
learning account, an administrator can create a dedicated IAM user or
Identity Center user. Do not use the AWS root account or commit access keys.

### AWS credentials

The recommended setup is AWS IAM Identity Center (SSO), configured by an AWS
account administrator:

```powershell
aws configure sso
aws sts get-caller-identity
```

If SSO is not available, an administrator can create a dedicated IAM user in
**AWS Console → IAM → Users → Security credentials → Create access key**.
Choose the local CLI use case, then configure the keys locally:

```powershell
aws configure
aws sts get-caller-identity
```

The access key and secret are shown only when created. Store them in the AWS
CLI credential store or environment variables, never in `terraform.tfvars`,
source code, or Git. Your administrator should grant only the permissions
needed for this deployment; `AdministratorAccess` is convenient for a
temporary learning account but is broader than recommended.

### Deploy

1. Copy the example variables file and set the region and app name:

   ```powershell
   Copy-Item terraform\terraform.tfvars.example terraform\terraform.tfvars
   ```

2. Initialize Terraform and create the EC2 instance:

   ```powershell
   terraform -chdir=terraform init
   terraform -chdir=terraform apply -var-file=terraform.tfvars
   ```

   Terraform starts an Amazon Linux EC2 instance. Its startup script installs
   Docker and Git, creates swap space for the Next.js build, clones the
   repository, builds the image, and starts the container.

3. Get the public URL:

   ```powershell
   terraform -chdir=terraform output -raw catalog_url
   ```

Open the printed URL after the instance finishes its startup script. The first
deployment can take several minutes because the instance builds the Next.js
production image before starting the container.

If the page is not ready after five minutes, inspect the EC2 console's
**Instance → Actions → Monitor and troubleshoot → Get system log**. The
startup script output is also available in `/var/log/cloud-init-output.log`
if you later add SSH access.

### Remove AWS resources

When finished, remove the resources to stop ongoing AWS charges:

```powershell
terraform -chdir=terraform destroy -var-file=terraform.tfvars
```

Terraform state contains infrastructure metadata and must be kept private.
For a team or production deployment, store it in an encrypted remote backend
instead of the local `terraform.tfstate` file.

## 🔁 Jenkins Integration with GitHub

This repository includes a [`Jenkinsfile`](./Jenkinsfile) for Assignment 6.
It demonstrates automated GitHub source retrieval and runs the project's real
CI checks:

1. Checkout the configured Git branch from GitHub
2. Verify Node.js and npm
3. Install locked dependencies with `npm ci`
4. Run ESLint and the TypeScript typecheck
5. Run all 92 Vitest tests
6. Create the production Next.js build

### Jenkins prerequisites

The Jenkins agent needs:

- Java/JDK for Jenkins
- Git
- Node.js 20 or newer and npm
- Jenkins plugins: **Pipeline**, **Git**, and **GitHub** (the GitHub plugin is
  only needed for webhook integration)

The agent must be able to run `node`, `npm`, and `git` from its PATH. No AWS
credentials are needed for this Jenkins assignment.

### Create the Jenkins job

1. Open Jenkins and select **New Item**.
2. Enter `Lumina-GitHub-CI`.
3. Select **Pipeline**, then click **OK**.
4. Under **Pipeline**, choose **Pipeline script from SCM**.
5. Select **Git** and enter:

   ```text
   https://github.com/parikshit245/Entrata-ai-coding-challange-E.git
   ```

6. Set the branch to:

   ```text
   */main
   ```

7. Set **Script Path** to:

   ```text
   Jenkinsfile
   ```

8. Save and select **Build Now**.

The repository is public, so credentials are not required for checkout. For a
private repository, create a GitHub fine-grained personal access token with
read-only repository contents access in **Jenkins → Manage Jenkins →
Credentials**, then select that credential in the Git SCM configuration. Never
put a token in the Jenkinsfile or commit it to Git.

### Optional GitHub automatic trigger

To build after every push:

1. In the Jenkins job, enable **GitHub hook trigger for GITScm polling**.
2. In GitHub, open **Settings → Webhooks → Add webhook**.
3. Set the Payload URL to:

   ```text
   https://<your-jenkins-host>/github-webhook/
   ```

4. Select `application/json` and the **Just the push event** option.
5. Save the webhook and push a commit to `main`.

Jenkins must be reachable by GitHub for the webhook to work. If Jenkins is
running only on `localhost`, use **Build Now** for the demo or expose it
through an approved tunnel or public host.

### Expected result

The Jenkins console should show successful `Checkout`, `Install`, `Quality
checks`, `Test`, and `Build` stages. The final result should be `SUCCESS`, and
the workspace should contain the latest source retrieved from GitHub during
the build.

## ☸️ Kubernetes Deployment with Helm

The project includes a Kubernetes package at [`helm/lumina`](./helm/lumina)
for the K3s/Helm assignment. It creates a `lumina` namespace, one configurable
web Deployment, a NodePort Service on port `30081`, a ConfigMap, and a Secret.
The container listens on port `3000`, matching the [`Dockerfile`](./Dockerfile).

### Build and load the image

Build the production image and make it available to the K3s container runtime:

```bash
docker build -t lumina-catalog:latest .
k3d image import lumina-catalog:latest
```

For a regular K3s installation, push the image to a registry accessible by the
cluster and override `image.repository` and `image.tag`.

### Validate, render, and deploy

```bash
helm version
helm lint ./helm/lumina
helm template lumina ./helm/lumina --namespace lumina
helm upgrade --install lumina ./helm/lumina \
  --namespace lumina \
  --create-namespace \
  --set image.repository=lumina-catalog \
  --set image.tag=latest
```

The optional database value is supplied without committing credentials:

```bash
helm upgrade --install lumina ./helm/lumina \
  --namespace lumina \
  --create-namespace \
  --set secrets.databaseUrl="$DATABASE_URL"
```

Inspect the release and workload:

```bash
helm list -n lumina
helm status lumina -n lumina
kubectl get deploy,pods,svc -n lumina
```

Open `http://<k3s-node-ip>:30081` to access the catalog. To remove only this
release from a test cluster, run `helm uninstall lumina -n lumina`.

## ♿ Design System & Accessibility

- **WCAG Contrast Compliant**: All color pairs (text on background, badge text on tint) meet or exceed WCAG AA contrast standards.
- **Vector Iconography**: Pure scalable vector SVGs across all components (no blurry emoji characters).
- **Keyboard Navigation**: Native HTML inputs (`checkbox`, `radio`, `select`, `button`) with accessible `:focus-visible` rings.
- **Screen Reader Live Regions**:
  - `aria-live="polite"` on results counter and active filter badges.
  - `role="dialog"` with `aria-modal="true"` on the mobile filter drawer.
  - `role="alert"` with `aria-invalid` on price range validation errors.
  - `aria-current="page"` on active pagination buttons.
- **Reduced Motion**: Honored via `@media (prefers-reduced-motion: reduce)` in `globals.css`.

---

## 📄 License

MIT © 2026 LUMINA Catalog / Parikshit Rajpurohit
