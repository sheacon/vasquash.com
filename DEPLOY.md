# Deploying vasquash.com

The site is currently live at https://sheacon.github.io/vasquash.com/

To point the real domain (vasquash.com) to GitHub Pages:

## 1. Add the CNAME file

Create a file called `CNAME` in the repo root containing just:

```
vasquash.com
```

Commit and push it.

## 2. Update DNS at your domain registrar

Add these records where vasquash.com is registered:

**A records** (point the root domain to GitHub Pages):

| Type | Name | Value |
|------|------|-------|
| A | @ | 185.199.108.153 |
| A | @ | 185.199.109.153 |
| A | @ | 185.199.110.153 |
| A | @ | 185.199.111.153 |

**CNAME record** (point www to GitHub):

| Type | Name | Value |
|------|------|-------|
| CNAME | www | sheacon.github.io |

Remove any existing A or CNAME records that conflict with these.

## 3. Wait for DNS propagation

DNS changes can take up to 48 hours, but usually work within minutes. GitHub will automatically provision a free TLS certificate once DNS is verified.

## 4. Verify in GitHub

Go to https://github.com/sheacon/vasquash.com/settings/pages and confirm:
- Custom domain shows `vasquash.com`
- "Enforce HTTPS" is checked

## Updating the site

Edit files locally (or directly on GitHub), commit, and push to `main`. The site updates within about 60 seconds.
