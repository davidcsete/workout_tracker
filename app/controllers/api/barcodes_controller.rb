class Api::BarcodesController < Api::BaseController
  def index
    # API endpoint
    url = "https://platform.fatsecret.com/rest/food/barcode/find-by-id/v1"

    # Headers - you can fill these out with your API credentials
    headers = {
      "Authorization" => "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NTM2NzU3NDcsImV4cCI6MTc1Mzc2MjE0NywiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjpbImJhcmNvZGUiLCJiYXNpYyJdLCJjbGllbnRfaWQiOiJmMmY1MTVjZDJiYzc0YjE4YTIyNGM4ZDk2OTRmMjI3NCIsInNjb3BlIjpbImJhcmNvZGUiLCJiYXNpYyJdfQ.BnqiwzvGEond3PeY3dJssTr7xKG9pDvGI8tdtQ9Kz6naTQJ4PuGCMcqTT4UsutOrRcTBJwH5DejxY8P8sXfb8jyl3z-9ehTBH5pX7r9CJJHtB-DFpxOjJz5rSQwwqe82kBMZaQnpDY-KB40fZyJp4sIWoUNU1iwr7zv_tbamuExs1ujQ-GJM9vZupTJYXk90FgpbnxBsg3FVYnxZ9zKAtR_p6xKVLjctM0KIL44mP3jWvGQqA7G_aI4OfVq0Z1Wa93qvEG6sF4cDhQe4rXeYHz1w3tL-EYD5JX9oQMEmqgkQsH_TANhrZseWUfcIzzFOdsl79ZDehjMb7V3j9HPvbuVNBNuJcqemMkuWuqoVSF5pTLbFZcaIwqt5d453wLAjL1fjtpprix4pKtwDiwfmLK6g4lf821TNAM3-OFEU7--65R_oBSDHxHjuQOlA3fmAr-w2j7uuGzHLruYt-wFo57snrSWMlpksFpUuV8ACqsdc2QxtXfSJd6hC1uIiUnkWNh2irnWFh6v7SwMJkgAV8ctzPijR3f0z6PgDmdGXACsAsW0tUwOkk5EZ4ZLxxQ_F7AvPc-EViaO6meiv1ddiymTxRfn9CteP8VlQVPJRBN_g_EQiWwDYqFyAC2XGoW_VJYSkAQK8iAopsB2p6IX8ZQAme9SKJ2OwauNkE8NEmCQ",
      "Content-Type" => "application/json"
      # Add any other required headers here
    }

    # Query parameters for GET request
    query_params = {
      barcode: params[:barcode],
      format: "json"
    }

    begin
      response = HTTParty.get(url,
        headers: headers,
        query: query_params
      )
      if response.success?
        result = response.parsed_response

        # Extract food_id from the barcode response
        if result.dig("food_id", "value")
          food_id = result["food_id"]["value"]

          # Make a new GET request to the food API
          food_url = "https://platform.fatsecret.com/rest/food/v4"
          food_query_params = {
            food_id: food_id,
            format: "json"
          }

          food_response = HTTParty.get(food_url,
            headers: headers,
            query: food_query_params
          )

          if food_response.success?
            # Return both the barcode result and food details
            render json: {
              barcode_result: result,
              food_details: food_response.parsed_response
            }
          else
            # Return barcode result even if food request fails
            render json: {
              barcode_result: result,
              food_error: "Food API request failed: #{food_response.code}"
            }
          end
        else
          # No food_id found, return original barcode result
          render json: result
        end
      else
        render json: { error: "API request failed", status: response.code }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Request failed: #{e.message}" }, status: :internal_server_error
    end
  end
end
