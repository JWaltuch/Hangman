class SimpleRenderer
  def self.simple_render(num_errors, body_parts)
    parts = body_parts.each_with_index.map { |x,i|
      if num_errors > i then x else "" end
    }
    output = sprintf(
      ["+----",
       "|   %s",
       "|  %s%s%s",
       "|  %s %s",
       "^_________",
    ].join("\n"), *parts)
    output
  end
  def render(num_errors)
    body_parts = ["0", "\\", "|", "/", "/", "\\"]
    SimpleRenderer.simple_render(num_errors, body_parts);
  end
end

class EmojiRenderer
  def render(num_errors)
    body_parts = ["🤕","💪", "🍥", "☝️", "🦶", "🦵", ]
    output = SimpleRenderer.simple_render(num_errors, body_parts)
    output.sub("_________", "__🔥______")
  end
end

# renderer = SimpleRenderer.new()
# renderer = EmojiRenderer.new()
# for i in 0..7
#   puts(renderer.render(i))
# end
