class Gem::Commands::BumpCommand < Gem::Command
  BUMP_METHODS = ["major", "minor", "patch", "subpatch"]

  def initialize
    super("bump", "Increases the version of a .gemspec file")
  end

  def usage
    "#{program_name} [METHOD] FILE"
  end

  def arguments
    <<-ARGUMENTS
    METHOD        version to update (#{BUMP_METHODS.join(", ")})
    FILE          name of the gemspec file (you can omit the .gemspec extension)
    ARGUMENTS
  end

  def defaults_str
    "METHOD        patch"
  end

  def execute
    bump_method = options[:args][0] || ""
    gemspec = options[:args][1]

    if BUMP_METHODS.include?(bump_method)
      unless gemspec_exists?(gemspec)
        puts "No gemspec name specified"
        show_help
        return
      end
    else
      unless gemspec_exists?(bump_method)
        if gemspec_exists?(gemspec)
          puts "Invalid bump method specified."
        else
          puts "Invalid gemspec name specified."
        end
        show_help
        return
      end
      gemspec = bump_method
      bump_method = "patch"
    end
    gemspec = gemspec_file(gemspec)
    scrape_gemspec(gemspec)
    bump_gemspec_version(bump_method)
    write_gemspec_file(gemspec)
  end

  private

  def gemspec_exists?(gemspec)
    gemspec = gemspec_file(gemspec)
    !gemspec.nil? && File.file?(gemspec) 
  end

  def gemspec_file(file)
    file ||= ""
    if File.file?(file)
      file
    else
      name = "#{file}.gemspec"
      File.file?(name) ? name : nil
    end
  end

  def scrape_gemspec(gemspec_file)
    File.open(gemspec_file, "r") do |f|
      @gemspec_lines = f.readlines
    end
    @gemspec_lines.each_with_index do |l, i|
      if /(.*\.version)\s*=\s*\"(\d(\.\d)*)\"/ =~ l
        @version = {
          number: $~[2],
          line: i,
          variable: $~[1]
        }
        break
      end
    end
  end

  def bump_gemspec_version(type = "patch")
    versions = @version[:number].split(".").map(&:to_i)
    (0..3).each do |i|
      versions[i] ||= 0
      versions[i] = [0,versions[i]].max
    end
    versions = versions[0..3]
    case type
    when "major"
      versions[0] += 1
      versions[1] = 0
      versions[2] = 0
      versions[3] = 0
    when "minor"
      versions[1] += 1
      versions[2] = 0
      versions[3] = 0
    when "patch"
      versions[2] += 1
      versions[3] = 0
    when "subpatch"
      versions[3] += 1
    end
    @old_version = @version[:number]
    @version[:number] = versions[0..(versions[3]&.zero? ? 2 : 3)].join(".")
  end

  def write_gemspec_file(filename)
    @gemspec_lines[@version[:line]] = "#{@version[:variable]} = \"#{@version[:number]}\"\n"
    gem_name = filename.split("/")[-1].split(".")[0]
    puts "Bumping #{gem_name} from #{@old_version} to #{@version[:number]}"
    File.open(filename, "w") do |f|
      f.write @gemspec_lines.join
    end
  end
end
