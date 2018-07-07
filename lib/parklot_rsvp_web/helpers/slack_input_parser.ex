defmodule ParklotRsvpWeb.SlackInputParser do

    @create_reservation_regex ~r/(el)?\s?(?<scheduled_at>\d{1,2}-\d{1,2}-\d{4})(\s?(por)?\s?(?<notes>.*))?/
    @date_format "%d-%m-%Y"

    def parse_create_reservation_params(params) do

        captured_params = Regex.named_captures(@create_reservation_regex, params["text"])                        

        %{
            user: params["user_name"], 
            scheduled_at: scheduled_at_field(captured_params), 
            notes: notes_field((captured_params))
        }
    end

    defp notes_field(captured_params) do
        Map.get(captured_params, "notes")
    end

    defp scheduled_at_field(captured_params) do 
        {:ok, scheduled_at} = Timex.parse(scheduled_at_as_string(captured_params), @date_format, :strftime)
        Timex.to_date(scheduled_at)
    end

    defp scheduled_at_as_string(captured_params) do 
        Map.get(captured_params, "scheduled_at", today_as_string())
    end

    defp today_as_string do
        {:ok, today} = Timex.format(Timex.today, @date_format, :strftime)  
        today
    end
end