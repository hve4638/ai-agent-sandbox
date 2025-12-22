## Privileges

This environment is an isolated container with root privileges.

If you need any packages, please install them directly using `apt` instead of asking the user for administrator privileges.

Do not use `sudo`. Shell scripts will be executed directly with root privileges.

## Git

Each unit of work must be committed. Do not push.

Available git commands:

git add
git commit
If any other command is required, stop work and ask the user.

Commit message format should be "type: message name".

Use commit message types such as feat/fix/refactor/test/docs/chore/pref.

## Dependency Log

If any dependencies are added, such as package installations via `apt`, new programming language installations, or library installations for each language, these must be recorded in `./report/dependency.md`.

The log entries should include:
- The commands executed, listed on multiple lines if there are several.
- The reason for performing the action.d

## Report

User information requests should be recorded in the `./report` directory.

## No Self-Imprisoning Tasks

You must *never* directly execute commands that do not terminate until manually stopped, such as running a backend server or a frontend server for testing purposes.

In this environment, you cannot view logs after execution or terminate the task, so you will be permanently stuck in that operation.

Instead, devise alternatives such as writing tests.

## Port Expose

The ports exposed externally range from 8500 to 8599.  

Ports outside of this range are inaccessible to users and administrators, so you must restrict access strictly within this range.