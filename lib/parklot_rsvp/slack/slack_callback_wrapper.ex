defmodule ParklotRsvp.Slack.SlackCallbackWrapper do

  alias ParklotRsvp.Schedule.Reservation

  @http_adapter Application.get_env(:parklot_rsvp, :http_adapter)
  @slack_url "https://hooks.slack.com/services/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"
  @http_options [{"Content-Type", "application/json"}]

  require Logger

  def send_reservation_callback(confirmed_reservation) do
    @slack_url
    |> post_url(build_body(confirmed_reservation), @http_options)
    |> process_response_body(@slack_url)
  end

  def send_no_reservation_callback(a_date) do
    text = "No hay ninguna reserva para el dia [#{a_date}]. Podes tomar la cochera y avisar por Whatsapp!"

    @slack_url
      |> post_url(%{text: text}, @http_options)
      |> process_response_body(@slack_url)
  end

  defp build_body(confirmed_reservation) do
    title = "La cochera ha sido asignada a #{confirmed_reservation.user} en la fecha #{confirmed_reservation.scheduled_at}. Relacionado al trabajo? #{confirmed_reservation.work_related}"
    attachments = [%{title: title, text: inspect(Reservation.to_map(confirmed_reservation))}]

    %{text: "Reserva confirmada!", attachments: attachments}
     |> Poison.encode!
  end

  defp post_url(url, body, options) do
    Logger.debug body
    @http_adapter.post(url, body, options)
  end

  defp process_response_body(
    {:ok, %HTTPoison.Response{status_code: status_code, body: body}},
    _url) when status_code in [200, 201, 204],
    do: {:ok, parse_body(body)}

  defp process_response_body(
    {:ok, %HTTPoison.Response{status_code: status_code, body: body, headers: _}},
    url) do
    {:error,
      %{
        status_code: status_code,
        body: parse_body(body),
        url: url
      }
    }
  end

  defp process_response_body({:error, %HTTPoison.Error{reason: {_, reason}}}, _url),
    do: {:error, reason}

  defp process_response_body({:error, %HTTPoison.Error{reason: reason}}, _url),
    do: {:error, reason}

  defp process_response_body({:error, reason}, _url),
    do: {:error, reason}

  defp parse_body(body) do
    with {:ok, body} <- Poison.Parser.parse(body, keys: :atoms) do
      body
    else
      _ -> body
    end
  end
end
