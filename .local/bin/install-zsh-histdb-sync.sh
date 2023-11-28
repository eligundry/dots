#!/bin/bash
serviceman add \
  --desc "Sync zsh-histdb to S3" \
  --name "litestream-zsh-histdb-s3" \
  --title "litestream-zsh-histdb-s3" \
  --username "$(whoami)"  \
  --path -- litestream replicate -config "$HOME/.histdb/litestream.yml"
