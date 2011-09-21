def write_tag_page(dir, tag, count)
    meta = {}
    meta[:title] = "Tag: #{tag}"
    meta[:type] = 'page'
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
            <%= a.compiled_content :rep => :intro, :snapshot => :post %>
            <% end %>
            </ul>
    }
    # Write page
    write_item Pathname("#{dir}/#{tag}.html"), meta, contents
end

def write_tag_feed_page(dir, tag, format)
    f = format.downcase
    meta = {}
    meta[:title] = "H3RALD - Tag '#{tag}' (#{format} Feed)"
    meta[:type] = 'feed'
    meta[:permalink] = "tags/#{tag}/#{f}"
    contents = %{<%= #{f}_feed(:articles => items_with_tag('#{tag}'))%>}
    write_item Pathname("#{dir}/#{tag}-#{f}.xml"), meta, contents
end

def write_archive_page(dir, name, count)
    meta = {}
    meta[:title] = "Archive: #{name}"
    meta[:type] = 'page'
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

def write_item(path, meta, contents)
    path.parent.mkpath
    (path).open('w+') do |f|
        f.print "--"
        f.puts meta.to_yaml
        f.puts "-----"
        f.puts contents
    end
end
