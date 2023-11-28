# dots

This is a repository of my (Eli Gundry) dotfiles.

## Path of the Winner

```bash
brew install yadm
cd ~
yadm clone https://github.com/eligundry/dots.git
yadm bootstrap
```

## litestream-zsh-histdb-s3

As a part of a long term project for me, I want to keep track of every shell
command I ever type on every machine I work on. This is accomplished with
[`zsh-histdb`](https://github.com/larkery/zsh-histdb), which saves commands to
a sqlite3 database, which is then continuously replicated to S3 with
[litestream](https://litestream.io/) via a background process setup with
[serviceman](https://webinstall.dev/serviceman/).

### Installation

1. Run the bootstrapping process described above
2. Set the AWS access keys in `~/.config/envman/ENV.env` in this format:
  ```bash
  AWS_ACCESS_KEY_ID='xxx'
  AWS_SECRET_ACCESS_KEY='xxx'
  ```
3. Run `./.local/bin/install-zsh-histdb-sync.sh`
