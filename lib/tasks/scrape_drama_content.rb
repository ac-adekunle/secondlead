require 'open-uri'

class ScrapeDramaContent

  def initialize(url)
    @doc   = Nokogiri::HTML(open(url))
    add_content_to_db
  end

  def scrape_name
    @doc.search('.info-card h3 > span').map { |element| element.inner_text }[0]
  end

  def scrape_non_english_name
    @doc.search('.info-card h3 > span').map { |element| element.inner_text }[1].gsub(/[()]/, "")
  end

  def scrape_episode_count
    @doc.search('.quickview').map { |element| element.inner_text }[0].gsub(/[a-z\-|]/i, "").slice(2..3)
  end

  def scrape_release_date
    @doc.search('.quickview').map { |element| element.inner_text }[0].gsub(/[a-z\-|]/i, "").slice(-4..-1)
  end

  def scrape_plot
    if @doc.search('.short-descrip > p').map { |element| element.inner_text } != nil
      @doc.search('.short-descrip > p').map { |element| element.inner_text }[0].strip != nil
    else
      nil
    end
  end

  def scrape_image_url
    if @doc.search('.series-thumbnail > img').map { |element| element['src'] }[0] != nil
    "http:" + @doc.search('.thumbinner a > img').map { |element| element['src'] }[0]
    else
      nil
    end
  end

  def scrape_cast
    @doc.search('.actor-info h4 > a').map { |element| element.inner_text }
  end

  def scrape_genre
    @doc.search('.theme-list li > a').map { |element| element.inner_text }
  end

  def add_content_to_db
    if scrape_image_url != nil
      @drama = Drama.create!(name: scrape_name, poster: URI.parse(scrape_image_url))
    else
      @drama = Drama.create!(name: scrape_name)
    end
    @drama.update_attributes(
      non_english_name: scrape_non_english_name,
      episode_count:    scrape_episode_count,
      release_date:     scrape_release_date,
      plot:             scrape_plot
    )
  end
end
