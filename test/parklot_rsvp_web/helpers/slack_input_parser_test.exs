defmodule ParklotRsvpWeb.SlackInputParserTest do
    use ExUnit.Case, async: true
    use ExMatchers

    alias ParklotRsvpWeb.SlackInputParser

    describe "parse command" do
        test "reservar" do
            params = %{"text" => "reservar el 19-01-2001", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:command], to: eq("reservar")
        end
        test "reservar ignore case" do
            params = %{"text" => "RESERVAR el 19-01-2001", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:command], to: eq("reservar")
        end
        test "cancelar" do
            params = %{"text" => "cancelar el 19-01-2001", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:command], to: eq("cancelar")
        end
        test "mostrar" do
            params = %{"text" => "mostrar el 19-01-2001", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:command], to: eq("mostrar")
            expect result[:scheduled_at], to: eq(~D[2001-01-19])
        end
        test "missing" do
            params = %{"text" => "el 19-01-2001", "user_name" => "jose"}
            fun = fn() -> SlackInputParser.parse_create_reservation_params(params) end

            expect fun, to: raise_error(ParklotRsvpWeb.InputError),
                      with: "missing command"
        end
        test "unknown" do
            params = %{"text" => "damela el 19-01-2001", "user_name" => "jose"}
            fun = fn() -> SlackInputParser.parse_create_reservation_params(params) end

            expect fun, to: raise_error(ParklotRsvpWeb.InputError),
                      with: "missing command"
        end
    end

    describe "parse scheduled_at" do
        test "with 'el' prefix" do
            params = %{"text" => "reservar el 19-01-2001", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:scheduled_at], to: eq(Timex.to_date({2001, 1, 19}))
        end

        test "without 'el' prefix" do
            params = %{"text" => "reservar 19-01-2001", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:scheduled_at], to: eq(Timex.to_date({2001, 1, 19}))
        end

        test "with notes" do
            params = %{"text" => "reservar el 19-01-2001 por motivos varios", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:scheduled_at], to: eq(Timex.to_date({2001, 1, 19}))
        end

        test "missing is today" do
            params = %{"text" => "reservar por motivos varios", "user_name" => "jose"}
            fun = fn() -> SlackInputParser.parse_create_reservation_params(params) end

            expect fun, to: raise_error(ParklotRsvpWeb.InputError),
                      with: "missing or invalid scheduled_at"
        end
    end

    describe "parse notes" do
        test "with 'por' prefix" do
            params = %{"text" => "reservar el 19-01-2001 por motivos varios", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:notes], to: eq("motivos varios")
        end
        test "without 'por' prefix" do
            params = %{"text" => "reservar el 19-01-2001 motivos varios", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:notes], to: eq("motivos varios")
        end

        test "is missing" do
            params = %{"text" => "reservar el 19-01-2001", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:notes], to: be_empty()
        end

        test "is missing with 'por' prefix" do
            params = %{"text" => "reservar el 19-01-2001 por", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:notes], to: be_empty()
        end
    end

    describe "username" do
        test "is present" do
            params = %{"text" => "reservar el 19-01-2001 motivos varios", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:user], to: eq("jose")
        end

        test "is missing" do
            params = %{"text" => "reservar el 19-01-2001 motivos varios"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:user], to: be_empty()
        end
    end
end
