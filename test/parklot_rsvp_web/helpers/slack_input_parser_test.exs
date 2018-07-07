defmodule ParklotRsvpWeb.SlackInputParserTest do
    use ExUnit.Case, async: true
    use ExMatchers
  
    alias ParklotRsvpWeb.SlackInputParser

    describe "parse scheduled_at" do
        test "with 'el' prefix" do
            params = %{"text" => "el 19-01-2001", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:scheduled_at], to: eq(Timex.to_date({2001, 1, 19}))
        end

        test "without 'el' prefix" do
            params = %{"text" => "19-01-2001", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:scheduled_at], to: eq(Timex.to_date({2001, 1, 19}))
        end

        test "with notes" do
            params = %{"text" => "el 19-01-2001 por motivos varios", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)

            expect result[:scheduled_at], to: eq(Timex.to_date({2001, 1, 19}))
        end
    end

    describe "parse notes" do
        test "with 'por' prefix" do
            params = %{"text" => "el 19-01-2001 por motivos varios", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)
    
            expect result[:notes], to: eq("motivos varios")            
        end 
        test "without 'por' prefix" do
            params = %{"text" => "el 19-01-2001 motivos varios", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)
    
            expect result[:notes], to: eq("motivos varios")            
        end 

        test "is missing" do
            params = %{"text" => "el 19-01-2001", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)
    
            expect result[:notes], to: be_empty()
        end 

        test "is missing with 'por' prefix" do
            params = %{"text" => "el 19-01-2001 por", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)
    
            expect result[:notes], to: be_empty()
        end 
    end
    
    describe "username" do
        test "is present" do
            params = %{"text" => "el 19-01-2001 motivos varios", "user_name" => "jose"}
            result = SlackInputParser.parse_create_reservation_params(params)
        
            expect result[:user], to: eq("jose")                        
        end

        test "is missing" do
            params = %{"text" => "el 19-01-2001 motivos varios"}
            result = SlackInputParser.parse_create_reservation_params(params)
        
            expect result[:user], to: be_empty()
        end
    end
end
