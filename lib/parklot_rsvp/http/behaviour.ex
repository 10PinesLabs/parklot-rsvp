defmodule Http.Behaviour do
  @typep url     :: binary()
  @typep body    :: {:form, [{atom(), any()}]}
  @typep options :: Keyword.t()

  @callback post(url, body, options) :: {:ok, map()} | {:error, binary() | map()}
end

defmodule Http.GoogleBehaviour.Connection do
  @callback new(String.t()) :: Tesla.Env.client()
end

defmodule Http.GoogleBehaviour.Api do
  @callback calendar_events_insert(Tesla.Env.client(), String.t(), keyword()) ::
  {:ok, GoogleApi.Calendar.V3.Model.Event.t()} | {:error, Tesla.Env.t()}
end

defmodule Http.GoogleBehaviour.TokenProvider do
  @callback for_scope(String.t()) :: {:ok, any()}
end
