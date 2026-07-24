## Privileges

This environment is an isolated container with root privileges.

If you need any packages, please install them directly using `apt` instead of asking the user for administrator privileges.

Do not use `sudo`. Shell scripts will be executed directly with root privileges.

## Git

Each unit of work must be committed. Do not push.

Available git commands:
- git add
- git commit

If any other command is required, stop work and ask the user.

Commit message format should be "type: message name".

Use commit message types such as feat/fix/refactor/test/docs/chore/pref.
