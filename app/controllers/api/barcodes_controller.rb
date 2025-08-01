class Api::BarcodesController < Api::BaseController
  def index
    # API endpoint
    url = "https://platform.fatsecret.com/rest/food/barcode/find-by-id/v1"

    # Get headers with current token
    headers = get_api_headers

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

      # Check if token is expired and retry with new token
      if response.code == 200 && response.parsed_response.dig("error", "code") == 13
        headers = get_api_headers(refresh: true)
        response = HTTParty.get(url,
          headers: headers,
          query: query_params
        )
      end

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

          # Check if token is expired for food API call too
          if food_response.code == 200 && food_response.parsed_response.dig("error", "code") == 13
            headers = get_api_headers(refresh: true)
            food_response = HTTParty.get(food_url,
              headers: headers,
              query: food_query_params
            )
          end

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

  private

  def get_api_headers(refresh: false)
    token = refresh ? get_new_token : get_cached_token
    {
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json"
    }
  end

  def get_cached_token
    # Return cached token if available and not expired
    # For now, return the hardcoded token - you can implement caching later
    "eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NTM4Njg2NzcsImV4cCI6MTc1Mzk1NTA3NywiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjpbImJhcmNvZGUiLCJiYXNpYyJdLCJjbGllbnRfaWQiOiJmMmY1MTVjZDJiYzc0YjE4YTIyNGM4ZDk2OTRmMjI3NCIsInNjb3BlIjpbImJhcmNvZGUiLCJiYXNpYyJdfQ.wuiwpJu2D-gml_y3lmcd9GKbZV1TEUv93yHoAOKtQsH4pNgthbB1M7GiY4pvzf1kf7fzR98g-dcNHVcvKO4qYeU4hOYMEMxX5dbxIcTOtMWwVFBu7jDLrbDVyDNjVSwFqC4A7bKYLGU29q6EVDeHWe96pyW8aefGuHdL1li4yH1BMihOyZhqQvikUfkfrmbODmQjpqUdeUWz-ZMjLjt0ni2mEYlM1QqXgumdabaPkVtEvWmzdLR7LFzGLlQyN7scWgZ12hkE5mnlHSuntPtfpDK4UoJBeYeuO34ICIUNSdzW2rRBN_MlBSUuUXi7YJruzF__MohwL3Bp5sZm2lbRTD245iETrjgnyq3BOBqYOWV3BLTsrWQM-kAtiyg-Jg33WpRjkB1Gmz-zky2djdePbha7SMJuWavLWWUkXt9e-55hsJbocpNkC4hNtgogOkElz5uQbDqYr3IiIyPK3USq54zyI3slE1ek8Zfa5ec9mD4WuI-d9-ai6TbdJSutuXHzuPkwwtBDCkkKLY44XcRBQmUOO3P4Mk5P5mv6XbctHHMyyZCHWoGctN2lH4wcNHbEWN67L4EC7lmelmc83ZQpAhc2-CZUWc6-Bj-mNL1oM2IkYkuSvS1LlT3lkCRs8B_JJnqIc66RTt4S-s5JbMiCmvjhgfriLpxDDzNoyu3-I74"
  end

  def get_new_token
    client_id = ENV["CLIENT_ID"]
    client_secret = ENV["CLIENT_SECRET"]

    url = "https://oauth.fatsecret.com/connect/token"

    response = HTTParty.post(url,
      basic_auth: {
        username: client_id,
        password: client_secret
      },
      headers: {
        "Content-Type" => "application/x-www-form-urlencoded"
      },
      body: {
        "grant_type" => "client_credentials",
        "scope" => "barcode basic"
      }
    )

    if response.success?
      token_data = response.parsed_response
      # You can cache this token and its expiration time here
      token_data["access_token"]
    else
      raise "Failed to get new token: #{response.code} - #{response.body}"
    end
  end
end
