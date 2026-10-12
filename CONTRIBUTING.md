# Contributing to AetherOS

Thank you for your interest in contributing to AetherOS!

## Code Style & Guidelines
1. **Device Trees:** Keep device-specific flags inside `device/<vendor>/<codename>/` and universal configurations inside `custom/`.
2. **SELinux:** Avoid adding permissive domain transitions (`permissive <domain>;`). Always create strict least-privilege rules for Enforcing mode.
3. **Commit Messages:** Follow conventional commits format:
   - `feat(device): ...`
   - `fix(sepolicy): ...`
   - `perf(ui): ...`
   - `docs: ...`
   - `refactor: ...`

## Testing Submissions
Before opening a pull request, run the integrity validation script:
```bash
python3 scripts/verify_project_syntax.py
```
All checks must pass without errors.
