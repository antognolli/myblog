require 'nanoc3/tasks'
require "#{Dir.pwd}/lib/utils.rb"

task :tags do
    site = Nanoc3::Site.new('.')
    dir = Pathname("#{Dir.pwd}/content/tags")
    dir.rmtree if dir.exist?
    dir.mkpath
    tags = {}
    # Collect tag and page data
    site.items.each do |p|
      next unless p.attributes[:tags]
      p.attributes[:tags].each do |t|
        if tags[t]
          tags[t] = tags[t]+1
        else
          tags[t] = 1
        end
      end
    end
    # Write pages
    tags.each_pair do |k, v|
      write_tag_page dir, k, v
#      write_tag_feed_page dir, k, 'RSS'
      write_tag_feed_page dir, k, 'Atom'
    end
end
