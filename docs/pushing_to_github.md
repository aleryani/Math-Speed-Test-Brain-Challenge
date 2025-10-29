# Pushing the Project to GitHub

This guide walks through the end-to-end process of publishing the existing Flutter project to a GitHub repository from the command line. It assumes you have already completed the work locally and want to share it on GitHub.

## 1. Verify the Current Branch and Status

```bash
git status -sb
```

Confirm you are on the branch you intend to push and that all desired files are tracked. Stage or discard any unrelated changes before proceeding.

## 2. Configure Remote Repository (if needed)

If you have not yet linked the local repository to GitHub, add the remote. Replace `<USERNAME>` and `<REPO>` with your GitHub username and repository name.

```bash
git remote add origin https://github.com/<USERNAME>/<REPO>.git
```

To verify the remote configuration:

```bash
git remote -v
```

## 3. Commit Your Changes

Ensure all changes you want to share are committed:

```bash
git add .
git commit -m "Describe your changes"
```

If you are amending an existing commit:

```bash
git commit --amend
```

## 4. Authenticate with GitHub

Modern GitHub workflows use personal access tokens (PAT) instead of passwords. Generate a PAT with `repo` scope and use it when prompted for a password. On the first push you may be prompted to log in via the browser if you use GitHub CLI (`gh auth login`).

## 5. Push to GitHub

Push the branch to the remote repository. Include `-u` on the first push so the branch tracks the remote counterpart.

```bash
git push -u origin <branch-name>
```

If the repository already exists and you are updating it, a regular push without `-u` is sufficient:

```bash
git push origin <branch-name>
```

## 6. Resolve Rejections (if any)

If GitHub rejects the push because your local branch is behind the remote, fetch and rebase or merge:

```bash
git fetch origin
git rebase origin/<branch-name>   # preferred for linear history
# or
git merge origin/<branch-name>
```

After resolving any conflicts, push again. Use `git push --force-with-lease` only when you intentionally rewrite history and are certain no one else has updated the remote branch.

## 7. Create a Pull Request (Optional)

Once the branch is on GitHub, open a pull request from the GitHub web UI or via `gh pr create` if you use GitHub CLI. Provide a clear description of the changes and any testing performed.

## 8. Troubleshooting Authentication Errors

- **HTTPS credential prompts**: Use a PAT or configure a credential helper (`git config --global credential.helper store`).
- **SSH authentication**: Set up an SSH key (`ssh-keygen`, `ssh-add`) and add it to your GitHub account, then use the SSH remote URL `git@github.com:<USERNAME>/<REPO>.git`.
- **2FA enabled**: You must use a PAT or SSH key; passwords will not work.

Following these steps ensures the local Flutter project is published to GitHub reliably.
