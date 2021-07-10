require 'watir'
require 'webdrivers/chromedriver' # for updating ChromeDriver

require 'json'

# Each method represents a step in the Authorization Code Flow from https://developer.spotify.com/documentation/general/guides/authorization-guide/#authorization-code-flow

class SpotifyAuthorization
    def initialize(client_id, client_secret, redirect_uri, username, password)
        @CLIENT_ID = client_id
        @CLIENT_SECRET = client_secret # Normally kept in an environment variable for security reason !
        @REDIRECT_URI = redirect_uri

        @USERNAME = 'ildedgd6c4eslo2v78c0e9prg'
        @PASSWORD = 'ruby_task_1'
        @RESPONSE_TYPE = 'code'
        
        @URL = "https://accounts.spotify.com/authorize?client_id=#{@CLIENT_ID}&response_type=#{@RESPONSE_TYPE}&redirect_uri=#{@REDIRECT_URI}"
        @TOKEN_URL = 'https://accounts.spotify.com/api/token'

        @access_token = false
        @refresh_token = false
    end

    # Reutrns authorization code
    def request_spotify_authorization()
        # starting Watir

        # Watir.default_timeout = 180
        browser = Watir::Browser.start @URL

        # writing to the form

        username_input = browser.text_field(id: 'login-username')
        password_input = browser.text_field(id: 'login-password')

        username_input.set @USERNAME
        password_input.set @PASSWORD

        # submitting the form and granting permissions

        browser.button(id: 'login-button').click
        browser.button(id: 'auth-accept').click

        # grabbing the authorization code for the next step of authorization
        response_query = CGI.parse(URI.parse(browser.url).query)
        code = response_query['code'][0] # the authorization code

        # closing the browser and returning the authorization code

        browser.close
        code
    end

    def request_tokens(code)
        # constructing the request body and setting headers

        body = {
            grant_type: 'authorization_code',
            code: code,
            redirect_uri: @REDIRECT_URI,
            client_id: @CLIENT_ID,
            client_secret: @CLIENT_SECRET }

        headers = { content_type: 'application/x-www-form-urlencoded'}

        # making the request and grabbing the tokens from its response

        begin
            response = RestClient.post @TOKEN_URL, body, headers
        rescue
            return false, false
        else
            body = JSON.parse(response.body)
            @access_token = body['access_token']
            @refresh_token = body['refresh_token']
        end

        return @access_token, @refresh_token
    end

    # helper function to check if request_tokens returned actual tokens instead of false, false
    def check_tokens(t1, t2)
        @access_token and @refresh_token ? true : false
    end

    # helper function for adding Authorization header to a headers hash
    def add_authorization_header(headers)
        headers['Authorization'] = "Bearer #{@access_token}"
    end
end
