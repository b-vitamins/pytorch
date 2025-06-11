# Agent Development Guidelines

This repository does not ship agent instructions. The following rules are provided to help future automation contribute effectively.

## Commit Message Standards
- Use **Conventional Commits** format.
- Example: `feat: add support for custom tensor`.
- Keep messages concise (50 characters max for the subject line).
- Use the body section to explain *why* the change was made.

## Commit Sequencing Guidelines
- Keep commits atomic and logically grouped.
- New tests should be added in the same commit as the feature they verify.
- Refactors must not mix functional changes with style fixes.

## Pull Request Standards
- Title should summarize the change using sentence case.
- Description must include: Summary, Testing, and Future Work sections.
- Link to relevant issues when available.
- PRs are ready for review only when all tests pass locally.

## Code Housekeeping
- Run `make setup-lint` before committing to ensure lint configuration is up to date.
- Use `lintrunner` to run lint checks locally: `make lint`.
- Remove dead code and unused dependencies when discovered.
- Security scans should be run periodically using `lintrunner` security hooks.

## Architecture and Design
- Major architectural changes should be documented using ADRs in `docs/adr/`.
- Prefer modular design with clear boundaries between `torch`, `caffe2`, `torchgen`, and other subpackages.
- Public APIs must remain backward compatible unless a major version bump is planned.

## Pre-commit Checks
- Ensure `lintrunner init` has been executed to fetch linter binaries.
- Run `make lint` and `python test/run_test.py --subset=quick` before committing.
- Commit messages are validated with the Conventional Commits spec.

## Version Management
- Follow **SemVer**. Increment:
  - **MAJOR** for API incompatible changes.
  - **MINOR** for backward compatible functionality.
  - **PATCH** for bug fixes and documentation only changes.
- Tag releases as `v<major>.<minor>.<patch>`.

## CHANGELOG Maintenance
- Update `CHANGELOG.md` under an `Unreleased` section for every PR that affects users.
- Categorize entries as Added, Changed, Deprecated, Removed, Fixed, or Security.
- Reference PR numbers and dates when releasing.

## Testing Standards
- Prefer `python test/run_test.py` for the full suite.
- Quick checks can use `python test/run_test.py --subset=quick`.
- Tests should be named `test_*` and placed in the `test/` directory.
- Maintain high coverage for new code paths.

## Documentation Standards
- Public functions and classes require docstrings formatted for Sphinx.
- Update `README.md` or relevant docs when user-facing behavior changes.
- Examples included in docs must execute successfully under `make html`.

