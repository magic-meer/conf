# AGENTS.md — ai-agents

This directory holds Nix configuration for AI agents on this system.

## Rule

Every change to `hermes.nix` must align with the official Hermes Agent
Nix & NixOS setup documentation:

https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup/

Before editing `hermes.nix`, fetch that page and validate any option names,
module paths, and settings against it.

## Contents

- `opencode.nix` — opencode configuration (programs.opencode)
- `hermes.nix` — Hermes Agent configuration (services.hermes-agent / programs.hermes-agent)

## Notes

- Secrets live in the agenix `secrets/` directory (encrypted `.age` files).
- Hermes CLI runs via `programs.hermes-agent`; the daemon via `services.hermes-agent`.