defmodule ConvertWeb.DateTimeUtil do


    @doc """
    返回时间戳，但是 s
    """
    def date_to_timestamp(date_time) do
        :calendar.datetime_to_gregorian_seconds(date_time) - :calendar.datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}})
    end

    def current_timestamp() do
        # Timex.to_unix
        :calendar.datetime_to_gregorian_seconds(:calendar.local_time) - :calendar.datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}})
    end

    @doc """
    返回格式为 yyyy-MM-dd hh-mm-ss
    """
    def date_to_string({{year, month, day},{hour, min, second}}) do
        to_string(year) <> "-" <> int_to_string(month) <> "-" <> int_to_string(day)
         <> " " <> int_to_string(hour) <> ":" <> int_to_string(min) <> ":" <> int_to_string(second) 
    end

    def date_to_date_string({{year, month, day},{_hour, _min, _second}}) do
        to_string(year) <> "-" <> int_to_string(month) <> "-" <> int_to_string(day)
    end

    defp int_to_string(int) when int >= 0 do
        case int < 10 do
            true ->
                "0" <> to_string(int)
            false ->
                to_string(int)
        end
    end

end