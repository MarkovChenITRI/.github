# Instruction Context Boundaries

This document records the rationale for keeping Copilot-facing instructions terse and execution-oriented.

## Purpose

- Keep `.github/instructions/*.instructions.md` focused on directives Copilot should load and act on.
- Move design rationale, trade-offs, and repository-governance notes into `docs/` so they do not expand the instruction context.
- Prevent stage-specific SOPs from duplicating each other inside a single instruction file.

## Writing rule

- In instructions, write as if instructing Copilot what to load, what to do, and what output to produce.
- In docs, write why the structure exists, what trade-offs were chosen, and how maintainers should evolve it.

## Practical boundary

- Instructions: stage-specific contracts, input/output requirements, ownership, and completion criteria.
- Docs: rationale, governance notes, maintenance guidance, and cross-stage architectural explanation.