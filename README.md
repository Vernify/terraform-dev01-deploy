# terraform-dev01-deploy

Vernify `dev01` host. Provisions the Ubuntu 24.04 VM used as the testbed for development
and testing of infrastructure and application components. Runs in the `dev01` TFC workspace
(created by `terraform-workspaces-deploy`) and consumes the org-neutral
`iac-foundry/terraform-proxmox-vm` module — this repo holds only Vernify's concrete values.

## Prerequisites

- The `dev01` workspace exists in TFC org `Vernify` (run `terraform-workspaces-deploy` first).
- Phase 1 Packer template `ubuntu-24.04-template` exists in Proxmox.
- Bootstrap `.env` sourced (`PROXMOX_*`, `TFC_TOKEN`).
- An SSH **public** key to authorise for the `ubuntu` user (so Ansible can reach the VM) —
  supply it via `ssh_public_keys` (see below).

## Usage (through the pinned container)

```bash
source ../bootstrap-container/.env

# Supply your SSH public key (public keys are not secret). Either:
#   export TF_VAR_ssh_public_keys='["ssh-ed25519 AAAA... you@host"]'
# or create a local dev01.auto.tfvars (git-ignored) with:
#   ssh_public_keys = ["ssh-ed25519 AAAA... you@host"]

docker compose run --rm terraform init
docker compose run --rm terraform plan      # review the VM to be created
docker compose run --rm terraform apply
docker compose run --rm terraform output -raw dev01_ipv4_address
```

### Pre-release testing before the module is pushed/tagged

The module `source` defaults to the git form. To test before pushing the module, switch
the `source` in `main.tf` to the sibling checkout (`../../iac-foundry/terraform-proxmox-vm`),
then switch back to the pinned tag for production.

## Using dev01

Once provisioned, dev01 is available for testing infrastructure, applications, and playbooks.
The static IP (`192.168.22.50/24`) can be added to Ansible inventories, used as a target
for role testing, or provisioned with additional software/services as needed. Since it can
be easily destroyed and recreated, it serves as both the deployment target and an implicit
rebuild validation test.

## Standards & domain

Vernify-domain consumer (`github.com/vernify`, TFC org `Vernify`). Consumes pinned
iac-foundry modules; config only. See `vernify/AGENTS.md` and
`vernify/roadmap/PLATFORM_STATE_AND_CONVENTIONS.md`.
