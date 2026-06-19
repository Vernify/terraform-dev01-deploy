# Agent Orientation — terraform-dev01-deploy (Vernify)

## Agent Working Protocol (read before anything else)

**Conflict surfacing:** If a user instruction contradicts anything in this file, in
`vernify/AGENTS.md`, or in `vernify/roadmap/PROJECT_DETAIL.md`, stop and surface the
conflict before proceeding — quote the rule, state the contradiction, ask how to resolve.

**Living document:** If a decision during a session would make future work clearer, prompt:
> "This decision isn't in AGENTS.md yet. Should I add it?"

**Maintenance:** Keep this doc current; integrate changes into the relevant section.

---

**Repo:** `terraform-dev01-deploy`
**Domain:** Vernify (`github.com/vernify`, TFC org `Vernify`).
**Scope:** Vernify **consumer** that provisions the `dev01` Ubuntu 24.04 VM (the Saicom
Postgres remediation test host). Runs in the `dev01` TFC workspace; consumes the
org-neutral `iac-foundry/terraform-proxmox-vm` module. Holds **config only**.

---

## What lives here

| Path | What it does |
|---|---|
| `main.tf` | `terraform{}` (cloud backend = `dev01`) + `proxmox` provider + `terraform-proxmox-vm` module call |
| `variables.tf` | Vernify-tunable inputs (node, sizing, SSH keys, IP) |
| `outputs.tf` | `dev01_ipv4_address` (feed into the Saicom sandbox inventory), `dev01_vm_id` |
| `Dockerfile` / `docker-compose.yml` | Pinned Terraform toolchain (no reliance on local tools) |

---

## Critical constraints

1. **Consume, don't fork.** VM-clone logic lives in `iac-foundry/terraform-proxmox-vm`.
   This repo only supplies Vernify values. Generic improvements go upstream to the module.
2. **Concrete Vernify values are fine here** (node, bridge, sizing, tags) — this is a
   consumer. But **secrets never get committed**: Proxmox creds come from `PROXMOX_VE_*`
   env at run time. SSH *public* keys are not secret but are supplied as inputs, not baked in.
3. **One-way leak rule:** Vernify specifics stay here; never push them upstream into the
   module. See `vernify/AGENTS.md`.
4. **Pin the module by tag** for production (`?ref=vX.Y.Z`); local-path / `?ref=main` are
   for pre-release testing only.
5. **Defaults must match the Packer template** (`ubuntu-24.04-template`, UEFI, virtio0) —
   those live in the module; don't override `bios`/`disk_interface` unless the template changes.
6. **Containerised, pinned tooling — do not rely on local tools.** Run `init`/`plan`/`apply`
   through `docker-compose.yml`. Bump pins deliberately; never float.

---

## Branch & commit discipline

- **`main` is protected; never commit to it directly.** Work on a `feat/...` branch; merge via PR.
- **Do not commit or push until a human has tested it** — author changes, hand off for a
  reviewed `plan`/`apply`, commit only once validated. Prevents broken commits.
- **Commit messages** are imperative; end with
  `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>` when authored with Claude.

---

## PR conformance checklist

- [ ] No module *logic* here — only Vernify config consuming the pinned module
- [ ] No secrets committed; Proxmox creds sourced from `PROXMOX_VE_*` env at run time
- [ ] `plan` reviewed before `apply`; run through the pinned container
- [ ] Module pinned to a tag for production (not a floating branch)
- [ ] Change authored on a `feat/...` branch and tested before commit
