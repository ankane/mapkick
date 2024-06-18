module Mapkick
  module Helper
    def js_map(data_source, **options)
      mapkick_map "Map", data_source, **options
    end

    def area_map(data_source, **options)
      mapkick_map "AreaMap", data_source, **options
    end

    private

    # don't break out options since need to merge with default options
    def mapkick_map(type, data_source, **options)
      options = Mapkick::Utils.deep_merge(Mapkick.options, options)

      @mapkick_map_id ||= 0
      element_id = options.delete(:id) || "map-#{@mapkick_map_id += 1}"

      height = (options.delete(:height) || "500px").to_s
      width = (options.delete(:width) || "100%").to_s

      nonce = options.fetch(:nonce, true)
      options.delete(:nonce)
      if nonce == true
        # Secure Headers also defines content_security_policy_nonce but it takes an argument
        # Rails 5.2 overrides this method, but earlier versions do not
        if respond_to?(:content_security_policy_nonce) && (content_security_policy_nonce rescue nil)
          # Rails 5.2+
          nonce = content_security_policy_nonce
        elsif respond_to?(:content_security_policy_script_nonce)
          # Secure Headers
          nonce = content_security_policy_script_nonce
        else
          nonce = nil
        end
      end
      nonce_html = nonce ? " nonce=\"#{ERB::Util.html_escape(nonce)}\"" : nil

      # html vars
      html_vars = {
        id: element_id,
        height: height,
        width: width,
        # don't delete loading option since it needs to be passed to JS
        loading: options[:loading] || "Loading..."
      }

      [:height, :width].each do |k|
        # limit to alphanumeric and % for simplicity
        # this prevents things like calc() but safety is the priority
        # dot does not need escaped in square brackets
        raise ArgumentError, "Invalid #{k}" unless /\A[a-zA-Z0-9%.]*\z/.match?(html_vars[k])
      end

      html_vars.each_key do |k|
        # escape all variables
        # we already limit height and width above, but escape for safety as fail-safe
        # to prevent XSS injection in worse-case scenario
        html_vars[k] = ERB::Util.html_escape(html_vars[k])
      end

      html = %(<div id="%{id}" style="height: %{height}; width: %{width};"><div style="height: %{height}; text-align: center; color: #999; line-height: %{height}; font-size: 14px; font-family: 'Lucida Grande', 'Lucida Sans Unicode', Verdana, Arial, Helvetica, sans-serif;">%{loading}</div></div>) % html_vars

      # access token
      access_token = options.delete(:access_token) || options.delete(:accessToken) || ENV["MAPBOX_ACCESS_TOKEN"]
      if access_token
        # can bypass with string keys
        # but should help prevent common errors
        if access_token.start_with?("sk.")
          raise Mapkick::Error, "Expected public access token"
        elsif !access_token.start_with?("pk.")
          raise Mapkick::Error, "Invalid access token"
        end
        options[:accessToken] = access_token
      end

      # js vars
      js_vars = {
        type: type,
        id: element_id,
        data: data_source,
        options: options
      }
      js_vars.each_key do |k|
        js_vars[k] = Mapkick::Utils.json_escape(js_vars[k].to_json)
      end
      createjs = "new Mapkick[%{type}](%{id}, %{data}, %{options});" % js_vars

      # don't rerun JS on preview
      js = <<~JS
        <script#{nonce_html}>
          (function() {
            if (document.documentElement.hasAttribute("data-turbolinks-preview")) return;
            if (document.documentElement.hasAttribute("data-turbo-preview")) return;

            var createMap = function() { #{createjs} };
            if ("Mapkick" in window) {
              createMap();
            } else {
              window.addEventListener("mapkick:load", createMap, true);
            }
          })();
        </script>
      JS

      html += "\n#{js}"

      html.respond_to?(:html_safe) ? html.html_safe : html
    end
  end
end
