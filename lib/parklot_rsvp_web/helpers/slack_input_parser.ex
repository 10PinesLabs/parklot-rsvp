defmodule ParklotRsvpWeb.SlackInputParser do

    @create_reservation_regex ~r/(?<command>reservar|cancelar|mostrar)\s?(el)?\s?(?<scheduled_at>\d{1,2}-\d{1,2}-\d{4})?(\s?(por)?\s?(?<notes>.*))?/iu
    @date_format "%d-%m-%Y"

    def parse_create_reservation_params(params) do

        captured_params = Regex.named_captures(@create_reservation_regex, params["text"])

        validate!(captured_params)
        %{
            user: params["user_name"],
            command: String.downcase(captured_params["command"]),
            scheduled_at: scheduled_at_field(captured_params),
            notes: notes_field((captured_params))
        }
    end

    defp validate!(params) do
        if params["command"] == nil, do: raise ParklotRsvpWeb.InputError, message: "missing command"
    end

    defp notes_field(captured_params) do
        Map.get(captured_params, "notes")
    end

    defp scheduled_at_field(captured_params) do
        {:ok, scheduled_at} = Timex.parse(scheduled_at_as_string(captured_params), @date_format, :strftime)
        Timex.to_date(scheduled_at)
    end

    defp scheduled_at_as_string(captured_params) do
        scheduled_at = Map.get(captured_params, "scheduled_at")
        if scheduled_at == nil || byte_size(String.trim(scheduled_at)) == 0 do
            raise ParklotRsvpWeb.InputError, message: "missing or invalid scheduled_at"
        end
        scheduled_at
    end
end
