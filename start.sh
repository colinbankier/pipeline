#!/usr/bin/env sh

if [ ! -f deps ]; then
  mix deps.get && mix compile
fi

export ERL_LIBS="$ERL_LIBS:/Users/colin.bankier/Play/pipeline"
exec iex -S mix
