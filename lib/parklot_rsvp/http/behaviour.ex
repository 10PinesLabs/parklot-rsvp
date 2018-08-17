defmodule Http.Behaviour do
  @typep url     :: binary()
  @typep body    :: {:form, [{atom(), any()}]}
  @typep options :: Keyword.t()

  @callback post(url, body, options) :: {:ok, map()} | {:error, binary() | map()}
end
