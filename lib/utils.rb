def create_tag_page(base, tag, count)
    meta = {}
    meta[:title] = "Tag: #{tag}"
    meta[:kind] = 'page'
    meta[:filters_pre] = ['erb']
    meta[:feed] = "/tags/#{tag}/"
    meta[:feed_title] = "Tag '#{tag}'"
    meta[:permalink] = tag
    pl = (count == 1) ? ' is' : 's are'
    contents = %{
        <% feed = "/tags/#{tag}-atom/" %>
        <p>#{count} item#{pl} tagged with <em>#{tag}</em> (<%= link_to("subscribe", feed) %>):</p>
            <ul>
            <% items_with_tag('#{tag}').each do |a| %>
            <%= a.compiled_content :rep => :home, :snapshot => :post %>
            <% end %>
            </ul>
    }
    # Write page
    create_item base + tag + '/', meta, contents
end

def create_tag_feed_page(base, tag, format)
    f = format.downcase
    meta = {}
    meta[:title] = "Antognolli's blog - Tag '#{tag}' (#{format} Feed)"
    meta[:kind] = 'feed'
    meta[:permalink] = "tags/#{tag}/#{f}"
    contents = %{<%= #{f}_feed(:articles => items_with_tag('#{tag}'))%>}
    create_item base + tag + "-#{f}/", meta, contents
end

def write_archive_page(dir, name, count)
    meta = {}
    meta[:title] = "Archive: #{name}"
    meta[:kind] = 'page'
    meta[:filters_pre] = ['erb']
    meta[:permalink] = name.downcase.gsub /\s/, '-'
    pl = (count == 1) ? ' was' : 's were'
    contents = %{
        <p>#{count} article#{pl} written in <em>#{name}</em>:</p>
            <ul>
            <% articles_by_month.select{|i| i[0] == "#{name}"}[0][1].each do |a|%>
            <%= render 'dated_article', :article => a %>
            <% end %>
            </ul>
    }
    # Write file
    write_item dir/"#{meta[:permalink]}.html", meta, contents
end

# def write_item(path, meta, contents)
#     path.parent.mkpath
#     (path).open('w+') do |f|
#         f.print "--"
#         f.puts meta.to_yaml
#         f.puts "-----"
#         f.puts contents
#     end
# end

def create_item(base, meta, contents)
    it = Nanoc::Item.new(contents, meta, base)
    @items << it
end

def items_for_preview
    @items.select { |item| item[:kind] == 'preview' }
end

def items_published
    @items.select { |item| item[:kind] != 'preview' }
end

def filter_published(items)
    items.select { |item| item[:kind] != 'preview' }
end

def my_link_to(text, target, attributes={})
  # Find path
  path = target.is_a?(String) ? target : target.path

  if @item_rep && @item_rep.path == path
    # Create message
    "<li class=\"active\">" + link_to(text, target, attributes) + "</li>"
  else
    link_to(text, target, attributes)
  end
end
