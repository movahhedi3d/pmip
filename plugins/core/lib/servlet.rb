require 'webrick'

class PMIPServlet < WEBrick::HTTPServlet::AbstractServlet
  def initialize(config, args = [])
    super
    @args = args
  end

  def do_GET(request, response)
    waiting = true
    context = PMIPContext.new
    reset_result
    StatusBar.new(context).set("Running #{name} ...")
    track(name)
    Run.later {
      begin
        @params = Params.new(request.query_string)
        get(request, response, context)
        response.status = 200
        message = "#{name}: #{@result}"
        puts "- #{message}"
        StatusBar.new(context).set(message)
      rescue => e
        message = "Error: #{e.message}:\n#{e.backtrace.join("\n")}"
        puts message
        response.body = message
        Dialogs.new(context).error("PMIP Plugin Error", "PMIP encounted an error while executing the action: " + name + "\n\n" + message + "\n\nPlease contact the plugin developer!")
        StatusBar.new(context).set(message)
      ensure
        waiting = false
      end
    }

    while waiting
      #TODO: should there be some kind of max timeout in here
    end
  end

  protected

  def result(result)
    @result = result.is_a?(Array) ? result.join(', ') : result.to_s
    @result
  end

  def params
    @params
  end

  private

  def name
    @name.nil? ? self.class.to_s : @name
  end

  #TODO: is this used?
  def reset_result
    result('Nothing to do')
  end
end

class Params
  def initialize(query)
    return if query.nil?
    @key_to_value = query.split('&').inject({}) do |key_to_value, pair|
      bits = pair.split('=')
      key_to_value[bits[0]] = bits[1]
      key_to_value
    end
  end

  def [](key)
    @key_to_value[key]
  end

  def has_key?(key)
    @key_to_value.has_key?(key)
  end
end